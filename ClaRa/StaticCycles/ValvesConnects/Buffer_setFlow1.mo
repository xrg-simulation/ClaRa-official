within ClaRa.StaticCycles.ValvesConnects;
model Buffer_setFlow1 "Flow Anchour || par.: m_flow_nom || green | green"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
// Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
// Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
//outer parameter Real P_target_ "Target power in p.u.";
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow_out,
     h=h_out,
     p=p_out));
  //---------Summary Definition---------
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_out "Nominal mass flow" annotation(Dialog(group= "Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out = p_in "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_diff = m_flow_in - m_flow_out "Rprt: Mass flow difference";
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_a inlet annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outlet(
    h=h_out,
    m_flow=m_flow_out,
    p=p_out) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  inlet.p=p_in;
  inlet.h=h_in;
  m_flow_in = inlet.m_flow;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={
        Text(
          extent={{-20,6},{20,-4}},
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}),
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Line(points={{-50,0},{-25,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Line(points={{25,0},{50,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Ellipse(
          extent={{-25,25},{25,-25}},
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_diff) > 1e-3 then FillPattern.Backward else FillPattern.Solid),
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end Buffer_setFlow1;
