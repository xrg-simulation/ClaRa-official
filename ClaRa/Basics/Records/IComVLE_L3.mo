within ClaRa.Basics.Records;
record IComVLE_L3
  extends IComBase_L3;

  TILMedia.VLEFluidTypes.BaseVLEFluid mediumModel "Used medium model" annotation(Dialog(tab="General"));
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointerExternalObject fluidPointer_in[N_inlet] "|Inlet||Fluid pointer of inlet ports" annotation(Dialog(tab="General"));
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointerExternalObject fluidPointer_out[N_outlet] "|Outlet||Fluid pointer of outlet ports" annotation(Dialog(tab="General"));
  ClaRa.Basics.Units.EnthalpyMassSpecific h[N_cv] "|System||Specific enthalpy of liquid and vapour zone" annotation (Dialog(tab="General"));
  Units.MassFraction xi[N_cv,mediumModel.nc - 1] "Medium composition" annotation (Dialog(tab="System"));
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointerExternalObject fluidPointer[N_cv] "|System||Fluid pointer of outlet ports" annotation(Dialog(tab="System"));

  ClaRa.Basics.Units.Volume volume[N_cv] "|System||Volume of liquid and vapour zone" annotation (Dialog(tab="System"));
  Units.EnthalpyMassSpecific h_in[N_inlet] "|Inlet||Fluid pointer of inlet ports" annotation (Dialog(tab="Inlet"));
  Units.EnthalpyMassSpecific h_out[N_outlet] "|Outlet||Fluid pointer of outlet ports" annotation (Dialog(tab="Outlet"));

  Units.MassFraction xi_in[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition" annotation (Dialog(tab="Inlet"));
  Units.MassFraction xi_out[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition" annotation (Dialog(tab="Outlet"));
end IComVLE_L3;
