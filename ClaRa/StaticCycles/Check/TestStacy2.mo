within ClaRa.StaticCycles.Check;
model TestStacy2
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.StaCy_5Components_Spray staCy(triple2(decimalSpaces(m_flow=2)))
                                                    annotation (Placement(transformation(extent={{-80,-60},{60,80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));

  annotation(experiment(StopTime=2, method="dassl"));
end TestStacy2;
