within ClaRa.Basics.Interfaces;
connector GasPortOut
 //extends GasMixtureMassSpecific;
 extends GasMassSpecific;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          lineThickness=0.5,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-60,60},{58,-60}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          lineColor={118,106,98},
          lineThickness=0.5)}));
end GasPortOut;
