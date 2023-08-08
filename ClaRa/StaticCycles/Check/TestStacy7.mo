within ClaRa.StaticCycles.Check;
model TestStacy7
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.InitSteamCycle_T_4_Pr_F1_C1 staCy annotation (Placement(transformation(extent={{-80,-80},{80,80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  annotation (experiment(StopTime=2, method="dassl"),
              Diagram(graphics,
                      coordinateSystem(initialScale=0.1)), Icon(graphics,
                                                                coordinateSystem(initialScale=0.1)));
end TestStacy7;
