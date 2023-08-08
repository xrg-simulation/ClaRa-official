within ClaRa.Basics.Records;
record IComGas_L3
  extends IComBase_L3;

  replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="General"));
  TILMedia.GasObjectFunctions.GasPointerExternalObject fluidPointer_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  TILMedia.GasObjectFunctions.GasPointerExternalObject fluidPointer_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";
  ClaRa.Basics.Units.EnthalpyMassSpecific h[N_cv] "|System||Specific enthalpy of liquid and vapour zone";
  Units.MassFraction xi[N_cv,mediumModel.nc - 1] "Medium composition" annotation (Dialog(tab="System"));
  TILMedia.GasObjectFunctions.GasPointerExternalObject fluidPointer[N_cv] "|Outlet||Fluid pointer of outlet ports";

  ClaRa.Basics.Units.Volume volume[N_cv] "|System||Volume of liquid and vapour zone";
  Units.EnthalpyMassSpecific h_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  Units.EnthalpyMassSpecific h_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";

  Units.MassFraction xi_in[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition";
  Units.MassFraction xi_out[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition";
end IComGas_L3;
