within ClaRa.Basics.Media.FuelFunctions;
function waterMassFraction_xi "Mass fraction of water as function xi"
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition";
  input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output ClaRa.Basics.Units.MassFraction xi_h2o "Composition";
algorithm
  xi_h2o :=if fuelType.waterIndex == fuelType.N_c then max(0, min(1, 1 - sum(xi_c))) else xi_c[fuelType.waterIndex];

end waterMassFraction_xi;
