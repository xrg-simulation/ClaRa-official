within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
partial model PressureLoss_L2
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L2;
  extends ClaRa.Basics.Icons.Delta_p;
  SI.Pressure Delta_p(start=0);
  outer parameter Boolean useHomotopy;

  annotation (Icon(graphics));

end PressureLoss_L2;
