within ClaRa.Basics.Records;
model FluidVLE_L2 "A record for basic VLE fluid data from L2-type models"
  extends Icons.RecordIcon;
  parameter Boolean showExpertSummary= false;

  input Units.Mass mass "System mass" annotation (Dialog(show));
  input Units.Temperature T "System temperature" annotation (Dialog);
  input Units.Temperature T_sat if showExpertSummary "System saturation temperature" annotation (Dialog);
  input Units.Pressure p "System pressure" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h "System specific enthalpy" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h_bub if showExpertSummary "Bubble specific enthalpy" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h_dew if showExpertSummary "Dew specific enthalpy" annotation (Dialog(show));
  input Units.EntropyMassSpecific s if showExpertSummary "System specific entropy" annotation (Dialog);
  input Units.MassFraction steamQuality if showExpertSummary "Steam quality" annotation (Dialog);
  input Modelica.SIunits.Enthalpy H if showExpertSummary "System enthalpy" annotation(Dialog(show));
  input Units.DensityMassSpecific rho if showExpertSummary "Density" annotation (Dialog);
end FluidVLE_L2;
