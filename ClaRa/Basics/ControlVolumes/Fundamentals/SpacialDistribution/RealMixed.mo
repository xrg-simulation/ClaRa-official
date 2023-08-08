within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model RealMixed "Mixing | Real | outlet states depending volume fractions | All geometries"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.4.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//
  import ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealMixing;
  parameter Units.VolumeFraction eps_mix[2]={0.2,0.8} "Volume fraction V_1/V_tot of min/max mixed outlet" annotation (Dialog(group="Ouflow Behaviour"));

  Units.MassFraction steamQuality_in[geo.N_inlet] "Inlet steam quality";
  Units.MassFraction steamQuality_out[geo.N_outlet] "Outlet steam quality";

protected
  constant Units.MassFlowRate m_flow_eps=1e-3;
  Units.EnthalpyMassSpecific h_bubin[geo.N_inlet] "Inlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_bubout[geo.N_outlet] "Outlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewin[geo.N_inlet] "Inlet dew spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewout[geo.N_outlet] "Outlet dew spec. enthalpy";
equation
  //_________________________Allocate mass flow rates to the two zones_____________
  m_flow_inliq = {(2 - zoneAlloc_in[i])*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_invap = {(zoneAlloc_in[i] - 1)*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_outliq = {(2 - zoneAlloc_out[i])*iCom.m_flow_out[i] for i in 1:geo.N_outlet};
  m_flow_outvap = {(zoneAlloc_out[i] - 1)*iCom.m_flow_out[i] for i in 1:geo.N_outlet};

  H_flow_inliq = {SZT(
    m_flow_inliq[i]*min(h_bubin[i], iCom.h_in[i]),
    (2 - zoneAlloc_in[i])*iCom.m_flow_in[i]*iCom.h[1],
    iCom.m_flow_in[i],
    1e-4) for i in 1:geo.N_inlet};
  H_flow_invap = {SZT(
    m_flow_invap[i]*max(h_dewin[i], iCom.h_in[i]),
    (zoneAlloc_in[i] - 1)*iCom.m_flow_in[i]*iCom.h[2],
     iCom.m_flow_in[i],
     1e-4) for i in 1:geo.N_inlet};

   H_flow_outliq = {SZT(
     m_flow_outliq[i]*min(h_bubout[i], iCom.h_out[i]),
     (2 - zoneAlloc_out[i])*iCom.m_flow_out[i]*iCom.h[1],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};

   H_flow_outvap = {SZT(
     m_flow_outvap[i]*max(h_dewout[i], iCom.h_out[i]),
     (zoneAlloc_out[i] - 1)*iCom.m_flow_out[i]*iCom.h[2],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};
  //_________________________Calculattion of additional media data_________________
  steamQuality_in = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_in[i],
    iCom.h_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  steamQuality_out = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_out[i],
    iCom.h_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};
  h_bubin = {TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi(
    iCom.p_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  h_dewin = {TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi(
    iCom.p_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  h_bubout = {TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi(
    iCom.p_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};
  h_dewout = {TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi(
    iCom.p_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};

  //_________________________Calculation of the Level______________________________

  level_abs = -1;
  level_rel = iCom.volume[1]/geo.volume;

  //_________________________Calculation of the outflowing enthalpy _________________
  for i in 1:iCom.N_outlet loop
    zoneAlloc_out[i] = Stepsmoother(
      -m_flow_eps*0,
      m_flow_eps,
      iCom.m_flow_out[i])*Stepsmoother(
      eps_mix[1],
      eps_mix[2],
      iCom.volume[1]/geo.volume) + Stepsmoother(
      m_flow_eps,
      -m_flow_eps*0,
      iCom.m_flow_out[i])*steamQuality_out[i] + 1;
  end for;
  for i in 1:iCom.N_inlet loop
    zoneAlloc_in[i] = Stepsmoother(
      -m_flow_eps*0,
      m_flow_eps,
      iCom.m_flow_in[i])*Stepsmoother(
      eps_mix[1],
      eps_mix[2],
      iCom.volume[1]/geo.volume) + Stepsmoother(
      m_flow_eps,
      -m_flow_eps*0,
      iCom.m_flow_in[i])*steamQuality_in[i] + 1;
  end for;

  //__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in = zeros(geo.N_inlet);
  Delta_p_geo_out = zeros(geo.N_outlet);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end RealMixed;
