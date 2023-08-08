within ClaRa_Obsolete.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_3_TwoZones "A volume element balancing liquid and vapour phase"
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
  extends ClaRa.Basics.Icons.Volume2Zones;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_1;
  //  extends BaseClasses.Interfaces.DataInterface(p_int=outlet.p/1e5,h_int=outlet.h_outflow/1e3, m_flow_int=-outlet.m_flow, T_int=fluidOut.T-273.15, s_int=fluidOut.s/1e3);
  outer ClaRa.SimCenter simCenter;

  import Modelica.Constants.eps;
  import ClaRa.Basics.Functions.Stepsmoother;
  import ClaRa;

  //_____________________________________________________
  //____________loal summary definition__________________
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    ClaRa.Basics.Units.Volume volume_tot "Total volume";
    ClaRa.Basics.Units.Area A_heat_tot "Heat transfer area";
    ClaRa.Basics.Units.Volume volume[2] if showExpertSummary "Volume of liquid and steam volume";
    ClaRa.Basics.Units.Area A_heat[2] if showExpertSummary "Heat transfer area";
    ClaRa.Basics.Units.Length level_abs "Absolue filling level";
    Real level_rel if showExpertSummary "relative filling level";
    ClaRa.Basics.Units.Mass fluidMass "Total fluid mass";
    ClaRa.Basics.Units.Enthalpy H_tot if showExpertSummary "Systems's enthalpy";
    ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
    ClaRa.Basics.Units.HeatFlowRate Q_flow[2] if showExpertSummary "Zonal heat flow rate";
    ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE inlet;
    ClaRa.Basics.Records.FlangeVLE outlet;
    ClaRa.Basics.Records.FluidVLE_L34 fluid;
  end Summary;
  //_____________________________________________________
  //_______________replaceable models____________________
  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L3 "1st: choose heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=
        true);

  replaceable model PhaseBorder =
      ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution.RealSeparated
    constrainedby ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution.RealPhases "1st: choose phase border model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=
        true);

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearSerialZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "1st: choose friction model | 2nd: edit corresponding record"
                                                                  annotation (
      Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

  //_____________________________________________________
  //______________________parameters_____________________
  parameter ClaRa.Basics.Units.Time Tau_cond=10 "|Phase Border|Time constant of condensation";
  parameter ClaRa.Basics.Units.Time Tau_evap=Tau_cond/1000 "|Phase Border|Time constant of evaporation";
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Phase Border|HTC of the phase border";
  parameter ClaRa.Basics.Units.Area A_heat_ph=geo.A_hor*100 "|Phase Border|Heat transfer area at phase border";
  //*min(volume_liq/volume_vap, V_vap/volume_liq)
  parameter Real expHT_phases = 0 "|Phase Border|Exponent for volume dependency on inter phase HT";

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(tab="Initialisation"));
  inner parameter Modelica.Units.SI.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));

  inner parameter Modelica.Units.SI.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));

  final parameter Modelica.Units.SI.Density rho_liq_nom=TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_nom) "Nominal density";
  final parameter Modelica.Units.SI.Density rho_vap_nom=TILMedia.VLEFluidFunctions.dewDensity_pxi(medium, p_nom) "Nominal density";

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p_start) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  parameter Real level_rel_start=0.5 "Start value for relative filling level"
    annotation (Dialog(tab="Initialisation"));

  inner parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Initialisation", choicesAllMatching));
  //  parameter Modelica.SIunits.Length radius_flange=0.05 "Flange radius" annotation(Dialog(group="Geometry"));

  parameter Boolean showExpertSummary=false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered" annotation(dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));

  //_____________________________________________________
  //_______Variables and model instances_________________
//   ClaRa.Basics.Units.EnthalpyMassSpecific h_out;
//   ClaRa.Basics.Units.EnthalpyMassSpecific h_in;
public
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_liq(start=h_liq_start) "Specific enthalpy of liquid phase";
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_vap(start=h_vap_start) "Specific enthalpy of vapour phase";
  Real drho_liqdt;
  Real drho_vapdt;
  //(unit="kg/(m3s)");
  ClaRa.Basics.Units.Volume volume_liq(start=phaseBorder.level_rel_start*geo.volume) "Liquid volume";
  ClaRa.Basics.Units.Volume volume_vap(start=(1 - phaseBorder.level_rel_start)*geo.volume) "Vapour volume";
  ClaRa.Basics.Units.MassFlowRate m_flow_cond "Condensing mass flow";
  ClaRa.Basics.Units.MassFlowRate m_flow_evap "Evaporating mass flow";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_phases "Heat flow between phases";

//   ClaRa.Basics.Units.MassFlowRate m_flow_in;
//   ClaRa.Basics.Units.MassFlowRate m_flow_out;

  ClaRa.Basics.Units.Mass mass_liq "Liquid mass";
  ClaRa.Basics.Units.Mass mass_vap "Vapour mass";
  inner ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";

  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_inliq "Enthalpy flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_invap "Enthalpy flow rate passing from inlet to vapour zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_outliq "Enthalpy flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_outvap "Enthalpy flow rate passing from outlet to vapour zone and vice versa";

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat annotation (
      Placement(transformation(extent={{84,86},{104,106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));

  TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    final p=inlet.p,
    final h=if useHomotopy then homotopy(actualStream(inlet.h_outflow),
        inStream(inlet.h_outflow)) else actualStream(inlet.h_outflow))
                  annotation (Placement(transformation(extent={{-90,-10},{-70,
            10}}, rotation=0)));
  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    final p=outlet.p,
    final h=if useHomotopy then homotopy(actualStream(outlet.h_outflow),
        inStream(outlet.h_outflow)) else actualStream(outlet.h_outflow))
                   annotation (Placement(transformation(extent={{70,-10},{90,10}},
          rotation=0)));

protected
  inner TILMedia.VLEFluid_ph liq(
    vleFluidType=medium,
    h=h_liq,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    p=p) annotation (Placement(transformation(extent={{-10,-20},{10,0}},
          rotation=0)));
public
  HeatTransfer heattransfer(
  final heatSurfaceAlloc=heatSurfaceAlloc)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));
  PhaseBorder phaseBorder(level_rel_start=level_rel_start)
    annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  PressureLoss pressureLoss
    annotation (Placement(transformation(extent={{12,60},{32,80}})));

protected
  inner TILMedia.VLEFluid_ph vap(
    vleFluidType=medium,
    p=p,
    h=h_vap,
    computeTransportProperties=true,
    computeVLETransportProperties=true) annotation (Placement(transformation(
          extent={{-10,8},{10,28}}, rotation=0)));
protected
  inner ClaRa.Basics.Records.IComVLE_L3_OnePort
                                        iCom(
    mediumModel=medium,
    h_in={fluidIn.h},
    h_out={fluidOut.h},
    p_in={inlet.p},
    p_out={outlet.p},
    m_flow_in={inlet.m_flow},
    m_flow_out={outlet.m_flow},
    p_nom=p_nom,
    m_flow_nom=m_flow_nom,
    volume={volume_liq,volume_vap},
    h={h_liq,h_vap},
    T={liq.T,vap.T},
    T_in={fluidIn.T},
    T_out={fluidOut.T},
    xi_in={fluidIn.xi},
    xi_out={fluidOut.xi},
    xi={liq.xi,vap.xi},
    h_nom=1e6,
    p={p,p},
    fluidPointer_in={fluidIn.vleFluidPointer},
    fluidPointer_out={fluidOut.vleFluidPointer},
    fluidPointer= {liq.vleFluidPointer, vap.vleFluidPointer},
    final N_cv=2) "Internal communication record"
    annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));
public
  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      volume_tot=geo.volume,
      volume=iCom.volume,
      A_heat=geo.A_heat[heatSurfaceAlloc]*{volume_liq,volume_vap}/geo.volume,
      A_heat_tot=geo.A_heat[heatSurfaceAlloc],
      level_abs=phaseBorder.level_abs,
      level_rel=phaseBorder.level_rel,
      Delta_p=inlet.p - outlet.p,
      fluidMass=mass_vap + mass_liq,
      H_tot=h_liq*mass_liq + h_vap*mass_vap,
      Q_flow_tot=heat.Q_flow,
      Q_flow=heattransfer.heat.Q_flow),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidIn.T,
      p=inlet.p,
      h=fluidIn.h,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=fluidIn.h*inlet.m_flow,
      rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h*outlet.m_flow,
      rho=fluidOut.d),
    fluid(
      showExpertSummary=showExpertSummary,
      mass={mass_liq,mass_vap},
      p={p,p},
      h=iCom.h,
      h_bub={liq.VLE.h_l,vap.VLE.h_l},
      h_dew={liq.VLE.h_v,vap.VLE.h_v},
      T=iCom.T,
      T_sat={liq.VLE.T_l,vap.VLE.T_l},
      s={liq.s,vap.s},
      steamQuality={liq.q,vap.q},
      H=iCom.h .* {mass_liq,mass_vap},
      rho={liq.d,vap.d},
      final N_cv=2)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
equation

  //_____________________________________________________
  //_______Asserts_______________________________________
  assert(geo.volume > 0, "The system volume must be greater than zero!");
  assert(geo.A_heat[1] >= 0, "The area of heat transfer must be greater than zero!");

  //_____________________________________________________
  //_______System definition_____________________________
  mass_liq = if useHomotopy then homotopy(volume_liq*liq.d, volume_liq*
    rho_liq_nom) else volume_liq*liq.d;
  mass_vap = if useHomotopy then homotopy(volume_vap*vap.d, volume_vap*
    rho_vap_nom) else volume_vap*vap.d;
  drho_liqdt = der(p)*liq.drhodp_hxi + der(h_liq)*liq.drhodh_pxi;
  //calculating drhodt from state variables
  drho_vapdt = der(p)*vap.drhodp_hxi + der(h_vap)*vap.drhodh_pxi;
  //calculating drhodt from state variables
  volume_liq = geo.volume - volume_vap;

  //_____________________________________________________
  //_______Mass Balances_________________________________
  drho_liqdt*volume_liq = +liq.d*der(volume_vap) + phaseBorder.m_flow_inliq[1]
     + phaseBorder.m_flow_outliq[1] + m_flow_cond - m_flow_evap "Liquid mass balance";
  drho_vapdt*volume_vap = -vap.d*der(volume_vap) + phaseBorder.m_flow_invap[1] +
    phaseBorder.m_flow_outvap[1] - m_flow_cond + m_flow_evap "Liquid mass balance";

  //_____________________________________________________
  //______Energy Balances________________________________
  der(h_liq) = if mass_liq > 1e-6 then (H_flow_inliq + H_flow_outliq + m_flow_cond*vap.VLE.h_l - m_flow_evap*vap.VLE.h_v
     + volume_liq*der(p) + p*der(volume_liq) - h_liq*volume_liq*drho_liqdt -
    liq.d*h_liq*der(volume_liq) + Q_flow_phases + heattransfer.heat[1].Q_flow)/
    mass_liq else der(h_vap);

  der(h_vap) = if mass_vap > 1e-6 then (H_flow_invap + H_flow_outvap - m_flow_cond*vap.VLE.h_l + m_flow_evap*vap.VLE.h_v +
    volume_vap*der(p) + p*der(volume_vap) - h_vap*volume_vap*drho_vapdt - vap.d
    *h_vap*der(volume_vap) - Q_flow_phases + heattransfer.heat[2].Q_flow)/
    mass_vap else der(h_liq);

//________________________________________________________________________________
//______Coupling of the Phases: Heat Transfer_____________________________________
//   Q_flow_phases = noEvent(alpha_ph*A_heat_ph*(iCom.T[2] - iCom.T[1]));
  Q_flow_phases = noEvent(alpha_ph*A_heat_ph*min((1e-6+iCom.volume[1])/(1e-6+iCom.volume[2]), (1e-6+iCom.volume[2])/(1e-6+iCom.volume[1]))^expHT_phases*(iCom.T[2] - iCom.T[1]));

//________________________________________________________________________________
//______Coupling of the Phases: Mass Transfer_____________________________________
 m_flow_cond = Stepsmoother(1e-1, 1e-3, mass_vap*(1 - vap.q))*Stepsmoother(-10, +10, h_vap - vap.VLE.h_v)*(1 - noEvent(max(0, min(1, vap.q))))*max(0, mass_vap)/Tau_cond;
 m_flow_evap = Stepsmoother(1e-1, 1e-3,mass_liq*liq.q)       *Stepsmoother(-10, +10, liq.VLE.h_l - h_liq)*     noEvent(max(0, min(1, liq.q)))        *mass_liq /Tau_evap;

//    m_flow_cond = Stepsmoother(1e-1,1e-3,mass_vap*(1 - vap.q))*Stepsmoother(vap.VLE.h_l, vap.VLE.h_v+100, h_vap)*mass_vap/Tau_cond;
//    m_flow_evap = Stepsmoother(1e-1,1e-3,mass_liq*liq.q)      *Stepsmoother(liq.VLE.h_v+100, liq.VLE.h_l, h_liq)*mass_liq/Tau_evap;

//____________________________________________________
//______Boundary Conditions___________________________
  inlet.h_outflow  =  (phaseBorder.zoneAlloc_in[1]-1)*iCom.h[2] + (2-phaseBorder.zoneAlloc_in[1]) *iCom.h[1];
  outlet.h_outflow =  (phaseBorder.zoneAlloc_out[1]-1)*iCom.h[2]+ (2-phaseBorder.zoneAlloc_out[1])*iCom.h[1];

   H_flow_inliq = semiLinear(phaseBorder.m_flow_inliq[1], inStream(inlet.h_outflow), h_liq);
   H_flow_invap = semiLinear(phaseBorder.m_flow_invap[1], inStream(inlet.h_outflow), h_vap);
   H_flow_outliq = semiLinear(phaseBorder.m_flow_outliq[1], inStream(outlet.h_outflow), h_liq);
   H_flow_outvap = semiLinear(phaseBorder.m_flow_outvap[1], inStream(outlet.h_outflow), h_vap);

    inlet.p =p + pressureLoss.Delta_p[1] + phaseBorder.Delta_p_geo_in[1];
    outlet.p =p + phaseBorder.Delta_p_geo_out[1] "The friction term is lumped at the inlet side to avoid direct coupling of two flow models, this avoids aniteration of mass flow rates in some application cases";

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  In the following equations dividing the friction pressure loss into two parts located at the inlet and outlet side respectively leads
  //  to a disadvatageous coupling of flow model cascades and iteration of mass flow rates in some applications.
  //    inlet.p  =  p + pressureLoss.Delta_p/2 + phaseBorder.dp_geo_in;
  //    outlet.p = p - pressureLoss.Delta_p/2 + phaseBorder.dp_geo_out;
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //____________________________________________________
  //______Chemistry_____________________________________
  // No chemical reaction taking place:
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  //___________________________________________________
  //______Initial Equations____________________________
initial equation
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h_liq) = 0;
    der(h_vap) = 0;
    der(p) = 0;
    der(volume_vap) = 0;

  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p) = 0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h_liq) = 0;
    der(h_vap) = 0;
    //der(volume_vap)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensity then
    //    der(y)=0;
    phaseBorder.level_rel = phaseBorder.level_rel_start;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensityPressure then
    //phaseBorder.relLevel=phaseBorder.level_rel_start;
    //der(volume_vap)=0;
  elseif initType == ClaRa.Basics.Choices.Init.noInit then
//     phaseBorder.relLevel = phaseBorder.level_rel_start;
//     h_liq = h_liq_start;
//     h_vap = h_vap_start;
//     p = p_start;
  end if;

equation
  connect(heattransfer.heat[1], heat) annotation (Line(
      points={{-60,70},{-60,90},{94,90},{94,96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heattransfer.heat[2], heat) annotation (Line(
      points={{-60,70},{-60,96},{94,96}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics),
    Diagram(graphics),
    Documentation(info="<html>
<p><b>Model description: </b>A non-adiabatic control volume without friction losses taking the geostatic pressure difference into account</p>
<p><b>Contact:</b> Friedrich Gottelt, Johannes Brunnemann, XRG Simulation GmbH</p>
<p><ul>
<li>This model uses TILMedia</li>
<li>This model is derived from ThermoPower.Water.Header</li>
<li>Flow reversal is supported</li>
<li>Homotopy initialisation is supported</li>
</ul></p>
</html>"));
end VolumeVLE_3_TwoZones;
