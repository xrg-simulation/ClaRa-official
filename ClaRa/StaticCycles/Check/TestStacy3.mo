within ClaRa.StaticCycles.Check;
model TestStacy3
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.InitSteamCycle_SimplePowerPlant1 staCy annotation (Placement(transformation(extent={{-80,-60},{80,80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));

    annotation(experiment(StopTime=2, method="dassl"));
end TestStacy3;
