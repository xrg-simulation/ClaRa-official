within ClaRa.Basics.Records;
model FlangeVLE "A summary of flange flow properties"
  extends Icons.RecordIcon;

  parameter Boolean showExpertSummary= false;
  input Units.MassFlowRate m_flow "Mass flow rate" annotation(Dialog);
  input Units.Temperature T "Temperature" annotation(Dialog);
  input Units.Pressure p "Pressure" annotation(Dialog);
  input Units.EnthalpyMassSpecific h "Specific enthalpy" annotation(Dialog);
  input Units.EntropyMassSpecific s if  showExpertSummary "Specific entropy"
                                                                            annotation(Dialog);
  input Units.MassFraction steamQuality if showExpertSummary "Steam quality" annotation(Dialog);
  input Units.Power H_flow if showExpertSummary "Enthalpy flow rate" annotation(Dialog);
  input Units.DensityMassSpecific rho if showExpertSummary "Density" annotation(Dialog);

end FlangeVLE;
