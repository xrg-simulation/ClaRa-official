within ClaRa.StaticCycles.HeatExchanger;
model Preheater2 "Preheater || bubble state at shell outlet || par.: shell pressure || cond: blue | blue || tap: blue | green"
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
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
      //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_tap;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_tap;
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
  inlet_tap(
     m_flow=m_flow_tap,
     h=h_tap_in,
     p=p_tap),
  outlet_tap(
     m_flow=m_flow_tap,
     h=h_tap_out,
     p=p_tap_out));
  //---------Summary Definition---------

  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
                              annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_tap_nom "|Fundamental Definitions|Nominal pressure of heating steam";

  parameter ClaRa.Basics.Units.Length level_abs = 0 "|Fundamental Definitions|Filling level in hotwell";
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_tap_out_sc=0 "Enthalpy difference to bubble enthalpy of tapping outlet enthalpy"
                                                                                                                                            annotation(Dialog(group= "Nominal Operation Point"));

  final parameter ClaRa.Basics.Units.Pressure p_tap(fixed=false) "Pressure of the heating steam";
  final parameter ClaRa.Basics.Units.Pressure p_tap_out=p_tap+ Modelica.Constants.g_n*TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_tap)*level_abs;
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap(fixed=false);
  final parameter ClaRa.Basics.Units.Pressure p_cond(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false) "Mass flow of the condensate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_out = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_tap)-Delta_h_tap_out_sc;
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out = m_flow_tap*( h_tap_in - h_tap_out)/m_flow_cond + h_cond_in;

  parameter Real CharLine_p_tap_P_target_[:,2]=[0,1;1,1] "Characteristic line of p_tap as function of P_target_" annotation(Dialog(group="Part Load Definition"));

protected
  Modelica.Blocks.Tables.CombiTable1D table1(table=CharLine_p_tap_P_target_, u = {P_target_});
  final parameter Boolean isFilled = level_abs > 0 "Reprt: True if vessel is filled";
public
  Fundamentals.SteamSignal_blue_a cond_in(p=p_cond, Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue_b cond_out(h=h_cond_out, m_flow=m_flow_cond, Medium=medium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
  Fundamentals.SteamSignal_blue_a tap_in(p=p_tap, Medium=medium) annotation (Placement(transformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_green_b tap_out(
    h=h_tap_out,
    p=p_tap_out,
    m_flow=m_flow_tap, Medium=medium) annotation (Placement(transformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,-0}), iconTransformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,-0})));
initial equation
    p_tap=p_tap_nom*table1.y[1];
    h_tap_in=tap_in.h;
    h_cond_in=cond_in.h;
    m_flow_cond=cond_in.m_flow;
    cond_out.p=p_cond;
    tap_in.m_flow=m_flow_tap;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{0,-40},{0,40},{100,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,-80},{100,-100}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible = DynamicSelect(false, isFilled))}));
end Preheater2;
