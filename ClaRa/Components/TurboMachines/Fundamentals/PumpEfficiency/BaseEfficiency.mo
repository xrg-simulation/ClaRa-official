within ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency;
model BaseEfficiency
  extends Basics.Icons.Efficiency;

  outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

  Basics.Units.Power P_loss "Power transferred to fluid";
  Basics.Units.Torque tau_loss "Loss torque";
  Basics.Units.Efficiency eta "Total efficiency";
end BaseEfficiency;
