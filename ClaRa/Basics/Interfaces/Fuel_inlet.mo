within ClaRa.Basics.Interfaces;
connector Fuel_inlet
   parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel = ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1()  "Fuel type";

  ClaRa.Basics.Units.Pressure p "Pressure";
  flow ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow";
  stream ClaRa.Basics.Units.Temperature T_outflow "Temperature valid for outflow conditions";
  stream ClaRa.Basics.Units.MassFraction xi_outflow[fuelModel.N_c-1] "Composition valid for outflow conditions";

  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={27,36,42},
          lineThickness=0.5,
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)}));
end Fuel_inlet;
