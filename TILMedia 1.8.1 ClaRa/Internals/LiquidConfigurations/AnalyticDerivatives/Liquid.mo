within TILMedia.Internals.LiquidConfigurations.AnalyticDerivatives;
model Liquid "Incompressible liquid model for object and member function based evaluation"
  extends TILMedia.BaseClasses.PartialLiquid(
    liquidPointer=TILMedia.Internals.TILMediaExternalObject(
        "Liquid",
        liquidType.concatLiquidName,
        TILMedia.Internals.calcComputeFlags(
          computeTransportProperties,
          false,
          true,
          false,
          false),
        liquidType.mixingRatio_propertyCalculation[1:end - 1]/sum(liquidType.mixingRatio_propertyCalculation),
        liquidType.nc,
        0,
        getInstanceName()),
  redeclare replaceable function s_phxi =
      TILMedia.LiquidObjectFunctions.specificEntropy_phxi,
  redeclare replaceable function s_pTxi =
      TILMedia.Internals.LiquidObjectFunctions.specificEntropy_pTxi,
  redeclare replaceable function d_Txi =
      TILMedia.Internals.LiquidObjectFunctions.density_Txi,
  redeclare replaceable function h_Txi =
      TILMedia.Internals.LiquidObjectFunctions.specificEnthalpy_Txi,
  redeclare replaceable function cp_Txi =
      TILMedia.Internals.LiquidObjectFunctions.specificIsobaricHeatCapacity_Txi,
  redeclare replaceable function beta_Txi =
      TILMedia.Internals.LiquidObjectFunctions.isobaricThermalExpansionCoefficient_Txi,
  redeclare replaceable function Pr_Txi =
      TILMedia.Internals.LiquidObjectFunctions.prandtlNumber_Txi,
  redeclare replaceable function lambda_Txi =
      TILMedia.Internals.LiquidObjectFunctions.thermalConductivity_Txi,
  redeclare replaceable function eta_Txi =
      TILMedia.Internals.LiquidObjectFunctions.dynamicViscosity_Txi,
  redeclare replaceable function d_hxi =
      TILMedia.Internals.LiquidObjectFunctions.density_hxi,
  redeclare replaceable function T_hxi =
      TILMedia.Internals.LiquidObjectFunctions.temperature_hxi,
  redeclare replaceable function cp_hxi =
      TILMedia.Internals.LiquidObjectFunctions.specificIsobaricHeatCapacity_hxi,
  redeclare replaceable function beta_hxi =
      TILMedia.Internals.LiquidObjectFunctions.isobaricThermalExpansionCoefficient_hxi,
  redeclare replaceable function Pr_hxi =
      TILMedia.Internals.LiquidObjectFunctions.prandtlNumber_hxi,
  redeclare replaceable function lambda_hxi =
      TILMedia.Internals.LiquidObjectFunctions.thermalConductivity_hxi,
  redeclare replaceable function eta_hxi =
      TILMedia.Internals.LiquidObjectFunctions.dynamicViscosity_hxi);

  annotation (defaultComponentName="liquid", Protection(access=Access.packageDuplicate));
end Liquid;
