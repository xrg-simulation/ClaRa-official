within ClaRa.Components.Adapters;
model AerosolFuelConcentrator "aerosol2fuel-interface, concentrates aerosol flow with particle size distribution and particle mass fractions back to standard fuel mass flow"

  extends ClaRa.Basics.Icons.Adapter2_bw;

  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification=ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_geo02() annotation (Dialog(group="Fundamental Medium Definitions"), choicesAllMatching=true);
  parameter ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1]=zeros(classification.N_class-1) "Particle class mass fraction" annotation(Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.FuelInletDistr inlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.Fuel_outlet outlet(fuelModel = fuelModel) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  outlet.p = inlet.p;
  outlet.m_flow = -inlet.m_flow;

  inlet.classFraction_outflow = classFraction;

  outlet.T_outflow = inStream(inlet.T_outflow);
  inlet.T_outflow = inStream(outlet.T_outflow);

  outlet.xi_outflow = inStream(inlet.xi_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end AerosolFuelConcentrator;
