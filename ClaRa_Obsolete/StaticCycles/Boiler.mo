within ClaRa_Obsolete.StaticCycles;
model Boiler "Boiler || liveSteam: blue |green || RH: blue |green"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "|Fundamental Definitions|Medium in the component";

  outer parameter Real P_target_ "Target power in p.u.";
  outer parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom;

  parameter ClaRa.Basics.Units.Temperature T_LS_nom "|Fundamental Definitions|Life steam temperature at nominal load";
  parameter ClaRa.Basics.Units.Temperature T_RS_nom "|Fundamental Definitions|Reheated steam temperature at nominal load";
  parameter ClaRa.Basics.Units.Pressure Delta_p_LS_nom "|Fundamental Definitions|Life steam pressure loss at nominal load";
  parameter ClaRa.Basics.Units.Pressure Delta_p_RS_nom "|Fundamental Definitions|Reheated steam pressure loss at nominal load";
  parameter ClaRa.Basics.Units.Pressure p_LS_out_nom "|Fundamental Definitions|Life steam pressure at nominal load";
  parameter ClaRa.Basics.Units.Pressure p_RS_out_nom "|Fundamental Definitions|Reheated steam pressure at nominal load";
  parameter Real CharLine_Delta_p_HP_mLS_[:,:]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_Delta_p_IP_mRS_[:,:]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.HeatFlowRate Q_nom=m_flow_feed*(h_LS_out-h_LS_in) + m_flow_cRH*(h_RS_out-h_RS_in);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_feed=m_flow_nom*P_target_ "Mass flow rate feedwater";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cRH(fixed=false) "Mass flow rate of cold Re-Heat ";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_LS_in(fixed=false) "Inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_RS_in(fixed=false) "Inlet specific enthalpy";

protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table1(table=CharLine_Delta_p_HP_mLS_, u = {m_flow_feed/m_flow_nom});
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table2(table=CharLine_Delta_p_IP_mRS_, u = {m_flow_cRH/m_flow_nom});
public
  final parameter Real Delta_p_LS_(fixed = false);
  final parameter Real Delta_p_RS_(fixed = false);
initial equation
  Delta_p_LS_ = table1.y[1];
  Delta_p_RS_ = table2.y[1];
public
  final parameter Real Q_LS_ = (h_LS_out - h_LS_in)*m_flow_feed/Q_nom "Heat release in life steam at current load";

//_________________________________________________________________________________

   final parameter Real Q_RS_ = 1 - Q_LS_ "Heat release in reheated steam at current load";

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

  final parameter ClaRa.Basics.Units.Pressure p_LS_in=p_LS_out + Delta_p_LS_*
      Delta_p_LS_nom "Inlet pressure";

  final parameter ClaRa.Basics.Units.Pressure p_LS_out=P_target_*p_LS_out_nom "Life steam pressure at current load";

  final parameter ClaRa.Basics.Units.Pressure p_RS_in=p_RS_out + Delta_p_RS_*
      Delta_p_RS_nom "Inlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_HP_in( fixed=false) "HP inlet mass flow";

  final parameter ClaRa.Basics.Units.Pressure p_RS_out=P_target_*p_RS_out_nom "Reheated steam pressure at current load";

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b reheat_out(
    h=h_RS_out,
    p=p_RS_out,
    m_flow=m_flow_cRH) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={50,104}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=270,
        origin={40,104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a reheat_in(p=p_RS_in) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={40,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a feedwater(p=p_LS_in) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={1.77636e-015,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b liveSteam(
    h=h_LS_out,
    p=p_LS_out,
    m_flow=m_flow_nom*P_target_) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,104}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=270,
        origin={0,104})));
initial equation
  h_LS_in=feedwater.h;
  h_RS_in=reheat_in.h;
  feedwater.m_flow=m_flow_HP_in;
  reheat_in.m_flow=m_flow_cRH;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),                                                                     graphics), Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-38,40},{38,-34}}, lineColor={0,131,169}),
        Line(
          points={{-26,28},{24,-22}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{-26,-22},{26,30}},
          color={0,131,169},
          smooth=Smooth.None),            Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.3.0")}));
end Boiler;
