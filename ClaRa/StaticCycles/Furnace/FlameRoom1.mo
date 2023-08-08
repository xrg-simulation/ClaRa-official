within ClaRa.StaticCycles.Furnace;
model FlameRoom1 "Fixed fluid outlet temperature | red | green || brown | brown"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                            //
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
  // Red input:   Value of p and m_flow are known in component and provided FOR neighbor component, valueof h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  import Modelica.Constants.eps;

  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));

  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_wall;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_wall;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_bundle;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_bundle;
    ClaRa.Basics.Records.StaCyFlangeGas inlet_fg;
    ClaRa.Basics.Records.StaCyFlangeGas outlet_fg;
  end Summary;

  Summary summary(
  inlet_wall(
     m_flow=m_flow_vle_wall_in,
     h=h_vle_wall_in,
     p=p_vle_wall_in),
  outlet_wall(
     m_flow=m_flow_vle_wall_out,
     h=h_vle_wall_out,
     p=p_vle_wall_out),
  inlet_bundle(
     m_flow=m_flow_vle_bundle_in,
     h=h_vle_bundle_in,
     p=p_vle_bundle_in),
  outlet_bundle(
     m_flow=m_flow_vle_bundle,
     h=h_vle_bundle_out,
     p=p_vle_bundle_out),
  inlet_fg(
     mediumModel=flueGas,
     m_flow=m_flow_fg,
     T=T_fg_in,
     p=p_fg_in,
     xi=xi_fg_in),
  outlet_fg(
     mediumModel=flueGas,
     m_flow=m_flow_fg,
     T=T_fg_out,
     p=p_fg_out,
     xi=xi_fg_out));

  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid vleMedium = simCenter.fluid1 "vleMedium in the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Temperature T_vle_bundle_out_nom "Heated fluid temperature at nominal load" annotation(Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out_nom "Nominal vle wall outlet spec. enthalpy" annotation(Dialog(group="Nominal Operation Point"));

  parameter ClaRa.Basics.Units.Pressure Delta_p_vle_bundle_nom "Heated fluid pressure loss at nominal load"
                                                                                              annotation(Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall_nom "Heated fluid pressure loss at nominal load inside casing walls" annotation(Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure p_vle_bundle_out_nom "Heated fluid pressure at nominal load"
                                                                                                    annotation(Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_bundle_nom "Nominal mass flow" annotation(Dialog(group="Nominal Operation Point"));

  parameter ClaRa.Basics.Units.Length z_wall_in = 0.0 "Geodetic height at inlet" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_wall_out = 0.0 "Geodetic height at outlet" annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length z_bundle_in = 0.0 "Geodetic height at inlet of tube bundle" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_bundle_out = 0.0 "Geodetic height at outlet of tube bundle" annotation(Dialog(group="Fundamental Definitions"));

  parameter Real CharLine_Delta_p_P_target_[:,:]=[0, 0; 0.1, 0.01; 0.3, 0.09; 0.5, 0.25; 0.7, 0.49; 1, 1] "Characteristic line of pressure drop as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_T_bundle_P_target_[:,2]=[0,1;1,1] "Characteristic line of T_vle_out as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_h_wall_P_target_[:,2]=[0,1;1,1] "Characteristic line of h_vle_wall_out as function of P_target_" annotation(Dialog(group="Part Load Definition"));

  parameter ClaRa.Basics.Units.Length Delta_x_bundle[:] = ClaRa.Basics.Functions.GenerateGrid({0}, 10, 3) "Discretisation scheme - tube bundle side" annotation(Dialog(group="Discretisation (for reporting only)"));
  parameter Boolean frictionAtInlet_bundle = false "True if pressure loss between first cell and inlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));
  parameter Boolean frictionAtOutlet_bundle = false "True if pressure loss between last cell and outlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));

  parameter ClaRa.Basics.Units.Length Delta_x_wall[:] = ClaRa.Basics.Functions.GenerateGrid({0}, 10, 3) "Discretisation scheme - tube bundle side" annotation(Dialog(group="Discretisation (for reporting only)"));
  parameter Boolean frictionAtInlet_wall = false "True if pressure loss between first cell and inlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));
  parameter Boolean frictionAtOutlet_wall = false "True if pressure loss between last cell and outlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));

// _________GENERAL VALUES ___________
  final parameter Integer N_cv_bundle = size(Delta_x_bundle,1) "Number of finite volumes in tube bundle";
  final parameter Integer N_cv_wall = size(Delta_x_wall,1) "Number of finite volumes in wall";
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_bundle = m_flow_vle_bundle*(h_vle_bundle_out-h_vle_bundle_in) "Actual heat flow rate";
  //final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_wall = Q_flow_bundle/Pi_Q_flow "Actual heat flow rate to evaporator";
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_wall = m_flow_vle_wall_in*(h_vle_wall_out-h_vle_wall_in) "Actual heat flow rate to evaporator";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub_bundle = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(
      vleMedium,
      p_vle_bundle_out);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew_bundle = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(
      vleMedium,
      p_vle_bundle_out);

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub_wall = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(
      vleMedium,
      p_vle_wall_out);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew_wall = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(
      vleMedium,
      p_vle_wall_out);

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_bundle = m_flow_vle_bundle_nom*P_target_ "Mass flow rate of VLE medium";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_vle_bundle(fixed=false);
  final parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall(fixed=false) "Pressure losses vle medium";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg(fixed=false) "Mass flow rate flue gas";

  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_U_bundle = ClaRa.Basics.Functions.maxAbs(T_fg_in - T_vle_bundle_out, T_fg_out - T_vle_bundle_in, 0.1) "Rprt: Upper temperatre difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_L_bundle = ClaRa.Basics.Functions.minAbs(T_fg_in - T_vle_bundle_out, T_fg_out - T_vle_bundle_in, 0.1) "Rprt: Lowert temperature difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_mean_bundle = SM(0.1,eps, abs(Delta_T_L_bundle))*SM(0.01,eps, Delta_T_U_bundle*Delta_T_L_bundle) * SZT((Delta_T_U_bundle - Delta_T_L_bundle)/log(abs(Delta_T_U_bundle)/(abs(Delta_T_L_bundle)+1e-9)),
                                                                                              Delta_T_L_bundle,
                                                                                              (abs(Delta_T_U_bundle)-abs(Delta_T_L_bundle))-0.01,
                                                                                              0.001) "Rprt: Logarithmic temperature difference";
  final parameter Real kA_bundle = Q_flow_bundle /Delta_T_mean_bundle "Rprt: Heat Flow Resistance";

  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_U_wall = ClaRa.Basics.Functions.maxAbs(T_fg_in - T_vle_wall_out, T_fg_out - T_vle_wall_in, 0.1) "Rprt: Upper temperatre difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_L_wall = ClaRa.Basics.Functions.minAbs(T_fg_in - T_vle_wall_out, T_fg_out - T_vle_wall_in, 0.1) "Rprt: Lowert temperature difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_mean_wall = SM(0.1,eps, abs(Delta_T_L_wall))*SM(0.01,eps, Delta_T_U_wall*Delta_T_L_wall) * SZT((Delta_T_U_wall - Delta_T_L_wall)/log(abs(Delta_T_U_wall)/(abs(Delta_T_L_wall)+1e-9)),
                                                                                              Delta_T_L_wall,
                                                                                              (abs(Delta_T_U_wall)-abs(Delta_T_L_wall))-0.01,
                                                                                              0.001) "Rprt: Logarithmic temperature difference";
  final parameter Real kA_wall = Q_flow_wall /(1e-5 + Delta_T_mean_wall) "Rprt: Heat Flow Resistance";

  final parameter ClaRa.Basics.Units.Pressure p_bundle[N_cv_bundle] = ClaRa.Basics.Functions.pressureInterpolation(p_vle_bundle_in, p_vle_bundle_out, Delta_x_bundle, frictionAtInlet_bundle, frictionAtOutlet_bundle) "Rprt: Discretisised pressure at tube bundle";
  final parameter ClaRa.Basics.Units.Pressure p_wall[N_cv_wall] = ClaRa.Basics.Functions.pressureInterpolation(p_vle_wall_in, p_vle_wall_out, Delta_x_wall, frictionAtInlet_wall, frictionAtOutlet_wall) "Rprt: Discretisised pressure at tube bundle";

  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(vleMedium.nc - 1) "VLE composition in component, pure fluids supported only!";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo_wall=
    TILMedia.VLEFluidFunctions.density_phxi(vleMedium, p_vle_wall_out, h_vle_wall_out, xi) * Modelica.Constants.g_n * ( z_wall_out - z_wall_in) "Geostatic pressure difference";

  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo_bundle=
    TILMedia.VLEFluidFunctions.density_phxi(vleMedium, p_vle_bundle_out, h_vle_bundle_out, xi) * Modelica.Constants.g_n * ( z_bundle_out - z_bundle_in) "Geostatic pressure difference";

  // _________VLE Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_bundle_in(fixed=false) "VLE medium's inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_bundle_in = TILMedia.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_vle_bundle_in) "Rprt: VLE medium's inlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_bundle_in = p_vle_bundle_out + Delta_p_vle_bundle + Delta_p_geo_bundle " VLE medium's inlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_bundle_in = m_flow_vle_bundle "VLE medium's inlet mass flow";

// _________VLE Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_bundle_out=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      vleMedium,
      p_vle_bundle_out,
      T_vle_bundle_out) "VLE  medium's outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_bundle_out(fixed=false) "VLE medium's outlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_bundle_out = P_target_*p_vle_bundle_out_nom "VLE  medium's outlet pressure";

// _________VLE Evaporator Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_in(fixed=false) "VLE medium's inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_in = TILMedia.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_in,
      h_vle_wall_in) "Rprt: VLE medium's inlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_in = p_vle_wall_out + Delta_p_vle_wall + Delta_p_geo_wall " VLE medium's inlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_in(fixed=false) "VLE medium's inlet mass flow";

// _________VLE Evaporator Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out(fixed=false) "Outlet specific enthalpy";

  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_out = TILMedia.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_out,
      h_vle_wall_out) "VLE  medium's outlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_out(fixed=false) "VLE  medium's outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_out=m_flow_vle_wall_in "VLE medium's inlet mass flow";

// _________GAS Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_in = (m_flow_fg*h_fg_out-m_flow_vle_bundle_in*h_vle_bundle_in+m_flow_vle_bundle_in*h_vle_bundle_out-m_flow_vle_wall_in*h_vle_wall_in+m_flow_vle_wall_in*h_vle_wall_out)/m_flow_fg "FG medium's inlet specific enthalpy flue gas";
  final parameter ClaRa.Basics.Units.Temperature T_fg_in=
      TILMedia.GasFunctions.temperature_phxi(
      flueGas,
      p_fg_in,
      h_fg_in,
      xi_fg_in) "FG inlet temperature";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_in[inletGas.flueGas.nc-1](fixed=false) "FG medium's inlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_in = p_fg_out "FG medium's inlet pressure";

// _________GAS Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_out = TILMedia.GasFunctions.specificEnthalpy_pTxi(flueGas, p_fg_out, T_fg_out, xi_fg_out) " FG medium's outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_fg_out(fixed=false) "FG medium's outlet temperature";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_out[outletGas.flueGas.nc-1] = xi_fg_in "FG medium's outlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_out(fixed=false) "FG medium's outlet pressure";

// ________WALL Temperature __________________

  final parameter ClaRa.Basics.Units.Temperature T_wall_wall = ((T_fg_out+T_fg_in)/2 + (T_vle_wall_in + T_vle_wall_out)/2)/2 "Wall temperature of wall tubes";
  final parameter ClaRa.Basics.Units.Temperature T_wall_bundle= ((T_fg_out+T_fg_in)/2 + (T_vle_bundle_in + T_vle_bundle_out)/2)/2 "Wall temperature of bundle tubes";
// ____________________________________
protected
  Modelica.Blocks.Tables.CombiTable1D table1(table=CharLine_Delta_p_P_target_, u = {P_target_});
  Modelica.Blocks.Tables.CombiTable1D table2(table=CharLine_T_bundle_P_target_, u = {P_target_});
  Modelica.Blocks.Tables.CombiTable1D table3(table=CharLine_h_wall_P_target_, u = {P_target_});

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_a inletBundle(p=p_vle_bundle_in, m_flow=m_flow_vle_bundle, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,30}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={104,20})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outletBundle(
    h=h_vle_bundle_out,
    p=p_vle_bundle_out,
    m_flow=m_flow_vle_bundle, Medium=vleMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={100,-30}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=0,
        origin={104,-20})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outletGas(flueGas=flueGas, xi=xi_fg_out) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-40,105})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_a inletGas(
    flueGas=flueGas,
    m_flow=m_flow_fg,
    p=p_fg_in,
    T=T_fg_in) annotation (Placement(transformation(
        extent={{-110,30},{-100,50}},
        rotation=90,
        origin={0,0})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inletWall(p=p_vle_wall_in, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-70}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={104,-60})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outletWall(h=h_vle_wall_out, m_flow=m_flow_vle_wall_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={100,70}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=0,
        origin={104,60})));
initial equation
  Delta_p_vle_bundle =  Delta_p_vle_bundle_nom*table1.y[1];
  Delta_p_vle_wall = Delta_p_vle_wall_nom*table1.y[1];

  T_vle_bundle_out= T_vle_bundle_out_nom*table2.y[1];

  h_vle_bundle_in = inletBundle.h;

  h_vle_wall_in=inletWall.h;
  m_flow_vle_wall_in=inletWall.m_flow;
  p_vle_wall_out=outletWall.p;
  h_vle_wall_out=h_vle_wall_out_nom*table3.y[1];

  m_flow_fg = outletGas.m_flow;
  T_fg_out = outletGas.T;
  p_fg_out = outletGas.p;

  xi_fg_in = inletGas.xi;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),                                                                               Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({118,106,98}, if Delta_T_L_wall*Delta_T_U_wall >= 0 or Delta_T_L_bundle*Delta_T_U_bundle >= 0 then {118,106,98} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_T_L_wall*Delta_T_U_wall >= 0 or Delta_T_L_bundle*Delta_T_U_bundle >= 0 then FillPattern.Solid else FillPattern.Backward)),
        Line(
          points={{100,20},{-30,20},{40,0},{-30,-20},{100,-20}},
          color=DynamicSelect({0,131,169}, if h_vle_bundle_out - h_dew_bundle > 10 then {167,25,48} elseif h_vle_bundle_out - h_bub_bundle > -10 then {115,150,0} else {0,131,069}),
          smooth=Smooth.None),
        Line(
          points={{100,60},{80,60},{80,80},{-80,80},{-80,-80},{80,-80},{80,-60},{100,-60}},
          color=DynamicSelect({0,131,169}, if h_vle_wall_out - h_dew_wall > 10 then {167,25,48} elseif h_vle_wall_out - h_bub_wall > -10 then {115,150,0} else {0,131,069}),
          smooth=Smooth.None),
        Text(
          extent={{-80,80},{80,18}},
          lineColor={0,131,169},
          textString="%name")}));
end FlameRoom1;
