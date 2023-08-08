﻿within ClaRa_Obsolete.SubSystems.Check;
model testCoalSupplyBoiler7_XRG_vr
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  ClaRa.Components.Control.PredictorModels_3508.CoalSupplyBoiler_01_XRG Model_boiler(p_LS_nom=24000000) annotation (Placement(transformation(extent={{6,116},{48,150}})));
  Modelica.Blocks.Sources.Step ramp1(
    offset=1,
    height=-0.5,
    startTime=40000)
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID(
    y_max=1,
    Tau_d=1000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=-1,
    perUnitConversion=true,
    y_ref=1,
    u_ref=1,
    Tau_i=500,
    k=2.5,
    y_start=0,
    initOption=501) annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
  Modelica.Blocks.Sources.RealExpression SV_Pressure_LS(y=
        turbinesAndReheat_01_XRG.P_gen_) "Set value of live steam pressure"
    annotation (Placement(transformation(extent={{-132,80},{-112,100}})));
  Modelica.Blocks.Sources.RealExpression MV_Pressure_LS(y=homotopy(
        realPlantPower_.y, turbinesAndReheat_01_XRG.P_gen_)) "Measurement value of live steam pressure"
    annotation (Placement(transformation(extent={{-132,64},{-112,84}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    offset=1,
    height=-0.5,
    duration=600,
    startTime=6000)
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-42,86},{-22,106}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 HPTurbine(
    rho_nom=74.2585,
    Pi=28e5/240e5,
    p_nom=24000000) annotation (Placement(transformation(extent={{78,-74},{90,-58}})));
  inner ClaRa.SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{180,180},{200,200}})));
  ClaRa.Components.Control.PredictorModels_3508.TurbinesAndReheat_01_XRG turbinesAndReheat_01_XRG(
    p_nom=2800000,
    P_G_nom=507.7e6,
    CL_Deltah_p=[0.5000e7,0.7*0.1889e7; 0.6000e7,0.7*0.1889e7; 0.8000e7,0.7*0.1910e7; 1.0000e7,0.7*0.1923e7; 1.2000e7,0.7*0.1930e7; 1.4000e7,0.7*0.1933e7; 1.6000e7,0.7*0.1934e7; 1.8000e7,0.7*0.1933e7; 2.0000e7,1.0e6; 2.2000e7,1.1e6; 2.4000e7,1.2117e+006; 2.5000e7,1.2117e+006]) annotation (Placement(transformation(extent={{82,90},{112,124}})));
  Modelica.Blocks.Sources.RealExpression realPlantPower_(y=-(HPTurbine.P_t +
        IPTurbine.P_t + LPTurbine.P_t)/turbinesAndReheat_01_XRG.P_G_nom)
    annotation (Placement(transformation(extent={{104,-26},{124,-6}})));
  ClaRa_Obsolete.SubSystems.SteamGenerator_L3_vr steamGenerator_1_XRG(
    initHP=ClaRa.Basics.Choices.Init.noInit,
    h_LS_start=3400e3,
    p_LS_start=24000000,
    p_RH_start=2800000) annotation (Placement(transformation(extent={{6,-64},{32,-28}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG(
    m_flow_const=419,
    h_const=500e3,
    variable_m_flow=true) annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
protected
  ClaRa.Basics.Interfaces.SteamSignal mediumData_b annotation (Placement(transformation(extent={{-134,-61},{-128,-55}})));
public
  Modelica.Blocks.Math.Gain gain(k=Model_boiler.m_flow_LS_nom) annotation (Placement(transformation(extent={{-122,-62},{-110,-50}})));
  ClaRa.Visualisation.Scope scope(
    color={255,255,0},
    hideInterface=false,
    t_end=15000) annotation (Placement(transformation(extent={{144,-44},{188,-4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=5000) annotation (Placement(transformation(extent={{204,-94},{184,-74}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 IPTurbine(
    m_flow_nom=419,
    Pi=4e5/28e5,
    p_nom=2800000) annotation (Placement(transformation(extent={{100,-76},{116,-56}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 LPTurbine(
    Pi=0.0125,
    rho_nom=1.7,
    m_flow_nom=419 - 150,
    p_nom=400000,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.9; 1,0.9]))) annotation (Placement(transformation(extent={{138,-76},{154,-56}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_IET3_1(initOption=208, redeclare model PressureLossIn = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear) annotation (Placement(transformation(extent={{114,-102},{134,-90}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG1(variable_m_flow=false, m_flow_const=-150) annotation (Placement(transformation(extent={{124,-138},{144,-118}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    offset=1,
    height=-0.5,
    duration=600,
    startTime=60000)
    annotation (Placement(transformation(extent={{-86,-22},{-66,-2}})));
equation

  connect(ramp1.y, Model_boiler.yT_)         annotation (Line(
      points={{-79,170},{46,170},{46,148.3},{42.5077,148.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SV_Pressure_LS.y, PID.u_s) annotation (Line(
      points={{-111,90},{-100,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MV_Pressure_LS.y, PID.u_m)  annotation (Line(
      points={{-111,74},{-88,74},{-88,78},{-87.9,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, add.u1) annotation (Line(
      points={{-79,130},{-66,130},{-66,102},{-44,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, Model_boiler.QF_setl_) annotation (Line(
      points={{-79,130},{6,130},{6,130.62}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(turbinesAndReheat_01_XRG.inlet, Model_boiler.steamSignal) annotation (
     Line(
      points={{82.3,120.6},{54,120.6},{54,122.8},{48.3231,122.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HPTurbine.outlet, steamGenerator_1_XRG.reheat_in) annotation (Line(
      points={{90,-74},{90,-84},{26,-84},{26,-63.55},{26.8,-63.55}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HPTurbine.inlet, steamGenerator_1_XRG.livesteam) annotation (Line(
      points={{78,-61.2},{64,-61.2},{64,-8},{20,-8},{20,-28},{19,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gain.y, massFlowSource_XRG.m_flow) annotation (Line(
      points={{-109.4,-56},{-98,-56},{-98,-52},{-96,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, mediumData_b.p_) annotation (Line(
      points={{-123.2,-56},{-126,-56},{-126,-57.985},{-130.985,-57.985}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(realPlantPower_.y, scope.u) annotation (Line(
      points={{125,-16},{142.114,-16},{142.114,-15.0769}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(Model_boiler.steamSignal, mediumData_b) annotation (Line(
      points={{48.3231,122.8},{48.3231,186},{-140,186},{-140,-58},{-131,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(LPTurbine.outlet,pressureSink_XRG. steam_a) annotation (Line(
      points={{154,-76},{154,-84},{184,-84}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(IPTurbine.outlet,split_IET3_1. inlet) annotation (Line(
      points={{116,-76},{114,-76},{114,-96}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG1.steam_a,split_IET3_1. outlet2) annotation (Line(
      points={{144,-128},{150,-128},{150,-102},{124,-102}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(steamGenerator_1_XRG.reheat_out, IPTurbine.inlet) annotation (Line(
      points={{26.8,-28},{100,-28},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID.y, add.u2) annotation (Line(
      points={{-77,90},{-44,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, steamGenerator_1_XRG.QF_setl_) annotation (Line(
      points={{-21,96},{3.4,96},{3.4,-52.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(split_IET3_1.outlet1, LPTurbine.inlet) annotation (Line(
      points={{134,-96},{134,-96},{134,-58},{134,-60},{138,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(massFlowSource_XRG.steam_a, steamGenerator_1_XRG.feedwater) annotation (Line(
      points={{-74,-58},{-56,-58},{-44,-58},{-44,-98},{20,-98},{20,-63.55},{19,-63.55}},
      color={0,131,169},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-200},{200,200}}),
                      graphics={
        Rectangle(extent={{-144,32},{198,-194}},lineColor={0,0,0}),
        Rectangle(
          extent={{-144,200},{122,38}},
          lineColor={0,0,0},
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,50},{136,38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Model-based process control"),
        Text(
          extent={{48,30},{198,18}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Process model")}),
                                 Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end testCoalSupplyBoiler7_XRG_vr;
