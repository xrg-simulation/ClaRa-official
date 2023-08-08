within ClaRa.Basics.Records;
model FluidVLE_L34 "A record for basic VLE fluid data from L3 and L4-type models"
  extends Icons.RecordIcon;
  parameter Boolean showExpertSummary= false;
  parameter Integer N_cv "Number of zones or nodes";
  input Units.Mass mass[N_cv] "System mass" annotation(Dialog(show));
  input Units.Temperature T[N_cv] "System temperature" annotation(Dialog);
  input Units.Temperature T_sat[N_cv] if showExpertSummary "System saturation temperature"  annotation(Dialog);
  input Units.Pressure p[N_cv] "System pressure" annotation(Dialog(show));
  input Units.EnthalpyMassSpecific h[N_cv] "System specific enthalpy" annotation(Dialog(show));
  input Units.EnthalpyMassSpecific h_bub[N_cv] if showExpertSummary "Bubble specific enthalpy"  annotation(Dialog(show));
  input Units.EnthalpyMassSpecific h_dew[N_cv] if showExpertSummary "Dew specific enthalpy" annotation(Dialog(show));
  input Units.EntropyMassSpecific s[N_cv] if showExpertSummary "System specific entropy"  annotation(Dialog);
  input Units.MassFraction steamQuality[N_cv] if showExpertSummary annotation(Dialog);
  input Modelica.SIunits.Enthalpy H[N_cv] if showExpertSummary "System enthalpy"    annotation(Dialog(show));
  input Units.DensityMassSpecific rho[N_cv] if showExpertSummary annotation(Dialog);
end FluidVLE_L34;
