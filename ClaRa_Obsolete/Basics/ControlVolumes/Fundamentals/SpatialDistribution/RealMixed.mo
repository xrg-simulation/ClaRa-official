within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution;
model RealMixed "Mixing | Real | outlet states depending volume fractions | All geometries"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//
  import ClaRa.Basics.Functions.Stepsmoother;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealMixing;
  extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_1;
  parameter ClaRa.Basics.Units.VolumeFraction eps_mix[2]={0.2,0.8} "Volume fraction V_1/V_tot of min/max mixed outlet";

protected
  ClaRa.Basics.Units.MassFraction steamQuality_in[geo.N_inlet];
  ClaRa.Basics.Units.MassFraction steamQuality_out[geo.N_outlet];
  constant ClaRa.Basics.Units.MassFlowRate m_flow_eps=1e-3;
equation
  //_________________________Allocate mass flow rates to the two zones_____________
  m_flow_inliq = {(2 - zoneAlloc_in[1])*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_invap = {(zoneAlloc_in[1] - 1)*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_outliq = {(2 - zoneAlloc_out[i])*iCom.m_flow_out[i] for i in 1:geo.N_outlet};
  m_flow_outvap = {(zoneAlloc_out[i] - 1)*iCom.m_flow_out[i] for i in 1:geo.N_outlet};
  //_________________________Calculattion of additional media data_________________
  steamQuality_in ={TILMedia.VLEFluid.ObjectFunctions.steamMassFraction_phxi(
    iCom.p_in[i],
    iCom.h_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  steamQuality_out ={TILMedia.VLEFluid.ObjectFunctions.steamMassFraction_phxi(
    iCom.p_out[i],
    iCom.h_out[i],
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
