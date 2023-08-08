within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model SimpleAnalyticalSlip_L4 "Simple slip correlation according to Zivi"
    extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4;
  import TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi;
  import TILMedia.VLEFluidObjectFunctions.vapourDensity_phxi;
  import TILMedia.VLEFluidObjectFunctions.liquidDensity_phxi;
  import TILMedia.VLEFluidObjectFunctions.density_phxi;
  import TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi;

  Basics.Units.DensityMassSpecific rho[geo.N_cv] "Mixed cup density";
  Basics.Units.DensityMassSpecific rho_mix[geo.N_cv] "In-situ density";
  Basics.Units.VolumeFraction yps[geo.N_cv] "Void fraction";
  Real S[geo.N_cv] "Slip between phases";
  Basics.Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start) "Slip model enthalpy";

    TILMedia.VLEFluidObjectFunctions.VLEFluidPointer ptr_slip[iCom.N_cv]={TILMedia.VLEFluidObjectFunctions.VLEFluidPointer(
      iCom.mediumModel.concatVLEFluidName,
      7,
      iCom.mediumModel.mixingRatio_propertyCalculation[1:end - 1]/sum(iCom.mediumModel.mixingRatio_propertyCalculation),
      iCom.mediumModel.nc_propertyCalculation,
      iCom.mediumModel.nc,
      TILMedia.Internals.redirectModelicaFormatMessage()) for i in 1:iCom.N_cv};

  Basics.Units.DensityMassSpecific rho_vap[iCom.N_cv] "Density of vapour";
  Basics.Units.DensityMassSpecific rho_liq[iCom.N_cv] "Density of liquid";
  Basics.Units.EnthalpyMassSpecific h_liq[geo.N_cv] "Liquid specific enthalpy";
  Basics.Units.EnthalpyMassSpecific h_vap[geo.N_cv] "Vapour specific enthalpy";
  Real steamQuality[iCom.N_cv] "Steam quality";
  Basics.Units.Velocity w_gu[iCom.N_cv] "Mean drift velocity";

equation
    /////// Calculate Media Required Data  ///////////////////
  for i in 1:iCom.N_cv loop
    steamQuality[i] =steamMassFraction_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i]);

    rho_vap[i] = vapourDensity_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i]);

    rho_liq[i] = liquidDensity_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i]);

    h_vap[i] = dewSpecificEnthalpy_pxi(iCom.p[i],iCom.xi[i, :], ptr_slip[i]);

    h_liq[i] = bubbleSpecificEnthalpy_pxi(iCom.p[i],iCom.xi[i, :], ptr_slip[i]);

    rho[i] = density_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i]);

  end for;
  for i in 1:iCom.N_cv loop
      rho_mix[i]=(min(rho_vap[i],rho[i])*yps[i]+max(rho_liq[i],rho[i])*(1-yps[i]));
      yps[i]=(1+rho_vap[i]/rho_liq[i]*(1-steamQuality[i])/max(steamQuality[i],Modelica.Constants.eps)*S[i])^(-1);
      S[i]=(rho_vap[i]/rho_liq[i])^(-1/3);
      iCom.h[i]=(max(rho_liq[i],rho[i])*min(h_liq[i],h[i])*(1-yps[i])+min(rho_vap[i],rho[i])*max(h_vap[i],h[i])*yps[i])/rho_mix[i];
      w_gu[i]=0;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SimpleAnalyticalSlip_L4;
