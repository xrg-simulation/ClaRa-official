within ClaRa.Basics.Records;
record IComGas_L2 "Basic internal communication record for heat transfer"
  extends ClaRa.Basics.Records.IComBase_L2;

//____Variables for system description__________________________________________________
  TILMedia.GasObjectFunctions.GasPointer fluidPointer_bulk "Pointer to bulk gas object"     annotation(Dialog(tab="System"));
  replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="System"));

//____Inlet_____________________________________________________________________________
  TILMedia.GasObjectFunctions.GasPointer fluidPointer_in "Pointer to inlet gas object"     annotation(Dialog(tab="Inlet"));
  SI.VolumeFlowRate V_flow_in "Inlet  volume flow" annotation(Dialog(tab="Inlet"));
  SI.MassFraction xi_in[mediumModel.nc - 1] "Inlet medium composition" annotation(Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  TILMedia.GasObjectFunctions.GasPointer fluidPointer_out "Pointer to outlet gas object"     annotation(Dialog(tab="Outlet"));
  SI.VolumeFlowRate V_flow_out "Outlet volume flow" annotation(Dialog(tab="Outlet"));
  SI.MassFraction xi_out[mediumModel.nc - 1] "Outlet medium composition"  annotation(Dialog(tab="Outlet"));

  annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComGas_L2;
