within ClaRa_Obsolete.Basics.Functions;
function ConvertFuel_LHV "Convert fuel's LHV from version <= 1.2.2 to version 1.3.0 and above"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Media.Fuel.PartialFuel fuelType = ClaRa.Basics.Media.Fuel.Coal_v1() "Old fuel definition" annotation(choicesAllMatching);
  input ClaRa.Basics.Units.EnthalpyMassSpecific LHV_set "";
  input ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_evap=2500e3 "";
  input ClaRa.Basics.Units.MassFraction xi[:] "";

  output ClaRa.Basics.Units.EnthalpyMassSpecific LHV_waf;

protected
  constant ClaRa.Basics.Units.EnthalpyMassSpecific C_LHV_w = -Delta_h_evap;

algorithm
  LHV_waf :=(LHV_set - (1 - sum(xi))*C_LHV_w)/sum(xi[1:fuelType.nc - 2]);
end ConvertFuel_LHV;
