within ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics;
partial model BaseEnergetics
  extends ClaRa.Basics.Icons.Efficiency;

  outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

  ClaRa.Basics.Units.Power P_loss "Power transferred to fluid";
  ClaRa.Basics.Units.Torque tau_loss "Loss torque";
  ClaRa.Basics.Units.Efficiency eta "Total efficiency";
  ClaRa.Basics.Units.Torque tau_fluid "Current fluid torque";
  ClaRa.Basics.Units.Power P_fluid "Current fluid power";
  ClaRa.Basics.Units.Power P_iso "Isentropic power";
end BaseEnergetics;
