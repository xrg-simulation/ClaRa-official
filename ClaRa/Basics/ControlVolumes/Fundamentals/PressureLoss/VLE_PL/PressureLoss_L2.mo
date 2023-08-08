within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
partial model PressureLoss_L2
   outer ClaRa.Basics.Records.IComVLE_L2 iCom;
   outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
   extends ClaRa.Basics.Icons.Delta_p;
  SI.Pressure Delta_p(start=0);
  outer parameter Boolean useHomotopy;

end PressureLoss_L2;
