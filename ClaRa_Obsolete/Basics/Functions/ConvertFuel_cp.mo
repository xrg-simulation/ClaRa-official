within ClaRa_Obsolete.Basics.Functions;
function ConvertFuel_cp "Convert fuel's cp from version <= 1.2.2 to version 1.3.0 and above"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Media.Fuel.PartialFuel fuelType = ClaRa.Basics.Media.Fuel.Coal_v1() "Old fuel definition" annotation(choicesAllMatching);
  input ClaRa.Basics.Units.EnthalpyMassSpecific cp_set= 1260 "Spec. heat capacity";
  input ClaRa.Basics.Units.MassFraction xi[:] "Old composition, size = fuelType.nc-1";

  output ClaRa.Basics.Units.EnthalpyMassSpecific cp_new;

protected
  constant ClaRa.Basics.Units.EnthalpyMassSpecific C_cp_w = 4190;
  constant ClaRa.Basics.Units.EnthalpyMassSpecific C_cp_a = 1000;

algorithm
  cp_new :=(cp_set - (1 - sum(xi))*C_cp_w - xi[fuelType.nc-1]*C_cp_a)/sum(xi[1:fuelType.nc - 2]);
end ConvertFuel_cp;
