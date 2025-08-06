within ClaRa_Obsolete.Basics.Interfaces;
connector Fuel_outlet
  extends ClaRa_Obsolete.Basics.Interfaces.Fuel_inlet;
  annotation (Icon(graphics={
                            Ellipse(
          extent={{-60,60},{60,-60}},
          pattern=LinePattern.Solid,
          fillColor={255,255,255},
          lineColor={27,36,42},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid)}));
end Fuel_outlet;
