within ClaRa.Basics.Media.Ckeck;
model TestFuelObjectAndFuelDefinitions
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  inner SimCenter simCenter(redeclare FuelTypes.Fuel_verbandsformel_v3 fuelModel1)
                                                                                  annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  FuelObject fuelObject(
    p=1e5,
    T=300,
    xi_c=fuelObject.fuelModel.defaultComposition,
    fuelModel=simCenter.fuelModel1) annotation (Placement(transformation(extent={{-26,-12},{-6,8}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestFuelObjectAndFuelDefinitions;
