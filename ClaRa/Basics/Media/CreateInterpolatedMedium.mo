within ClaRa.Basics.Media;
model CreateInterpolatedMedium
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.7.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
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
