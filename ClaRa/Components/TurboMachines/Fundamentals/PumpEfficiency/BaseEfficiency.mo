within ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency;
model BaseEfficiency
  extends Basics.Icons.Efficiency;

  outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

  SI.Power P_loss "Power transferred to fluid";
  SI.Torque tau_loss "Loss torque";
  SI.Efficiency eta "Total efficiency";
end BaseEfficiency;
