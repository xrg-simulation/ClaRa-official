within ClaRa.StaticCycles.Boundaries;
model Source_grey "A boundary for power connections"

  parameter ClaRa.Basics.Units.Power P "Power from source" annotation (Dialog(enable=source));
  ClaRa.StaticCycles.Fundamentals.PowerSignal_B outlet(power=P) annotation (Placement(transformation(extent={{92,-10},{100,10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={118,124,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%P"),
        Line(
          visible = true,
          points={{60,100},{92,0},{60,-100}},
          color={118,124,127})}));
end Source_grey;
