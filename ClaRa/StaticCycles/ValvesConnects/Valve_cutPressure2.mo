within ClaRa.StaticCycles.ValvesConnects;
model Valve_cutPressure2 "Valve || yellow | red"
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
   // Yellow input: Values of p and h are unknown and provided BY neighbor component, value of m_flow is known and provided FOR neighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out));
  //---------Summary Definition---------

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in-p_out "Pressure difference";

  Fundamentals.SteamSignal_yellow_a inlet(m_flow=m_flow) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  Fundamentals.SteamSignal_red_b outlet(h=h_out) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.h=h_in;
  outlet.m_flow=m_flow;
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}), graphics={
        Polygon(
          points={{-50,25},{-20,25},{-20,25},{-20,15},{0,5},{20,15},{20,25},{20,25},{50,25},{50,25},{50,-25},{50,-25},{20,-25},{20,-25},{20,-15},{0,-5},{-20,-15},{-20,-25},{-20,-25},{-50,-25},{-50,-25},{-50,25},{-50,25}},
          smooth=Smooth.Bezier,
          lineColor=DynamicSelect({0,131,169}, if Delta_p > 0 then {0,131,169} else {235,183,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p > 0 then FillPattern.Solid else FillPattern.Backward))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end Valve_cutPressure2;
