within ClaRa.Components.VolumesValvesFittings.Fittings;
model JoinVLE_L3_Y "A Y-join with non-ideal mixing"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

  extends ClaRa.Basics.Icons.Tpipe;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                               annotation(Dialog(group="Fundamental Definitions"));

  parameter Basics.Units.Volume volume(min=1e-6) = 0.1 "System Volume" annotation (Dialog(tab="General", group="Geometry"));
  parameter Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
//   parameter SI.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"  annotation(Dialog(group="Nominal Values"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  parameter Basics.Units.EnthalpyMassSpecific h_start=1e5 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  inner parameter Integer initOption = 211 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));

    parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  parameter Real y_start=0.5 "|Initialisation|Start value for relative filling Level";
  parameter Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start) "|Initialisation|Start value of sytsem specific enthalpy";
  parameter Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p_start) "|Initialisation|Start value of sytsem specific enthalpy";

  parameter Basics.Units.VolumeFraction eps_mix[2]={0.2,0.8} "|Mixing Process||Volume fraction V_1/V_tot of min/max mixed outlet";
  replaceable model PressureLoss =
      Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure losses at inlet ports"
    annotation (dialog(group="Fundamental Definitions"),choicesAllMatching=true);
  parameter Basics.Units.Time tau_cond=0.03 "|Mixing Process||Time constant of condensation";
  parameter Basics.Units.Time tau_evap=tau_cond "|Mixing Process||Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=5000 "|Mixing Process||HTC of the phase border";
  parameter Basics.Units.Area A_phaseBorder=10 "|Mixing Process||Heat transfer area at phase border";
  parameter Real expHT_phases=0 "|Mixing Process||Exponent for volume dependency on inter phase HT";

public
  Basics.Interfaces.FluidPortIn       inlet2(each Medium=medium) "First inlet port"
    annotation (Placement(transformation(extent={{-10,70},{10,90}}),
        iconTransformation(extent={{-10,90},{10,110}})));
public
  Basics.Interfaces.FluidPortIn       inlet1(each Medium=medium) "First inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.FluidPortOut       outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
public
  Basics.Interfaces.EyeOut       eye if showData      annotation(Placement(transformation(extent={{100,-50},
            {120,-30}}), iconTransformation(extent={{100,-50},{120,-30}})));
protected
  Basics.Interfaces.EyeIn       eye_int
    annotation (Placement(transformation(extent={{49,-41},{51,-39}})));
public
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort mixingZone(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (volume=volume, N_inlet=2),
    medium=medium,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealMixed (level_rel_start=y_start, eps_mix=eps_mix),
    redeclare model PressureLoss = PressureLoss,
    Tau_cond=tau_cond,
    Tau_evap=tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases,
    useHomotopy=useHomotopy,
    p_nom=p_nom,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    p_start=p_start,
    level_rel_start=y_start,
    showExpertSummary=showExpertSummary,
    m_flow_nom=m_flow_nom,
    initOption=initOption)  annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(mixingZone.inlet[1], inlet1)                 annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.inlet[2], inlet2)                 annotation (Line(
      points={{-10,0},{-20,0},{-20,58},{0,58},{0,80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.outlet[1], outlet)                 annotation (Line(
      points={{10,0},{100,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));

    eye_int.m_flow=-outlet.m_flow;
    eye_int.T= mixingZone.summary.outlet[1].T-273.15;
    eye_int.s=mixingZone.fluidOut[1].s/1e3;
    eye_int.p=mixingZone.summary.fluid.p[1]/1e5;
    eye_int.h=mixingZone.summary.outlet[1].h/1e3;
  connect(eye_int, eye) annotation (Line(points={{50,-40},{78,-40},{110,-40}}, color={190,190,190}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-92,32},{-74,-32}},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=mixingZone.pressureLoss.hasPressureLoss), Rectangle(
          extent={{-32,92},{32,74}},
          pattern=LinePattern.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=mixingZone.pressureLoss.hasPressureLoss)}));
end JoinVLE_L3_Y;
