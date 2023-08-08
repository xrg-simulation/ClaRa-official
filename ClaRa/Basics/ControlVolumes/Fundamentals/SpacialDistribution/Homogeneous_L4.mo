within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model Homogeneous_L4 "Both phases are in mechanical equilibrium"
    extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4;

  import TILMedia.VLEFluidObjectFunctions.density_phxi;

  Units.DensityMassSpecific rho_mix[geo.N_cv] "Mixture density";
  Real S[geo.N_cv] "Slip between phases";
  Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start) "Slip model enthalpy";
  Units.Velocity w_gu[iCom.N_cv] "Mean drift velocity";

equation
      for i in 1:geo.N_cv loop
    rho_mix[i]=density_phxi(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
      S[i]=1;
      h[i]=iCom.h[i];
      w_gu[i]=0;
    end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Homogeneous_L4;
