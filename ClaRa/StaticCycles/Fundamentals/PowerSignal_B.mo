within ClaRa.StaticCycles.Fundamentals;
connector PowerSignal_B
  output ClaRa.Basics.Units.Power power "Power going out of the component";
  input String s;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}), graphics={Polygon(
          points={{-40,100},{40,60},{40,-60},{-40,-100},{-40,100}},
          lineColor={118,124,127},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}})));
end PowerSignal_B;
