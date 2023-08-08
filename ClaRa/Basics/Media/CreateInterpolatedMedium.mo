within ClaRa.Basics.Media;
model CreateInterpolatedMedium
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph refrigerant(redeclare TILMedia.VLEFluidTypes.BaseVLEFluid
                                          vleFluidType(
      fixedMixingRatio=false,
      nc_propertyCalculation=1,
      mixingRatio_propertyCalculation={1},
      vleFluidNames={
          "Interpolation.createlinear(mediumname=TILMedia.WATER,p=[613:350e5:500],h=[50e3:4200e3:500],filename=Water.dat)"}),
      p=1e5,
      h=1e6,
      computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

 TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph refrigerant2(redeclare TILMedia.VLEFluidTypes.BaseVLEFluid
                                          vleFluidType(
      fixedMixingRatio=false,
      nc_propertyCalculation=1,
      mixingRatio_propertyCalculation={1},
      vleFluidNames={
          "Interpolation.createspline(mediumname=TILMedia.WATER,p=[613:350e5:200],h=[10e3:4200e3:200],nStepSat=300,filename=Water_Spline.dat)"}),
      p=1e5,
      h=1e6,
      computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  annotation (experiment(StopTime=1));
end CreateInterpolatedMedium;
