within ClaRa.Basics.Interfaces;
connector FluidPortOut
  extends ClaRa.Basics.Interfaces.FluidPortIn;
  annotation (Icon(graphics={             Ellipse(
          extent={{-60,60},{60,-60}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          lineColor={0,131,169},
          lineThickness=0.5)}));
end FluidPortOut;
