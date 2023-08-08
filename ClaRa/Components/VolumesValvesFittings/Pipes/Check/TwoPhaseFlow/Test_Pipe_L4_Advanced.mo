within ClaRa.Components.VolumesValvesFittings.Pipes.Check.TwoPhaseFlow;
model Test_Pipe_L4_Advanced
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Modelica.Blocks.Math.MultiSum multiSum(nu=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={77,2})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=100000) annotation (Placement(transformation(extent={{64,-13},{44,7}})));
  inner SimCenter simCenter(                                                                                useHomotopy=false) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  PipeFlowVLE_L4_Advanced                                                       tube(
    z_in=0,
    showExpertSummary=true,
    showData=true,
    Delta_x=ones(tube.N_cv)*tube.length/tube.N_cv,
    length=80,
    diameter_i=0.03,
    z_out=80,
    N_tubes=300,
    N_cv=40,
    p_start=linspace(
        2e7,
        1.9e7,
        tube.N_cv),
    frictionAtInlet=true,
    initOption=0,
    h_start=linspace(
        1.4e6,
        1.4e6,
        tube.N_cv),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    frictionAtOutlet=false,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(extent={{24,-9},{-10,4}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,-3})));
  inner Modelica.Fluid.System system annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Sources.Step outlet_pressure(
    startTime=100,
    height=0,
    offset=1.9e7) annotation (Placement(transformation(extent={{-96,-19},{-76,1}})));
  Modelica.Blocks.Sources.Ramp mass_flow(
    startTime=500,
    duration=20,
    height=0,
    offset=280) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,36})));

  Modelica.Blocks.Sources.Ramp T_wall(
    startTime=1000,
    duration=200,
    height=300,
    offset=573) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-85.5,33.5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-12,33})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-52,24},{-38,43}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    diameter_i=tube.diameter_i,
    diameter_o=tube.diameter_i + 0.01,
    T_start=573*ones(tube.N_cv),
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=2,
    N_tubes=tube.N_tubes,
    initOption=0) annotation (Placement(transformation(extent={{0,11},{12,25}})));

  Modelica.Blocks.Sources.Step inlet_enthalpy(
    startTime=2000,
    height=0,
    offset=1.4e6) annotation (Placement(transformation(
        extent={{-9,-9.5},{9,9.5}},
        rotation=0,
        origin={49,-33.5})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{69.98,2},{68,2},{66,3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, outlet_pressure.y) annotation (Line(
      points={{-52,-9},{-75,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow.y) annotation (Line(
      points={{83,2},{83,2},{90,2},{90,36},{61,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{24,-2.5},{32,-2.5},{32,-3},{44,-3}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-32,-3},{-18,-3},{-18,-2.5},{-10,-2.5}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-73.95,33.5},{-53.26,33.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature.T) annotation (Line(
      points={{-37.3,33.4525},{-20,33},{-19.2,33}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thinWall.outerPhase) annotation (Line(
      points={{-6,33},{6,33},{6,25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{6,11},{6,2.7},{7,2.7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_enthalpy.y) annotation (Line(
      points={{66,-3},{70,-3},{70,-33.5},{58.9,-33.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,120}}), graphics={Text(
          extent={{-98,112},{100,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
test the L4 advanced  pipe at evaporation scenario
______________________________________________________________________________________________
"),                                               Text(
          extent={{-98,88},{94,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-98,98},{100,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
Scenario:  increase of outer wall temperature (at t=1000s 300°c --> 600 °C) causing evaporation in pipe     
 _______________________________________________________________________________________
")}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false, events=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)));
end Test_Pipe_L4_Advanced;
