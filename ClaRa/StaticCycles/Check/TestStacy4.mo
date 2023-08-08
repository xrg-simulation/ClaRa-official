within ClaRa.StaticCycles.Check;
model TestStacy4
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.InitSteamCycle_Rostock_5 staCy annotation (Placement(transformation(extent={{-40,-46},{52,44}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  annotation(experiment(StopTime=2, method="dassl"));

end TestStacy4;
