within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model NoFriction_L3 "All geo || L3 || No pressure loss"
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3(final hasPressureLoss=false);
  //   outer ClaRa.Basics.ControlVolumes.Fundamentals.ICom_L3                           iCom;
  //   ClaRa.Basics.Units.PressureDifference Delta_p[iCom.N_inlet]
  //     "Pressure difference du to friction";

equation
  Delta_p = zeros(iCom.N_inlet);

end NoFriction_L3;
