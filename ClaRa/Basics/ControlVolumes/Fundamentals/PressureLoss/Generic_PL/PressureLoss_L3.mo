within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model PressureLoss_L3 "Generic pressure loss models for type L3 models"

  extends ClaRa.Basics.Icons.Delta_p;
  parameter Boolean hasPressureLoss;
  outer ClaRa.Basics.Records.IComBase_L3 iCom;
  ClaRa.Basics.Units.PressureDifference Delta_p[iCom.N_inlet](start=ones(iCom.N_inlet)) "Pressure difference du to friction";

end PressureLoss_L3;
