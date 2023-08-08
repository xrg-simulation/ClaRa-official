within ClaRa.StaticCycles.Check;
model TestStacy5
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.InitSteamCycle_Rostock_HRO_20 staCy annotation (Placement(transformation(extent={{-38,-46},{38,26}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  annotation(experiment(StopTime=2, method="dassl"));

end TestStacy5;
