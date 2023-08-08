within ClaRa.Components.Control.PredictorModels_3508;
model CoalSupplyBoiler_01_XRG "A simple coal supply and boiler model using characteristic lines and transfer functions"
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

  extends ClaRa.Components.Control.PredictorModels_3508.Icons.BoilerPredictor;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="01");

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(group="Fundamental Definitions"));

  parameter Modelica.SIunits.Pressure p_LS_nom= 300e5 "Nominal life steam pressure"
                                                                                  annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.Pressure Delta_p_nom = 40e5 "Nominal life steam pressure loss"       annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_LS_nom = 3279e3 "Nominal life steam specific enthalpy"
                                                                                            annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_LS_nom = 419 "Nominal life steam flow rate" annotation(Dialog(group="Nominal values"));

  parameter Real CL_mflowLS_QF_[:,:]=[0, 0.32; 0.34, 0.32; 1, 1] "Characteristic line life steam flow as function of thermal output"
                                                                        annotation(Dialog(group="Part Load Definition"));
  parameter Real CL_pLS_QF_[:,:]=[0, 0.32; 0.34, 0.32; 1, 1] "Characteristic line life steam pressure as function of thermal output"
                                                                            annotation(Dialog(group="Part Load Definition"));
  parameter Real CL_Valve_[:,:]=[0,0; 1, 1] "Characteristics of the turbine valve"
                                           annotation(Dialog(group="Part Load Definition"));
  parameter Real CL_Deltap_mflowLS_[:,:]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "Characteristic line of life steam pressure drop as function of mass flow rate"
                                                                                    annotation(Dialog(group="Part Load Definition"));
  parameter Real CL_hEvap_pD_[:,:] = [0.34, 2806e3; 0.55, 2708e3; 0.75, 2559e3; 1, 2200e3] "Characteristic line evap outlet enthalpy over pressure"
                                                             annotation(Dialog(group="Part Load Definition"));

  parameter Modelica.SIunits.Time tau_u = 120 "equivalent dead time of steam generation" annotation(Dialog(group="Time Response Definition"));
  parameter Modelica.SIunits.Time Tau_g = 200 "balancing time of steam generation" annotation(Dialog(group="Time Response Definition"));
  parameter Modelica.SIunits.Time Tau_s = 200 "Integration time of steam storage"  annotation(Dialog(group="Time Response Definition"));
  parameter Modelica.SIunits.Time Tau_evap=5 "Time constant for energy storage in evaporator"
                                                    annotation(Dialog(group="Time Response Definition"));

  parameter Real y_T_const = 1 "Constant turbine valve aperture" annotation(Dialog(group="Control Definition"));
  input Modelica.SIunits.Temperature T_LS = 823.15 "Value of life steam temperature" annotation(Dialog(group="Control Definition"));
  Modelica.SIunits.Pressure p_LS "Life steam pressure";
  parameter Real p_LS_0=1 "Initial value of life steam pressure in p.u." annotation(Dialog(group="Initialisation"));

protected
  Modelica.Blocks.Sources.RealExpression h(y=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(medium, p_LS, T_LS)/h_LS_nom) "Life Steam specific enthalpy"
                                   annotation (Placement(transformation(extent={{0,60},{20,80}})));

public
  Modelica.Blocks.Continuous.LimIntegrator
                                        SteamStorage(k=1/Tau_s,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=p_LS_0,
    outMin=0,
    outMax=1.5) "A simple way to model the mass storage in the boiler"
    annotation (Placement(transformation(extent={{-6,-24},{14,-4}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-36,-24},{-16,-4}})));
  Modelica.Blocks.Continuous.TransferFunction heatRelease(a={Tau_g*tau_u,(Tau_g + tau_u),1},
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=p_LS_0) "comprehends the coal supply, the heat release and the steam generation"
    annotation (Placement(transformation(extent={{-66,-24},{-46,-4}})));
  Modelica.Blocks.Math.Product turbineValve "Effect of steam flow throtteling"
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));
  Modelica.Blocks.Interfaces.RealInput yT_ "Turbine valve aperture"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={120,108}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={126,90})));
  Modelica.Blocks.Tables.CombiTable1D turbineValveCaracteristics(table=
        CL_Valve_, columns={2})
    annotation (Placement(transformation(extent={{-4,-58},{16,-38}})));
  Modelica.Blocks.Tables.CombiTable1D convert2LifeSteamFlow(columns={2}, table=
        CL_mflowLS_QF_)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Tables.CombiTable1D convert2LifeSteamPressure(columns={2},
      table=CL_pLS_QF_)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Modelica.Blocks.Tables.CombiTable1D convert2PressureDrop(columns={2}, table=
        CL_Deltap_mflowLS_)
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealInput QF_setl_ "Set value of thermal output in p.u."
                                          annotation (Placement(transformation(
          extent={{-132,-18},{-92,22}}),iconTransformation(extent={{-120,-34},{-80,
            6}})));
  Basics.Interfaces.SteamSignal      steamSignal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={162,-60})));
  EnthalpyPredictor enthalpyPredictor(CL_hEvap_pD_=CL_hEvap_pD_,
      Tau_evap=Tau_evap,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    h_evap_start=2200e3)
    annotation (Placement(transformation(extent={{72,-98},{92,-78}})));
  Modelica.Blocks.Interfaces.RealOutput m_StG_ "Mass flow rate of steam generation in p.u."
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealOutput p_LS_ "Connector of Real output signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-110})));
equation
 if cardinality(yT_)==0 then
   turbineValveCaracteristics.u[1]=y_T_const;
 else
  turbineValveCaracteristics.u[1]=yT_;
 end if;
 p_LS=convert2LifeSteamPressure.y[1]*p_LS_nom;

  connect(feedback.y, SteamStorage.u) annotation (Line(
      points={{-17,-14},{-8,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatRelease.y, feedback.u1) annotation (Line(
      points={{-45,-14},{-34,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SteamStorage.y, turbineValve.u1) annotation (Line(
      points={{15,-14},{36,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValve.y, feedback.u2) annotation (Line(
      points={{59,-20},{74,-20},{74,-66},{-26,-66},{-26,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveCaracteristics.y[1], turbineValve.u2) annotation (Line(
      points={{17,-48},{24,-48},{24,-26},{36,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValve.y, convert2LifeSteamFlow.u[1]) annotation (Line(
      points={{59,-20},{74,-20},{74,30},{78,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LifeSteamPressure.u[1], SteamStorage.y) annotation (Line(
      points={{28,30},{20,30},{20,-14},{15,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LifeSteamFlow.y[1], convert2PressureDrop.u[1]) annotation (
      Line(
      points={{101,30},{110,30},{110,50},{118,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatRelease.u, QF_setl_) annotation (Line(
      points={{-68,-14},{-82,-14},{-82,2},{-112,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LifeSteamFlow.y[1], steamSignal.m_flow_) annotation (Line(
      points={{101,30},{110,30},{110,-59.9},{161.9,-59.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(h.y, steamSignal.h_) annotation (Line(
      points={{21,70},{148,70},{148,-59.9},{161.9,-59.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(convert2LifeSteamPressure.y[1], steamSignal.p_) annotation (Line(
      points={{51,30},{66,30},{66,-60},{100,-60},{100,-59.9},{161.9,-59.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(SteamStorage.y, enthalpyPredictor.u) annotation (Line(
      points={{15,-14},{30,-14},{30,-88},{70,-88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(enthalpyPredictor.y, steamSignal.h_evap) annotation (Line(
      points={{93,-88},{121.5,-88},{121.5,-60},{162,-60}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(heatRelease.y, m_StG_) annotation (Line(
      points={{-45,-14},{-40,-14},{-40,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_StG_, m_StG_) annotation (Line(points={{-40,-110},{-40,-110}}, color={0,0,127}));
  connect(convert2LifeSteamPressure.y[1], p_LS_) annotation (Line(points={{51,30},{66,30},{66,-78},{20,-78},{20,-110}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{-730,-116},{-710,-96}})),
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{160,100}}), graphics={
        Polygon(
          points={{100,76},{110,76},{110,-56},{156,-56},{158,-64},{106,-64},{106,72},{100,72},{100,76}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{116,-50},{116,-70},{136,-50},{136,-70},{116,-50}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Line(
          points={{126,72},{126,-60}},
          color={0,0,255},
          smooth=Smooth.None)}));
end CoalSupplyBoiler_01_XRG;
