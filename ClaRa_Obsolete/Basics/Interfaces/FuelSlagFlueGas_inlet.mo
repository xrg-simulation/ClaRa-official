within ClaRa_Obsolete.Basics.Interfaces;
connector FuelSlagFlueGas_inlet "Port describing Coal,Slag and FlueGas flow"

  // Media properties of coal and slag
  parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType;
  parameter ClaRa.Basics.Media.Slag.PartialSlag slagType;

  ClaRa.Basics.Interfaces.GasPortIn flueGas
    annotation (Placement(transformation(extent={{40,-30},{100,30}})));
  ClaRa_Obsolete.Basics.Interfaces.Fuel_inlet fuel(fuelType=fuelType) annotation (Placement(transformation(extent={{-100,-30},{-40,30}})));
  ClaRa.Basics.Interfaces.Slag_outlet slag(slagType=slagType)
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

  annotation (Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          fillColor={118,106,98},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-35,35},{35,-35}},
          lineColor={27,36,42},
          fillColor={234,171,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={234,171,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics));
end FuelSlagFlueGas_inlet;
