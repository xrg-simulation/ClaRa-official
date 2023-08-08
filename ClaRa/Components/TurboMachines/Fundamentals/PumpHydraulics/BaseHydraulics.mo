within ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics;
model BaseHydraulics
  extends ClaRa.Basics.Icons.Characteristics;

//   parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_zerohead "Volume flow where Delta_p/head = 0" annotation(Dialog(group="Characteristic Field"));
//   parameter ClaRa.Basics.Units.PressureDifference Delta_p_zeroflow "Pressure difference at flow= 0" annotation(Dialog(group="Characteristic Field"));

  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate";

  outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end BaseHydraulics;
