within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model Test_EN60534_incompressible
    extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-101,-100},{-59,-80}})));
  ValveVLE_L1 valveEN_60534_incompressible(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible) annotation (Placement(transformation(extent={{-10,44},{10,56}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG10(p_const=10e5, h_const=100e3)
                                                                                                      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG11(variable_p=true, h_const=100e3)
                                                                                           annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0.0,10e5; 10,9e5; 20,2e5; 30,40e5]) annotation (Placement(transformation(extent={{60,70},{80,90}})));
  ValveVLE_L1 valveEN_60534_incompressible_checkValve(
    showExpertSummary=true,
    checkValve=true,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible) annotation (Placement(transformation(extent={{-10,-16},{10,-4}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG1(p_const=10e5, h_const=100e3) annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG2(variable_p=true, h_const=100e3)
                                                                                           annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0.0,10e5; 10,9e5; 20,2e5; 30,40e5]) annotation (Placement(transformation(extent={{60,10},{80,30}})));
  ValveVLE_L1 valveEN_60534_incompressibleBackwards(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible) annotation (Placement(transformation(extent={{10,104},{-10,116}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG3(p_const=10e5, h_const=100e3) annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG4(variable_p=true, h_const=100e3)
                                                                                           annotation (Placement(transformation(extent={{60,100},{40,120}})));
  Modelica.Blocks.Sources.TimeTable timeTable2(table=[0.0,10e5; 10,9e5; 20,2e5; 30,40e5]) annotation (Placement(transformation(extent={{60,130},{80,150}})));
equation
  connect(valveEN_60534_incompressible.outlet, pressureSink_XRG11.steam_a) annotation (Line(
      points={{10,50},{40,50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG10.steam_a, valveEN_60534_incompressible.inlet) annotation (Line(
      points={{-40,50},{-10,50}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(timeTable.y, pressureSink_XRG11.p) annotation (Line(points={{81,80},{92,80},{92,56},{60,56}}, color={0,0,127}));
  connect(valveEN_60534_incompressible_checkValve.outlet, pressureSink_XRG2.steam_a) annotation (Line(
      points={{10,-10},{40,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG1.steam_a, valveEN_60534_incompressible_checkValve.inlet) annotation (Line(
      points={{-40,-10},{-10,-10}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(timeTable1.y, pressureSink_XRG2.p) annotation (Line(points={{81,20},{92,20},{92,-4},{60,-4}}, color={0,0,127}));
  connect(timeTable2.y, pressureSink_XRG4.p) annotation (Line(points={{81,140},{92,140},{92,116},{60,116}}, color={0,0,127}));
  connect(pressureSink_XRG3.steam_a, valveEN_60534_incompressibleBackwards.outlet) annotation (Line(
      points={{-40,110},{-10,110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveEN_60534_incompressibleBackwards.inlet, pressureSink_XRG4.steam_a) annotation (Line(
      points={{10,110},{40,110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,160}})),
    experiment(StopTime=30));
end Test_EN60534_incompressible;
