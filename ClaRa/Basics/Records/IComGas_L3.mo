within ClaRa.Basics.Records;
record IComGas_L3
  extends IComBase_L3;

  replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="General"));
  TILMedia.GasObjectFunctions.GasPointer fluidPointer_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  TILMedia.GasObjectFunctions.GasPointer fluidPointer_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";
  ClaRa.Basics.Units.EnthalpyMassSpecific h[N_cv] "|System||Specific enthalpy of liquid and vapour zone";
  SI.MassFraction xi[N_cv,mediumModel.nc - 1] "Medium composition" annotation(Dialog(tab="System"));
  TILMedia.GasObjectFunctions.GasPointer fluidPointer[N_cv] "|Outlet||Fluid pointer of outlet ports";

  ClaRa.Basics.Units.Volume volume[N_cv] "|System||Volume of liquid and vapour zone";
  SI.EnthalpyMassSpecific h_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  SI.EnthalpyMassSpecific h_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";

  SI.MassFraction xi_in[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition";
  SI.MassFraction xi_out[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition";
end IComGas_L3;
