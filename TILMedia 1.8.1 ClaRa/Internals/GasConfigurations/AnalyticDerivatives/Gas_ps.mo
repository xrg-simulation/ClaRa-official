within TILMedia.Internals.GasConfigurations.AnalyticDerivatives;
model Gas_ps "Gas vapor model with p, s and xi as independent variables"
  extends TILMedia.BaseClasses.PartialGas_ps(gasPointer=TILMedia.Internals.TILMediaExternalObject(
        "Gas",
        gasType.concatGasName,
        computeFlags,
        gasType.mixingRatio_propertyCalculation[1:end - 1]/sum(gasType.mixingRatio_propertyCalculation),
        gasType.nc,
        gasType.condensingIndex,
        getInstanceName()), M_i={TILMedia.GasObjectFunctions.molarMass_n(i - 1, gasPointer) for i in 1:gasType.nc});
protected
  Real dummy_cp;
  Real dummy_cv;
  Real dummy_w;
  constant Real invalidValue=-1;
  final parameter Integer computeFlags=TILMedia.Internals.calcComputeFlags(
      computeTransportProperties,
      false,
      true,
      false,
      false);
equation
  //calculate molar mass
  M = 1/sum(cat(
    1,
    xi,
    {1 - sum(xi)}) ./ M_i);
  //calculate molar fraction
  xi = x .* M_i[1:end - 1]*(sum(cat(
    1,
    xi,
    {1 - sum(xi)}) ./ M_i));
  //xi = x.*M_i/M
  //calculate relative humidity, water content, h1px
  if (gasType.condensingIndex > 0 and gasType.nc > 1) then
    if (gasType.condensingIndex == gasType.nc) then
      cat(
        1,
        xi_dryGas,
        {1 - sum(xi_dryGas)}) = xi*(1 + humRatio);
    else
      humRatio = xi[gasType.condensingIndex]*(humRatio + 1);
      for i in 1:gasType.nc - 1 loop
        if (i <> gasType.condensingIndex) then
          xi_dryGas[if (i < gasType.condensingIndex) then i else i - 1] = xi[i]*(humRatio + 1);
        end if;
      end for;
    end if;
    h1px = h*(1 + humRatio);
    phi = TILMedia.Internals.GasObjectFunctions.relativeHumidity_pThumRatioxidg(
      p,
      T,
      humRatio,
      xi_dryGas,
      gasPointer);
    humRatio_s = TILMedia.Internals.GasObjectFunctions.saturationHumidityRatio_pTxidg(
      p,
      T,
      xi_dryGas,
      gasPointer);
    xi_s = TILMedia.Internals.GasObjectFunctions.saturationMassFraction_pTxidg(
      p,
      T,
      xi_dryGas,
      gasPointer);
  else
    phi = -1;
    humRatio = -1;
    h1px = -1;
    humRatio_s = -1;
    xi_s = -1;
  end if;

  if (gasType.condensingIndex <= 0) then
    // some properties are only pressure dependent if there is vapour in the mixture
    p_s = -1;
    delta_hv = -1;
    delta_hd = -1;
    h_i = {TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfPureGas_Tn(
      T,
      i,
      gasPointer) for i in 0:gasType.nc - 1};
  else
    p_s = TILMedia.Internals.GasObjectFunctions.saturationPartialPressure_T(T, gasPointer);
    delta_hv = TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfVaporisation_T(T, gasPointer);
    delta_hd = TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfDesublimation_T(T, gasPointer);
    h_i = {TILMedia.Internals.GasObjectFunctions.specificEnthalpyOfPureGas_Tn(
      T,
      i,
      gasPointer) for i in 0:gasType.nc - 1};
  end if;

  T = TILMedia.Internals.GasObjectFunctions.temperature_psxi(
    p,
    s,
    xi,
    gasPointer);
  h = TILMedia.Internals.GasObjectFunctions.specificEnthalpy_psxi(
    p,
    s,
    xi,
    gasPointer);

  (dummy_cp,dummy_cv,beta,dummy_w) = TILMedia.Internals.GasObjectFunctions.simpleCondensingProperties_pTxi(
    p,
    T,
    xi,
    gasPointer);
  cp = TILMedia.Internals.GasObjectFunctions.specificIsobaricHeatCapacity_phxi(
    p,
    h,
    xi,
    gasPointer);
  w = TILMedia.Internals.GasObjectFunctions.speedOfSound_phxi(
    p,
    h,
    xi,
    gasPointer);
  //   (cp, cv, beta, w) = TILMedia.Internals.GasObjectFunctions.simpleCondensingProperties_pTxi(p, T, xi, gasPointer);
  d = TILMedia.Internals.GasObjectFunctions.density_pTxi(
    p,
    T,
    xi,
    gasPointer);
  cv = TILMedia.Internals.GasObjectFunctions.specificIsochoricHeatCapacity_phxi(
    p,
    h,
    xi,
    gasPointer);

  drhodh_pxi = TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTspecificEnthalpy_phxi(
    p,
    h,
    xi,
    gasPointer);
  drhodp_hxi = TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTpressure_phxi(
    p,
    h,
    xi,
    gasPointer);
  drhodxi_ph = {TILMedia.Internals.GasObjectFunctions.densityDerivativeWRTmassFraction_phxin(
    p,
    h,
    xi,
    i,
    gasPointer) for i in 0:gasType.nc - 2};
  kappa = TILMedia.Internals.GasObjectFunctions.isothermalCompressibility_pTxi(
    p,
    T,
    xi,
    gasPointer);
  p_i = {TILMedia.Internals.GasObjectFunctions.partialPressure_pTxin(
    p,
    T,
    xi,
    i,
    gasPointer) for i in 0:gasType.nc - 1};
  xi_gas = TILMedia.Internals.GasObjectFunctions.gaseousMassFraction_pTxi(
    p,
    T,
    xi,
    gasPointer);
  //   (d,kappa,drhodp_hxi,drhodh_pxi,drhodxi_ph,p_i,xi_gas) = TILMedia.Internals.GasObjectFunctions.additionalProperties_pTxi(p,T,xi,gasPointer);
  if computeTransportProperties then
    (transp.Pr,transp.lambda,transp.eta,transp.sigma) = TILMedia.Internals.GasObjectFunctions.transportProperties_pTxi(
      p,
      T,
      xi,
      gasPointer);
  else
    transp = TILMedia.Internals.TransportPropertyRecord(
      -1,
      -1,
      -1,
      -1);
  end if;

  annotation (
    defaultComponentName="gas",
    Protection(access=Access.packageDuplicate),
    Documentation(info="<html>
                   <p>
                   The gas model Gas_ps calculates the thermopyhsical property data with given inputs: pressure (p), entropy (s), mass fraction (xi) and the parameter gasType.<br>
                   The interface and the way of using, is demonstrated in the Testers -&gt; <a href=\"modelica://TILMedia.Testers.TestGas\">TestGas</a>.
                   </p>
                   <hr>
                   </html>"));
end Gas_ps;
