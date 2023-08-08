within TILMedia.Internals.GasConfigurations.AnalyticDerivatives;
package GasObjectFunctions
  extends TILMedia.GasObjectFunctions;

  redeclare replaceable function density_phxi = TILMedia.Internals.GasObjectFunctions.density_phxi;
  redeclare replaceable function specificEntropy_phxi = TILMedia.Internals.GasObjectFunctions.specificEntropy_phxi;
  redeclare replaceable function temperature_phxi = TILMedia.Internals.GasObjectFunctions.temperature_phxi;
  redeclare replaceable function specificIsobaricHeatCapacity_phxi =
      TILMedia.Internals.GasObjectFunctions.specificIsobaricHeatCapacity_phxi;
  redeclare replaceable function speedOfSound_phxi = TILMedia.Internals.GasObjectFunctions.speedOfSound_phxi;
  redeclare replaceable function specificIsochoricHeatCapacity_phxi =
      TILMedia.Internals.GasObjectFunctions.specificIsochoricHeatCapacity_phxi;
  redeclare replaceable function densityDerivativeWRTspecificEnthalpy_phxi =
      TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTspecificEnthalpy_phxi;
  redeclare replaceable function densityDerivativeWRTpressure_phxi =
      TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTpressure_phxi;
  redeclare replaceable function densityDerivativeWRTmassFraction_phxin =
      TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTmassFraction_phxin;
  redeclare replaceable function relativeHumidity_phxi = TILMedia.Internals.GasObjectFunctions.relativeHumidity_phxi;
  redeclare replaceable function saturationHumidityRatio_phxi =
      TILMedia.Internals.GasObjectFunctions.saturationHumidityRatio_phxi;

  redeclare replaceable function specificEnthalpy_psxi = TILMedia.Internals.GasObjectFunctions.specificEnthalpy_psxi;
  redeclare replaceable function temperature_psxi = TILMedia.Internals.GasObjectFunctions.temperature_psxi;

  redeclare replaceable function density_pTxi = TILMedia.Internals.GasObjectFunctions.density_pTxi;
  redeclare replaceable function specificEnthalpy_pTxi = TILMedia.Internals.GasObjectFunctions.specificEnthalpy_pTxi;
  redeclare replaceable function specificEntropy_pTxi = TILMedia.Internals.GasObjectFunctions.specificEntropy_pTxi;
  redeclare replaceable function specificIsobaricHeatCapacity_pTxi =
      TILMedia.Internals.GasObjectFunctions.specificIsobaricHeatCapacity_pTxi;
  redeclare replaceable function specificIsochoricHeatCapacity_pTxi =
      TILMedia.Internals.GasObjectFunctions.specificIsochoricHeatCapacity_pTxi;
  redeclare replaceable function speedOfSound_pTxi = TILMedia.Internals.GasObjectFunctions.speedOfSound_pTxi;
  redeclare replaceable function relativeHumidity_pTxi = TILMedia.Internals.GasObjectFunctions.relativeHumidity_pTxi;
  redeclare replaceable function saturationHumidityRatio_pTxi =
      TILMedia.Internals.GasObjectFunctions.saturationHumidityRatio_pTxi;
  redeclare replaceable function prandtlNumber_pTxi = TILMedia.Internals.GasObjectFunctions.prandtlNumber_pTxi;
  redeclare replaceable function thermalConductivity_pTxi =
      TILMedia.Internals.GasObjectFunctions.thermalConductivity_pTxi;
  redeclare replaceable function dynamicViscosity_pTxi = TILMedia.Internals.GasObjectFunctions.dynamicViscosity_pTxi;

  redeclare replaceable function saturationPartialPressure_T =
      TILMedia.Internals.GasObjectFunctions.saturationPartialPressure_T;
  redeclare replaceable function specificEnthalpyOfVaporisation_T =
      TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfVaporisation_T;
  redeclare replaceable function specificEnthalpyOfDesublimation_T =
      TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfDesublimation_T;
  redeclare replaceable function specificEnthalpyOfPureGas_Tn =
      TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfPureGas_Tn;

  redeclare replaceable function saturationMassFraction_pTxidg =
      TILMedia.Internals.GasObjectFunctions.saturationMassFraction_pTxidg;

  redeclare replaceable function humidityRatio_xi = TILMedia.Internals.GasObjectFunctions.humidityRatio_xi;

end GasObjectFunctions;
