within ClaRa.Basics.Interfaces;
connector Slag_outlet
  extends ClaRa.Basics.Interfaces.Slag_inlet;
  annotation (Icon(graphics={
                            Ellipse(
          extent={{-60,60},{60,-60}},
          pattern=LinePattern.Solid,
          fillColor={255,255,255},
          lineColor={234,171,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid)}));
end Slag_outlet;
