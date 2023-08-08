within ClaRa.StaticCycles.ValvesConnects;
model Valve_dp_nom2 "Valve || par.: dp_nom || green | green"
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
   // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.

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
  outer parameter Real P_target_ "Target power in p.u.";

  parameter ClaRa.Basics.Units.Pressure Delta_p_nom "Nominal pressure drop" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_Delta_p_P_target_[:,2] = [0,0;1,1] "Pressure drop depending on rel. power in p.u."
                                                                                              annotation(Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out=p_in - Delta_p "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p(fixed=false) "Actual pressur drop";
protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table1(table=CharLine_Delta_p_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_green_a inlet annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  Fundamentals.SteamSignal_green_b outlet(
    p=p_out,
    h=h_out,
    m_flow=m_flow) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  inlet.p=p_in;
  inlet.h=h_in;
  inlet.m_flow=m_flow;
  Delta_p = table1.y[1]*Delta_p_nom;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{-50,-25},{50,25},{50,-25},{-50,25},{-50,-25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25)}), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end Valve_dp_nom2;
