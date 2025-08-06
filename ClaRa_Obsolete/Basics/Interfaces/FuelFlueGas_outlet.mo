within ClaRa_Obsolete.Basics.Interfaces;
connector FuelFlueGas_outlet "Port describing Coal and CombustionAir flow"

   parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType;

  ClaRa.Basics.Interfaces.GasPortOut flueGas
    annotation (Placement(transformation(extent={{-30,-70},{30,-10}})));
  ClaRa_Obsolete.Basics.Interfaces.Fuel_outlet fuel(fuelType=fuelType) annotation (Placement(transformation(extent={{-30,10},{30,70}})));
  annotation (Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          lineThickness=0.5,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-45,45},{45,-45}},
          lineColor={27,36,42},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics));
end FuelFlueGas_outlet;
