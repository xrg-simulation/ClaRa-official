within ClaRa.Basics.Media.FuelFunctions;
function heatCapacity_pTxi "Heat capacity as function of p, T and xi"
  input ClaRa.Basics.Units.Pressure p "Pressure";
  input ClaRa.Basics.Units.Temperature T "Temperature";
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Mass fraction of components";
  input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output ClaRa.Basics.Units.HeatCapacityMassSpecific cp;
algorithm
        cp:= sum({xi_c[i]*fuelType.C_cp[i] for i in 1:fuelType.N_c-1}) + (1-sum(xi_c))*fuelType.C_cp[fuelType.N_c];
end heatCapacity_pTxi;
