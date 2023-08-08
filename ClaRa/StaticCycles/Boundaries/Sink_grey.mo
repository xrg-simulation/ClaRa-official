within ClaRa.StaticCycles.Boundaries;
model Sink_grey "A boundary for power connections"

  final parameter ClaRa.Basics.Units.Power P(fixed = false) "Power to sink";
  ClaRa.StaticCycles.Fundamentals.PowerSignal_A inlet(s="") annotation (Placement(transformation(extent={{-100,-10},{-92,10}}), iconTransformation(extent={{-100,-10},{-92,10}})));

initial equation
  inlet.power=P;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={118,124,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(P, format = "1.3e")),
        Line(
          visible = true,
          points={{-100,100},{-60,0},{-100,-100}},
          color={118,124,127})}));
end Sink_grey;
