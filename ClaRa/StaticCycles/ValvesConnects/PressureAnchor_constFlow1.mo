within ClaRa.StaticCycles.ValvesConnects;
model PressureAnchor_constFlow1 "Pressure fix point || blue | green"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
 parameter ClaRa.Basics.Units.Pressure p_nom "Pressure" annotation(Dialog(group= "Fundamental Definitions"));
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
     p=p),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p));
  //---------Summary Definition---------
  parameter Real CharLine_p_P_target_[:,:]=[0,1;1,1] "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  outer parameter Real P_target_ "Target power in p.u.";
protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table(table=CharLine_p_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_green_b outlet(
    m_flow=m_flow,
    h=h_out,
    p=p) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
  Fundamentals.SteamSignal_blue_a inlet(p=p) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
initial equation
  p = table.y[1] * p_nom;
  inlet.h=h_in;
  inlet.m_flow=m_flow;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{0,-20},{20,0},{0,20},{-20,0},{0,-20}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25),
        Line(
          points={{-50,0},{-50,0},{-20,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{20,0},{50,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Text(
          extent={{-20,10},{20,-10}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSeclect("p",String(p)))}),     Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end PressureAnchor_constFlow1;
