within ClaRa.Basics.Records;
model StaCyFlangeFuel "A summary record for fuel flanges"
    extends ClaRa.Basics.Icons.RecordIcon;
  replaceable parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel "Used medium model" annotation (Dialog(tab="System"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value" annotation (Dialog);

  parameter ClaRa.Basics.Units.MassFraction xi[fuelModel.N_c - 1] "Medium composition" annotation (Dialog);
end StaCyFlangeFuel;
