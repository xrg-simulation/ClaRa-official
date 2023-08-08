within ClaRa.StaticCycles.Fundamentals;
connector PowerSignal_A
  input ClaRa.Basics.Units.Power power "Power going into the component";
  output String s;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}), graphics={Polygon(
          points={{-40,100},{40,60},{40,-60},{-40,-100},{-40,100}},
          lineColor={118,124,127},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}})));
end PowerSignal_A;
