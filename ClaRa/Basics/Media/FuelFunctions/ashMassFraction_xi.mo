within ClaRa.Basics.Media.FuelFunctions;
function ashMassFraction_xi "Mass fraction of ash as function xi"
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition";
  input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output ClaRa.Basics.Units.MassFraction xi_ash "Composition";
algorithm
  xi_ash :=if fuelType.ashIndex == fuelType.N_c then max(0, min(1, 1 - sum(xi_c))) else xi_c[fuelType.ashIndex];

end ashMassFraction_xi;
