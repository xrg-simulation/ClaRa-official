within ClaRa.Basics.Records;
model StaCyFlangeVLE "A summary of flange flow properties for StaCy components"
  extends Icons.RecordIcon;

  parameter Units.MassFlowRate m_flow "Mass flow rate" annotation(Dialog);
  parameter Units.Pressure p "Pressure" annotation(Dialog);
  parameter Units.EnthalpyMassSpecific h "Specific enthalpy" annotation(Dialog);

end StaCyFlangeVLE;
