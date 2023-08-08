within ClaRa.Basics.Media.FuelFunctions;
function density_pTxi "Density as function of p,T,xi"
  input ClaRa.Basics.Units.Pressure p "Pressure";
  input ClaRa.Basics.Units.Temperature T "Temperature";
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition";
   input ClaRa.Basics.Media.FuelTypes.BaseFuel fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output ClaRa.Basics.Units.DensityMassSpecific rho "Density";
algorithm
     rho:= sum({xi_c[i]*fuelType.C_rho[i] for i in 1:fuelType.N_c-1}) + (1-sum(xi_c))*fuelType.C_rho[fuelType.N_c];
end density_pTxi;
