within TILMedia.VLEFluidTypes;
record TILMedia_InterpolatedWater
  "Water, IAPWS1995, Linear Interpolation, table based calculation (TLK Implementation)"
  extends TILMedia.VLEFluidTypes.BaseVLEFluid(
    final fixedMixingRatio=true,
    final nc_propertyCalculation=1,
    final vleFluidNames={""},
    final mixingRatio_propertyCalculation={1},
    final concatVLEFluidName="Interpolation.LoadLinear(filename=\"" +
        Modelica.Utilities.Files.loadResource(
        "Modelica://TILMedia/Resources/WATER.DAT") + "\")");
//    final concatVLEFluidName="Interpolation.LoadLinear(filename=WATER.DAT)");
end TILMedia_InterpolatedWater;
