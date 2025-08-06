within ClaRa_Obsolete.Basics.Functions;
function ConvertFuel_xi "Convert fuel's composition from version <= 1.2.2 to version 1.3.0 and above"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Media.Fuel.PartialFuel fuelType = ClaRa.Basics.Media.Fuel.Coal_v1() "Old fuel definition" annotation(choicesAllMatching);
  input ClaRa.Basics.Units.MassFraction xi[:] "";

  output ClaRa.Basics.Units.EnthalpyMassSpecific xi_new[2];


algorithm
  xi_new :={sum(xi[1:fuelType.nc - 2]),xi[fuelType.nc - 1]};
end ConvertFuel_xi;
