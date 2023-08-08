within ClaRa_Obsolete.Basics.Functions;
function ConvertFuel_xi_waf "Convert fuel's elementary composition from version <= 1.2.2 to version 1.3.0 and above"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Media.Fuel.PartialFuel fuelType = ClaRa.Basics.Media.Fuel.Coal_v1() "Old fuel definition" annotation(choicesAllMatching);
  input ClaRa.Basics.Units.MassFraction xi[:] "";

  output ClaRa.Basics.Units.EnthalpyMassSpecific xi_waf[4];

algorithm
  xi_waf := xi[1:4]/sum(xi[1:fuelType.nc-2]);
end ConvertFuel_xi_waf;
