within ClaRa.StaticCycles.Storage;
model Feedwatertank3 "Feedwatertank || par.: m_flow_FW, p_FW_nom || blue | red | green"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
   outer parameter Real P_target_ "Target power in p.u.";
      //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_tap;
  end Summary;

  Summary summary(
  inlet_cond(
     m_flow=m_flow_cond,
     h=h_cond_in,
     p=p_FWT),
  outlet_cond(
     m_flow=m_flow_FW,
     h=h_cond_out,
     p=p_FWT_out),
  inlet_tap(
     m_flow=m_flow_tap,
     h=h_tap_in,
     p=p_FWT));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
                                                       annotation(Dialog(group="Fundamental Definitions"), choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                        choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                        choice=simCenter.fluid3 "Third fluid defined in global simCenter"));
  parameter ClaRa.Basics.Units.Pressure p_FWT_nom "Feed water tank pressure at nominal load" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom "Mass flow rate at nomoinal load" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length level_abs=0 "Filling level" annotation (Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in(fixed=false, start=1) "Spec. enthalpy at tapping";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false) "Spec. enthalpy at condensate inlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false) "Condensate inlet flow";

//__________________________________________________

  final parameter ClaRa.Basics.Units.Pressure p_FWT=P_target_*p_FWT_nom "Feedwater tank pressure at current load";
  final parameter ClaRa.Basics.Units.Pressure p_FWT_out=p_FWT + Modelica.Constants.g_n*level_abs*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleDensity_pxi(medium, p_FWT) "Feedwater tank condensate outlet pressure";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap=(h_cond_out*m_flow_FW - h_cond_in*m_flow_cond)/h_tap_in "Mass flow of the heating steam";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_FW=P_target_*m_flow_nom "Feedwater mass flow";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_FWT) "Spec. enthalpy at feedwater outlet";
protected
  final parameter Boolean isFilled = level_abs > 0 "Reprt: True if vessel is filled";

public
  Fundamentals.SteamSignal_blue_a cond_in(p=p_FWT, Medium=medium) annotation (Placement(transformation(extent={{-110,-70},{-100,-50}}), iconTransformation(extent={{-110,-70},{-100,-50}})));
  Fundamentals.SteamSignal_red_a tap_in(m_flow=m_flow_tap, p=p_FWT, Medium=medium) annotation (Placement(transformation(
        extent={{-10,20},{10,30}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,20},{10,30}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_green_b cond_out(
    h=h_cond_out,
    p=p_FWT_out,
    m_flow=m_flow_FW, Medium=medium) annotation (Placement(transformation(extent={{100,-70},{110,-50}}), iconTransformation(extent={{100,-70},{110,-50}})));
initial equation
  m_flow_cond = cond_in.m_flow;
  h_tap_in = tap_in.h;
  h_cond_in = cond_in.h;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-100,-100},{100,20}}), graphics={
        Polygon(
          points={{-60,-100},{-100,-100},{-100,-60},{-100,-20},{-60,-20},{-20,-20},{-20,-20},{-20,0},{-20,20},{0,20},{20,20},{20,0},{20,-20},{20,-20},{60,-20},{100,-20},{100,-60},{100,-100},{60,-100},{-60,-100}},
          fillColor={255,255,255},
          lineColor=DynamicSelect({0,131,169}, if m_flow_FW - m_flow_cond - m_flow_tap  < 1e-3 then if m_flow_tap <0 then {167,25,48} else {0,131,169} else {235,183,0}),
          fillPattern=DynamicSelect(FillPattern.Solid, if m_flow_FW - m_flow_cond - m_flow_tap < 1e-3 and m_flow_tap > 0 then FillPattern.Solid else FillPattern.Backward),
          smooth=Smooth.Bezier),
        Line(
          points={{0,12},{0,-58},{-8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{0,-58},{8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{-92,-60},{92,-60},{78,-72}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{92,-60},{78,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Polygon(
          points={{-98,-100},{-100,-80},{-100,-80},{100,-80},{100,-80},{98,-100},{60,-100},{-60,-100},{-98,-100}},
          fillColor={0,131,169},
          lineColor={0,131,169},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          visible = DynamicSelect(false, isFilled))}),
                         Diagram(graphics,
                                 coordinateSystem(preserveAspectRatio=false,
                                                                           extent={{-100,-100},{100,20}})));
end Feedwatertank3;
