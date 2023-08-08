within ClaRa.Basics.Media.FuelFunctions;
function LHV_pTxi
  input Real p;
  input Real T;
  input Real xi_c[:];
  input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output Real LHV;
algorithm
    LHV:= sum({xi_c[i]*fuelType.C_LHV[i] for i in 1:fuelType.N_c-1}) + (1-sum(xi_c))*fuelType.C_LHV[fuelType.N_c];
end LHV_pTxi;
