within ClaRa.StaticCycles.Fittings;
model Split4 "Split || blue | yellow | blue"
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
   // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
   // Yellow output: Values of p, and h are known in component and provided FOR neighbor component, value of m_flow is unknown and provided BY beighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet1;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet2;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  outlet1(
     m_flow=m_flow_2,
     h=h1,
     p=p),
  outlet2(
     m_flow=m_flow_3,
     h=h1,
     p=p));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2(fixed=false) "Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3=m_flow_1 - m_flow_2 "Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Spec. enthalpy at inlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of inlet";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Split pressure";
  //final parameter Real splitRatio=outlet_1.m_flow/inlet.m_flow "ratio of outlet_1.m_flow/inlet.m_flow";

  Fundamentals.SteamSignal_blue_a inlet(p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{-50,10},{-60,30}}), iconTransformation(extent={{-50,10},{-60,30}})));
  Fundamentals.SteamSignal_yellow_b outlet_1(h=h1, p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{60,10},{50,30}}), iconTransformation(extent={{60,10},{50,30}})));
  Fundamentals.SteamSignal_blue_b outlet_2(h=h1, m_flow=m_flow_3, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0})));
initial equation
  inlet.m_flow=m_flow_1;
  inlet.h=h1;
  outlet_2.p=p;
  outlet_1.m_flow=m_flow_2;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-30},{50,30}}),     graphics));
end Split4;
