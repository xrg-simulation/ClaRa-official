within ClaRa.Basics.Records;
model StaCyFlangeGas "A summary record for gas flanges"
    extends ClaRa.Basics.Icons.RecordIcon;
    replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="System"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
  parameter ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
  parameter ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  parameter ClaRa.Basics.Units.MassFraction xi[mediumModel.nc - 1] "Medium composition" annotation (Dialog);
end StaCyFlangeGas;
