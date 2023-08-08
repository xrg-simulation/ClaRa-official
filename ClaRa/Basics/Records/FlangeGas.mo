within ClaRa.Basics.Records;
model FlangeGas "A summary record for gas flanges"

    extends ClaRa.Basics.Icons.RecordIcon;
    replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="System"));
  input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
  input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
  input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy" annotation (Dialog);
  input ClaRa.Basics.Units.MassFraction xi[mediumModel.nc - 1] "Medium composition" annotation (Dialog);
  input ClaRa.Basics.Units.Power H_flow "Enthalpy flow rate" annotation (Dialog);

end FlangeGas;
