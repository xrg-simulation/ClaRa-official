within ClaRa.Components.TurboMachines.Fundamentals;
record IComPump_L2
  extends IComPump_L1;

  TILMedia.VLEFluidObjectFunctions.VLEFluidPointer fluidPointer_bulk "Pointer to bulk gas object" annotation(Dialog(tab="Bulk"));
  SI.EnthalpyMassSpecific h_bulk "Inlet enthalpy" annotation(Dialog(tab="Bulk"));
  SI.MassFraction xi_bulk[medium.nc - 1] "Inlet medium composition" annotation(Dialog(tab="Bulk"));
  SI.Mass mass "||Mass of system|";
end IComPump_L2;
