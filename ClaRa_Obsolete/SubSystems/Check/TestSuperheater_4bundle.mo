within ClaRa_Obsolete.SubSystems.Check;
model TestSuperheater_4bundle
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
parameter Integer n_Axial=10;
Real Q_boiler;

  ClaRa_Obsolete.SubSystems.ConvectiveHeatingPart_4SH SH(
    N_ax=n_Axial,
    m_flow_nom=783,
    SH3_wall(Delta_x=ones(SH.superheater3.N_cv)*SH.length_SH3/SH.superheater3.N_cv, initOption=1),
    SH2_wall(Delta_x=ones(SH.superheater2.N_cv)*SH.length_SH2/SH.superheater2.N_cv, initOption=1),
    SH1_wall(Delta_x=ones(SH.superheater1.N_cv)*SH.length_SH1/SH.superheater1.N_cv, initOption=1),
    h_nomSH1_in=2803e3,
    h_nomSH1_out=3106e3,
    h_nomSH2_in=3061e3,
    h_nomSH2_out=3291e3,
    h_nomSH3_in=3243e3,
    h_nomSH3_out=3461e3,
    h_nom_Spray1=1363e3,
    h_start_Spray1=1363e3,
    h_nom_Spray2=1363e3,
    h_start_Spray2=1363e3,
    superheater3(Delta_x=ones(SH.superheater3.N_cv)*SH.length_SH3/SH.superheater3.N_cv),
    superheater2(Delta_x=ones(SH.superheater2.N_cv)*SH.length_SH2/SH.superheater2.N_cv),
    superheater1(Delta_x=ones(SH.superheater1.N_cv)*SH.length_SH1/SH.superheater1.N_cv),
    redeclare model HeatTransfer_SH2 = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=5000),
    redeclare model HeatTransfer_SH3 = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=5000),
    m_flow_nomSpray1=30,
    m_flow_nomSpray2=30,
    redeclare model HeatTransfer_SH1 = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.NominalPoint_L4 (alpha_nom=1000),
    superheater4(Delta_x=ones(SH.superheater4.N_cv)*SH.length_SH4/SH.superheater4.N_cv),
    redeclare model HeatTransfer_SH4 = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=5000),
    h_nomSH4_in=3400e3,
    h_nomSH4_out=3500e3,
    SH4_wall(Delta_x=ones(SH.superheater4.N_cv)*SH.length_SH4/SH.superheater4.N_cv, initOption=1),
    h_startSH2_out=3075e3,
    h_startSH3_out=3150e3,
    h_startSH1_out=2972e3,
    h_startSH4_out=3210e3,
    h_startSH1_in=2843e3,
    h_startSH2_in=3000e3,
    h_startSH3_in=3070e3,
    h_startSH4_in=3140e3,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    redeclare model PressureLoss_SH1 = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model PressureLoss_SH2 = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nomSH1_in=30260000,
    p_nomSH1_out=29540000,
    p_startSH1_in=30260000,
    p_startSH1_out=29540000,
    p_nomSH2_in=29330000,
    p_nomSH2_out=29050000,
    Delta_p_nomSH2=140000,
    p_startSH2_in=29330000,
    p_startSH2_out=29050000,
    redeclare model PressureLoss_SH3 = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nomSH3_in=28910000,
    p_nomSH3_out=28500000,
    Delta_p_nomSH3=140000,
    p_startSH3_in=28910000,
    p_startSH3_out=28500000,
    redeclare model PressureLoss_SH4 = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nomSH4_in=28300000,
    p_nomSH4_out=28000000,
    Delta_p_nomSH4=410000,
    p_startSH4_in=28300000,
    p_startSH4_out=28000000,
    Delta_p_nom_SI1=210000,
    Delta_p_nomSpray1=2460000,
    Delta_p_nom_SI2=140000,
    Delta_p_nomSpray2=2950000,
    initOptionSH1=0,
    initOptionSH2=0,
    initOptionSH3=0,
    initOption_Spray1=0,
    initOption_Spray2=0) annotation (Placement(transformation(extent={{-24,-14},{-2,36}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG(m_flow_const=783, h_const=2843e3) annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(h_const=3500e3, p_const=28400000) annotation (Placement(transformation(extent={{64,50},{40,72}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve_XRG(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=824.34)) annotation (Placement(transformation(extent={{6,54},{26,66}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG2(h_const=1363e3, p_const=32000000) annotation (Placement(transformation(extent={{102,9},{78,31}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG3(h_const=1363e3, p_const=32000000) annotation (Placement(transformation(extent={{102,-10},{78,12}})));
  inner ClaRa.SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow heating_SH1(
    N_axial=n_Axial,
    Delta_x=SH.superheater1.Delta_x,
    length=SH.length_SH1) annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow heating_SH2(
    N_axial=n_Axial,
    length=SH.length_SH2,
    Delta_x=SH.superheater2.Delta_x) annotation (Placement(transformation(extent={{-60,3},{-40,23}})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow heating_SH3(
    N_axial=n_Axial,
    length=SH.length_SH3,
    Delta_x=SH.superheater3.Delta_x) annotation (Placement(transformation(extent={{-60,19},{-40,39}})));
  Modelica.Blocks.Sources.Ramp T_LS_set(
    duration=1,
    startTime=100,
    height=0,
    offset=600)
    annotation (Placement(transformation(extent={{96,-48},{84,-36}})));
protected
  ClaRa.Basics.Interfaces.Bus SetValues annotation (Placement(transformation(extent={{64,-36},{84,-16}})));
public
  Modelica.Blocks.Sources.Ramp DT_SI2_set(
    duration=1,
    startTime=100,
    height=0,
    offset=20)
    annotation (Placement(transformation(extent={{98,-72},{86,-60}})));
  ClaRa.Components.Utilities.Blocks.Noise noise(
    Tau_sample=600,
    varMeanValue=true,
    stdDev_const=1e6) annotation (Placement(transformation(extent={{-98,28},{-78,48}})));
  ClaRa.Components.Utilities.Blocks.Noise noise1(
    Tau_sample=600,
    varMeanValue=true,
    stdDev_const=1e6) annotation (Placement(transformation(extent={{-98,2},{-78,22}})));
  ClaRa.Components.Utilities.Blocks.Noise noise2(
    Tau_sample=600,
    varMeanValue=true,
    stdDev_const=1e6) annotation (Placement(transformation(extent={{-98,-26},{-78,-6}})));
  ClaRa.Components.Utilities.Blocks.TimeExtrema timeExtrema[3] annotation (Placement(transformation(extent={{-28,-64},{-8,-44}})));

  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow heating_SH4(
    N_axial=n_Axial,
    length=SH.length_SH4,
    Delta_x=SH.superheater4.Delta_x) annotation (Placement(transformation(extent={{-58,39},{-38,59}})));
  ClaRa.Components.Utilities.Blocks.Noise noise3(
    Tau_sample=600,
    varMeanValue=true,
    stdDev_const=1e6) annotation (Placement(transformation(extent={{-98,60},{-78,80}})));
  Modelica.Blocks.Sources.Ramp SH3_Q(
    duration=1,
    startTime=100,
    height=0,
    offset=184857900/2)
    annotation (Placement(transformation(extent={{-142,34},{-122,54}})));
  Modelica.Blocks.Sources.Ramp SH1_Q(
    duration=1,
    startTime=100,
    height=0,
    offset=205960560)
    annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  Modelica.Blocks.Sources.Ramp SH2_Q(
    duration=1,
    startTime=5000,
    height=10e6,
    offset=184857900/2)
    annotation (Placement(transformation(extent={{-138,2},{-118,22}})));
  Modelica.Blocks.Sources.Ramp SH4_Q(
    duration=1,
    startTime=100,
    height=0,
    offset=179706120)
    annotation (Placement(transformation(extent={{-142,66},{-122,86}})));
  ClaRa.Components.Control.PowerPlantControl.LiveSteamTemperature liveSteamTemperature(
    k_PID2=0.1,
    k_PID1=0.1,
    Tau_i_PID1=500,
    T_a2_ref=600,
    T_e2_ref=536,
    Tau_i_PID2=10) annotation (Placement(transformation(extent={{34,-34},{54,-14}})));
equation
  Q_boiler=SH1_Q.y+SH2_Q.y+SH3_Q.y+SH4_Q.y;

  connect(valve_XRG.outlet, pressureSink_XRG.steam_a) annotation (Line(
      points={{26,60},{34,60},{34,61},{40,61}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG2.steam_a, SH.spray2)
    annotation (Line(
      points={{78,20},{14,20},{14,20.2593},{-1.45,20.2593}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG3.steam_a, SH.spray1)
    annotation (Line(
      points={{78,1},{37.2,1},{37.2,1.74074},{-1.45,1.74074}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heating_SH1.port, SH.heatSH1)                           annotation (
      Line(
      points={{-40,-10},{-32,-10},{-32,-7.51852},{-24,-7.51852}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating_SH2.port, SH.heatSH2)                           annotation (
      Line(
      points={{-40,13},{-31.8,13},{-31.8,7.2963},{-24.3667,7.2963}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating_SH3.port, SH.heatSH3)                           annotation (
      Line(
      points={{-40,29},{-32,29},{-32,15.8148},{-24.3667,15.8148}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH.outlet, valve_XRG.inlet)                           annotation (
      Line(
      points={{-12.45,36},{-12.45,60},{6,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH.inlet, massFlowSource_XRG.steam_a)
    annotation (Line(
      points={{-12.45,-14.1852},{-12.45,-38},{-40,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_LS_set.y, SetValues.T_a2_set) annotation (Line(
      points={{83.4,-42},{74,-42},{74,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DT_SI2_set.y, SetValues.Delta_T2_set) annotation (Line(
      points={{85.4,-66},{74,-66},{74,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise1.y, heating_SH2.Q_flow) annotation (Line(
      points={{-77,12},{-68.5,12},{-68.5,13},{-60,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise.y, heating_SH3.Q_flow) annotation (Line(
      points={{-77,38},{-68,38},{-68,29},{-60,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise2.y, heating_SH1.Q_flow) annotation (Line(
      points={{-77,-16},{-68,-16},{-68,-10},{-60,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise2.y, timeExtrema[1].u) annotation (Line(
      points={{-77,-16},{-74,-16},{-74,-54},{-30,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise1.y, timeExtrema[2].u) annotation (Line(
      points={{-77,12},{-74,12},{-74,-54},{-30,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise.y, timeExtrema[3].u) annotation (Line(
      points={{-77,38},{-74,38},{-74,-54},{-30,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating_SH4.port, SH.heatSH4) annotation (Line(
      points={{-38,49},{-34,49},{-34,48},{-28,48},{-28,28.7778},{-24.1833,28.7778}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noise3.y, heating_SH4.Q_flow) annotation (Line(
      points={{-77,70},{-58,70},{-58,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH1_Q.y, noise2.mean) annotation (Line(
      points={{-117,-20},{-108,-20},{-108,-10},{-98,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH2_Q.y, noise1.mean) annotation (Line(
      points={{-117,12},{-108,12},{-108,18},{-98,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH4_Q.y, noise3.mean) annotation (Line(
      points={{-121,76},{-98,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH3_Q.y, noise.mean) annotation (Line(
      points={{-121,44},{-98,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH.Sensors,liveSteamTemperature. MeasurementValues) annotation (Line(
      points={{-1.81667,27.6667},{44.2,27.6667},{44.2,-14.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(liveSteamTemperature.SetValues, SetValues) annotation (Line(
      points={{49,-14},{50,-14},{50,-12},{74,-12},{74,-26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(liveSteamTemperature.opening2, SH.opening2) annotation (Line(
      points={{33,-22},{18,-22},{18,14.7037},{-2.73333,14.7037}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(liveSteamTemperature.opening1, SH.opening1) annotation (Line(
      points={{33,-32},{8,-32},{8,-3.81481},{-2.73333,-3.81481}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
            {100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end TestSuperheater_4bundle;
