within ClaRa.Components.TurboMachines.Fundamentals;
record IComPump_L2
  extends IComPump_L1;

  TILMedia.VLEFluidObjectFunctions.VLEFluidPointerExternalObject fluidPointer_bulk "Pointer to bulk gas object" annotation(Dialog(tab="Bulk"));
  Basics.Units.EnthalpyMassSpecific h_bulk "Inlet enthalpy" annotation (Dialog(tab="Bulk"));
  Basics.Units.MassFraction xi_bulk[medium.nc - 1] "Inlet medium composition" annotation (Dialog(tab="Bulk"));
  Basics.Units.Mass mass "||Mass of system|";
end IComPump_L2;
