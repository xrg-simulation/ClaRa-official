within ClaRa_Obsolete.Components.Utilities.Check;
model test_1_LimPID_110_vs_111
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                        //
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  ClaRa.Components.Utilities.Blocks.LimPID PID_111(
    k=10,
    y_start=4,
    xi_start=3,
    xd_start=2,
    y_max=100,
    Tau_i=0.1,
    Tau_d=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initOption=796) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1)
    annotation (Placement(transformation(extent={{-82,60},{-62,80}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.2,
    freqHz=0.1,
    offset=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,18})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=1,
    y_start=0.3)
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-8,24})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,24})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 10)
    annotation (Placement(transformation(extent={{-82,72},{-62,52}})));
  LimPID_110 PID_110(
    k=10,
    y_start=4,
    xi_start=3,
    xd_start=2,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_max=100,
    Tau_i=0.1,
    Tau_d=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PID)
             annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=1,
    y_start=0.3)
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-8,-76})));
  Modelica.Blocks.Math.Add add1
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,-76})));
equation
  connect(realExpression.y, PID_111.u_s) annotation (Line(
      points={{-61,70},{-42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, firstOrder.u) annotation (Line(
      points={{9,24},{4,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, add.u1) annotation (Line(
      points={{59,18},{32,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_111.y, add.u2) annotation (Line(
      points={{-19,70},{50,70},{50,30},{32,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, PID_111.u_m) annotation (Line(
      points={{-19,24},{-29.9,24},{-29.9,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PID_110.u_s) annotation (Line(
      points={{-61,70},{-56,70},{-56,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, firstOrder1.u) annotation (Line(
      points={{9,-76},{4,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, add1.u1) annotation (Line(
      points={{59,18},{56,18},{56,-82},{32,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_110.y, add1.u2) annotation (Line(
      points={{-19,-30},{50,-30},{50,-70},{32,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, PID_110.u_m) annotation (Line(
      points={{-19,-76},{-30,-76},{-30,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput(equdistant=false));
end test_1_LimPID_110_vs_111;
