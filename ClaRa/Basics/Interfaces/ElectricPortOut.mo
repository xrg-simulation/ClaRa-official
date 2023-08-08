within ClaRa.Basics.Interfaces;
connector ElectricPortOut
  extends Basics.Interfaces.ElectricPortIn;
  annotation (Icon(graphics={
                            Ellipse(
          extent={{-60,60},{60,-60}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          lineColor={115,150,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid)}));
end ElectricPortOut;
