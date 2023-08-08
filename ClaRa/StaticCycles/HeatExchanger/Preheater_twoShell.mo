within ClaRa.StaticCycles.HeatExchanger;
model Preheater_twoShell "Two cascade preheater || bubble state at shell outlets || par.: shell pressures, shell m_flows"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
    model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_1_tap;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_1_tap;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_2_tap;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_2_tap;
    end Summary;

  Summary summary(
  inlet_cond(
     m_flow=m_flow_cond,
     h=h_cond_in,
     p=p_cond),
  outlet_cond(
     m_flow=m_flow_cond,
     h=h_cond_out,
     p=p_cond),
  inlet_1_tap(
     m_flow=m_flow_tap1,
     h=h_tap1_in,
     p=p_tap1),
  outlet_1_tap(
     m_flow=m_flow_tap1,
     h=h_tap1_out,
     p=p_tap1),
  inlet_2_tap(
     m_flow=m_flow_tap2,
     h=h_tap2_in,
     p=p_tap2),
  outlet_2_tap(
     m_flow=m_flow_tap2,
     h=h_tap2_out,
     p=p_tap2));
  //---------Summary Definition---------
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid vleMedium = simCenter.fluid1 "Medium in the component" annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_tap1=1e5 "|Fundamental Definitions|Pressure of heating steam 1";
  parameter ClaRa.Basics.Units.Pressure p_tap2=1e5 "|Fundamental Definitions|Pressure of heating steam 2";

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap1=1 "|Fundamental Definitions|Mass flow rate of the heating steam 1";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap2=1 "|Fundamental Definitions|Mass flow rate of the heating steam 2";
  final parameter ClaRa.Basics.Units.Pressure p_cond(fixed=false) "Pressure at condensate side";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false) "Mass flow of the condensate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap1_in(fixed=false) "Spec. enthalpy at tapping 1 inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap2_in(fixed=false) "Spec. enthalpy at tapping 2 inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false) "Spec. enthalpy at condensate inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap1_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_tap1) "Spec. enthalpy of condensed tapping 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap2_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_tap2) "Spec. enthalpy of condensed tapping 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out=(m_flow_tap2*h_tap2_in + m_flow_tap1*h_tap1_in + h_cond_in*m_flow_cond)/(m_flow_tap1 + m_flow_tap2 + m_flow_cond) "Spec. enthalpy ar condensate outlet";
  Fundamentals.SteamSignal_blue_a cond_in(p=p_cond, Medium=vleMedium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue_b cond_out(m_flow=m_flow_cond, h=h_cond_out, Medium=vleMedium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
  Fundamentals.SteamSignal_red_a tap_1_in(p=p_tap1, m_flow=m_flow_tap1, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-30,100},{-50,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-30,100},{-50,110}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_blue_b tap_1_out(
    m_flow=m_flow_tap1,
    h=h_tap1_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-50,-110},{-30,-100}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-50,-110},{-30,-100}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_red_a tap_2_in(p=p_tap2, m_flow=m_flow_tap2, Medium=vleMedium) annotation (Placement(transformation(
        extent={{30,100},{50,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{30,100},{50,110}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_green_b tap_2_out(
    p=p_tap2,
    m_flow=m_flow_tap2,
    h=h_tap2_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{30,-100},{50,-110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{30,-100},{50,-110}},
        rotation=0,
        origin={0,0})));

initial equation
  tap_1_in.h=h_tap1_in;
  tap_2_in.h=h_tap2_in;
  cond_in.h=h_cond_in;
  cond_in.m_flow=m_flow_cond;
  cond_out.p=p_cond;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-2,-44},{-2,38},{100,0}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Preheater_twoShell;
