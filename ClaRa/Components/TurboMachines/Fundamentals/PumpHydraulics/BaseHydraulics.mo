within ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics;
model BaseHydraulics
  extends ClaRa.Basics.Icons.Characteristics;

  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate";

  outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end BaseHydraulics;
