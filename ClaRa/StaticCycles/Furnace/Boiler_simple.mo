within ClaRa.StaticCycles.Furnace;
model Boiler_simple "Boiler || HP: blue |green || IP: blue |green"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
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
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component" annotation(Dialog(group="Fundamental Definitions"));

  outer parameter Real P_target_ "Target power in p.u.";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_LS_nom "Live steam flow at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_RS_nom "Reheated steam flow at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));

  parameter ClaRa.Basics.Units.Temperature T_LS_nom "Live steam temperature at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Temperature T_RS_nom "Reheated steam temperature at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_LS_nom "Live steam pressure loss at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_RS_nom "Reheat steam pressure loss at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure p_LS_out_nom "Live steam pressure at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure p_RS_out_nom "Reheated steam pressure at nominal load" annotation(Dialog(group="Definition of the Nominal Operation Point"));
  parameter Real CharLine_Delta_p_HP_mLS_[:,2]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "Characteristic line of LS pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_Delta_p_IP_mRS_[:,2]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "Characteristic line of RS pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow = m_flow_feed*(h_LS_out-h_LS_in) + m_flow_cRH*(h_RS_out-h_RS_in) "Rprt: Heating power";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cRH(fixed=false) "Mass flow rate of cold Re-Heat ";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_LS_in(fixed=false) "Inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_RS_in(fixed=false) "Inlet specific enthalpy";

protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table1(table=CharLine_Delta_p_HP_mLS_, u = {m_flow_feed/m_flow_LS_nom});
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table2(table=CharLine_Delta_p_IP_mRS_, u = {m_flow_cRH/m_flow_RS_nom});
public
  final parameter Real Delta_p_LS_(fixed = false) "Rprt: current LS pressure loss";
  final parameter Real Delta_p_RS_(fixed = false) "Rprt: current RS pressure loss";
initial equation
  Delta_p_LS_ = table1.y[1];
  Delta_p_RS_ = table2.y[1];
public
  final parameter Real Q_flow_LS_ = (h_LS_out - h_LS_in)*m_flow_feed/Q_flow "Rprt: Heat release in life steam at current load";

//_________________________________________________________________________________

   final parameter Real Q_flow_RS_ = 1 - Q_flow_LS_ "Rprt: Heat release in reheated steam at current load";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_LS_out=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_LS_out,
      T_LS_nom) "Outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_RS_out=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_RS_out,
      T_RS_nom) "Outlet specific enthalpy";

  final parameter ClaRa.Basics.Units.Pressure p_LS_in = p_LS_out + Delta_p_LS_*Delta_p_LS_nom "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_LS_out = P_target_*p_LS_out_nom "Life steam pressure at current load";
  final parameter ClaRa.Basics.Units.Pressure p_RS_in = p_RS_out + Delta_p_RS_*Delta_p_RS_nom "Inlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_feed( fixed=false) "HP inlet mass flow";
  final parameter ClaRa.Basics.Units.Pressure p_RS_out = P_target_*p_RS_out_nom "Reheated steam pressure at current load";

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b hotReheat(
    h = h_RS_out,
    p = p_RS_out,
    m_flow = m_flow_cRH, Medium=medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={50,100}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=270,
        origin={60,104})));

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a coldReheat(p=p_RS_in, Medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-100}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={40,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a feedWater(p=p_LS_in, Medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-100}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={1.77636e-015,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b liveSteam(
    h = h_LS_out,
    p = p_LS_out,
    m_flow = m_flow_LS_nom*P_target_, Medium=medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=270,
        origin={0,104})));
initial equation
  h_LS_in = feedWater.h;
  h_RS_in = coldReheat.h;
  feedWater.m_flow = m_flow_feed;
  coldReheat.m_flow = m_flow_cRH;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),                                                                               Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-100}},
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_feed - liveSteam.m_flow) > 0 then {234,171,0} else {0,131,169}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_feed - liveSteam.m_flow) > 0 then FillPattern.Backward else FillPattern.Solid)),
        Ellipse(extent={{-40,10},{40,-70}}, lineColor={0,131,169}),
        Line(
          points={{-28,-2},{28,-58}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{-28,-58},{28,-2}},
          color= {0,131,169},
          smooth=Smooth.None),
        Line(points={{0,40},{-20,70},{20,70},{0,100}}, color=DynamicSelect({0,131,169}, if abs(m_flow_feed - liveSteam.m_flow) > 0 then {234,171,0} else {0,131,169})),
        Line(points={{60,40},{40,70},{80,70},{60,100}}, color={0,131,169})}));
end Boiler_simple;
