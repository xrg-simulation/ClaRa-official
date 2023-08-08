﻿within TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible;
model VLEFluid_dT
  "Compressible fluid model with d, T and xi as independent variables"
  extends .TILMedia.BaseClasses.PartialVLEFluid_dT(vleFluidPointer=
        .TILMedia.Internals.TILMediaExternalObject(
        "VLEFluid",
        vleFluidType.concatVLEFluidName,
        computeFlags,
        vleFluidType.mixingRatio_propertyCalculation[1:end - 1]/sum(
          vleFluidType.mixingRatio_propertyCalculation),
        vleFluidType.nc,
        0,
        getInstanceName()),
        M_i = {.TILMedia.VLEFluidObjectFunctions.molarMass_n(i-1,vleFluidPointer) for i in 1:vleFluidType.nc});
protected
  constant Real invalidValue=-1;
  final parameter Integer computeFlags=.TILMedia.Internals.calcComputeFlags(
      computeTransportProperties,
      interpolateTransportProperties,
      computeSurfaceTension,
      deactivateTwoPhaseRegion,
      deactivateDensityDerivatives);

equation
  (crit.d,crit.h,crit.p,crit.s,crit.T) =
    .TILMedia.Internals.VLEFluidObjectFunctions.cricondentherm_xi(xi,
    vleFluidPointer);
  //calculate molar mass
  M = 1/sum(cat(
    1,
    xi,
    {1 - sum(xi)}) ./ M_i);
  //calculate mole fraction
  xi = x .* M_i[1:end - 1]*(sum(cat(
    1,
    xi,
    {1 - sum(xi)}) ./ M_i));
  //xi = x.*M_i/M

  //Calculate Main Properties of state
  h =
    .TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_dTxi(
    d,
    T,
    xi,
    vleFluidPointer);
  p =
    .TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.pressure_dTxi(
    d,
    T,
    xi,
    vleFluidPointer);
  s =
    .TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEntropy_dTxi(
    d,
    T,
    xi,
    vleFluidPointer);

  //Calculate Additional Properties of state
  (q,cp,cv,beta,kappa,drhodp_hxi,drhodh_pxi,drhodxi_ph,w,gamma) =
    .TILMedia.Internals.VLEFluidObjectFunctions.additionalProperties_dTxi(
    d,
    T,
    xi,
    vleFluidPointer);

  //Calculate VLE Properties
  if (vleFluidType.nc == 1) then
    //VLE only depends on p or T
    (VLE.d_l,VLE.h_l,VLE.p_l,VLE.s_l,VLE.T_l,VLE.xi_l,VLE.d_v,VLE.h_v,VLE.p_v,
      VLE.s_v,VLE.T_v,VLE.xi_v) =
      .TILMedia.Internals.VLEFluidObjectFunctions.VLEProperties_dTxi(
      -1,
      T,
      zeros(0),
      vleFluidPointer);
  else
    //VLE of a mixture also depends on density/enthalpy/entropy/temperature
    (VLE.d_l,VLE.h_l,VLE.p_l,VLE.s_l,VLE.T_l,VLE.xi_l,VLE.d_v,VLE.h_v,VLE.p_v,
      VLE.s_v,VLE.T_v,VLE.xi_v) =
      .TILMedia.Internals.VLEFluidObjectFunctions.VLEProperties_dTxi(
      d,
      T,
      xi,
      vleFluidPointer);
  end if;

  //Calculate Transport Properties
  if computeTransportProperties then
    (transp.Pr,
  transp.lambda,
  transp.eta,
  transp.sigma) =
      .TILMedia.Internals.VLEFluidObjectFunctions.transportPropertyRecord_dTxi(
      d,
      T,
      xi,
      vleFluidPointer);
  else
    transp = .TILMedia.Internals.TransportPropertyRecord(
      invalidValue,
      invalidValue,
      invalidValue,
      invalidValue);
  end if;

  //compute VLE Additional Properties
  if computeVLEAdditionalProperties then
    if (vleFluidType.nc == 1) then
      //VLE only depends on p or T
      (VLEAdditional.cp_l,VLEAdditional.beta_l,VLEAdditional.kappa_l,
        VLEAdditional.cp_v,VLEAdditional.beta_v,VLEAdditional.kappa_v) =
        .TILMedia.Internals.VLEFluidObjectFunctions.VLEAdditionalProperties_dTxi(
        -1,
        T,
        zeros(vleFluidType.nc - 1),
        vleFluidPointer);
    else
      //VLE of a mixture also depends on density/enthalpy/entropy/temperature
      (VLEAdditional.cp_l,VLEAdditional.beta_l,VLEAdditional.kappa_l,
        VLEAdditional.cp_v,VLEAdditional.beta_v,VLEAdditional.kappa_v) =
        .TILMedia.Internals.VLEFluidObjectFunctions.VLEAdditionalProperties_dTxi(
        d,
        T,
        xi,
        vleFluidPointer);
    end if;
  else
    VLEAdditional.cp_l = invalidValue;
    VLEAdditional.beta_l = invalidValue;
    VLEAdditional.kappa_l = invalidValue;
    VLEAdditional.cp_v = invalidValue;
    VLEAdditional.beta_v = invalidValue;
    VLEAdditional.kappa_v = invalidValue;
  end if;

  //compute VLE Transport Properties
  if computeVLETransportProperties then
    if (vleFluidType.nc == 1) then
      //VLE only depends on p or T
      (VLETransp.Pr_l,VLETransp.Pr_v,VLETransp.lambda_l,VLETransp.lambda_v,
        VLETransp.eta_l,VLETransp.eta_v) =
        .TILMedia.Internals.VLEFluidObjectFunctions.VLETransportPropertyRecord_dTxi(
        -1,
        T,
        zeros(0),
        vleFluidPointer);
    else
      //VLE of a mixture also depends on density/enthalpy/entropy/temperature
      (VLETransp.Pr_l,VLETransp.Pr_v,VLETransp.lambda_l,VLETransp.lambda_v,
        VLETransp.eta_l,VLETransp.eta_v) =
        .TILMedia.Internals.VLEFluidObjectFunctions.VLETransportPropertyRecord_dTxi(
        d,
        T,
        xi,
        vleFluidPointer);
    end if;
  else
    VLETransp.Pr_l = invalidValue;
    VLETransp.Pr_v = invalidValue;
    VLETransp.lambda_l = invalidValue;
    VLETransp.lambda_v = invalidValue;
    VLETransp.eta_l = invalidValue;
    VLETransp.eta_v = invalidValue;
  end if;

  annotation (
    defaultComponentName="vleFluid",
    Protection(access=Access.packageDuplicate),
    Documentation(info="<html>
                   <p>
                   The VLE-fluid model VLEFluid_dT calculates the thermopyhsical property data with given inputs: density (d), temperature (T), mass fraction (xi) and the parameter vleFluidType.<br>
                   The interface and the way of using, is demonstrated in the Testers -> <a href=\"modelica://TILMedia.Testers.TestVLEFluid\">TestVLEFluid</a>.
                   </p>
                   <hr>
                   </html>"));
end VLEFluid_dT;
