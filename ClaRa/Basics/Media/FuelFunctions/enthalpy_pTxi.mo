within ClaRa.Basics.Media.FuelFunctions;
function enthalpy_pTxi "Specific enthalpy as function of p,T,xi"
  input ClaRa.Basics.Units.Pressure p "Pressure";
  input ClaRa.Basics.Units.Temperature T "Temperature";
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition";
  input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";
  output ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy";

algorithm
      h := heatCapacity_pTxi(p,T,xi_c, fuelType)*(T-fuelType.T_ref);
end enthalpy_pTxi;
