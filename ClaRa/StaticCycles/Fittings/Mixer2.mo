within ClaRa.StaticCycles.Fittings;
model Mixer2 "Mixer || green | blue | green"
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
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet1;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet2;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet1(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  inlet2(
     m_flow=m_flow_2,
     h=h2,
     p=p),
  outlet(
     m_flow=m_flow_3,
     h=h3,
     p=p));
  //---------Summary Definition---------
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h2(fixed=false) "Specific enthalpy of flow 2";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2(fixed=false) "Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h3=(h1*m_flow_1 + h2* m_flow_2)/m_flow_3 "Mixer outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3=m_flow_1 + m_flow_2 "Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Mixer pressure";

  Fundamentals.SteamSignal_green_a inlet_1 annotation (Placement(transformation(extent={{-60,10},{-50,30}}), iconTransformation(extent={{-60,10},{-50,30}})));
  Fundamentals.SteamSignal_blue_a inlet_2(p=p) annotation (Placement(transformation(
        extent={{-10,-30},{10,-20}},
        rotation=0,
        origin={0,-10}), iconTransformation(
        extent={{-10,-30},{10,-20}},
        rotation=0,
        origin={0,-10})));
  Fundamentals.SteamSignal_green_b outlet(
    p=p,
    h=h3,
    m_flow=m_flow_3) annotation (Placement(transformation(extent={{50,10},{60,30}}), iconTransformation(extent={{50,10},{60,30}})));
initial equation
  inlet_1.p=p;
  inlet_1.h=h1;
  inlet_1.m_flow=m_flow_1;
  inlet_2.h=h2;
  inlet_2.m_flow=m_flow_2;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true,  extent={{-60,-20},{60,30}}),     graphics));
end Mixer2;
