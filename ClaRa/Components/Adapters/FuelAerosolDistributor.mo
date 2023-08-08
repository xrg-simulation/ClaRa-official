within ClaRa.Components.Adapters;
model FuelAerosolDistributor "fuel2aerosol-interface, defines particle diameter classes and mass fractions of aerosol flow"

  extends ClaRa.Basics.Icons.Adapter2_fw;

  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification=ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_geo02() annotation (Dialog(group="Fundamental Medium Definitions"), choicesAllMatching=true);
  parameter ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1]=((1/classification.N_class)*ones(classification.N_class-1)) "Particle class mass fraction" annotation(Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.FuelOutletDistr outlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.Fuel_inlet inlet(fuelModel = fuelModel) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));

equation
  outlet.p = inlet.p;
  outlet.m_flow = -inlet.m_flow;

  outlet.classFraction_outflow = classFraction;
  outlet.T_outflow = inStream(inlet.T_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  inlet.xi_outflow = inStream(outlet.xi_outflow);
  inlet.T_outflow = inStream(outlet.T_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelAerosolDistributor;
