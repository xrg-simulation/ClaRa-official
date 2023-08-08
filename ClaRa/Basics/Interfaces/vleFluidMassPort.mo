within ClaRa.Basics.Interfaces;
connector vleFluidMassPort
  flow Units.Mass mass_fluid "Accumulated fluid mass";
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={149,45,152},
          lineThickness=0.5,
          fillColor={149,45,152},
          fillPattern=FillPattern.Solid)}));
end vleFluidMassPort;
