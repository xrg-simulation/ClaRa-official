within ClaRa.Basics.Records;
record IComFuel_L2 "Basic internal communication record for heat transfer"
  extends ClaRa.Basics.Records.IComBase_L2;

//____Variables for system description__________________________________________________
  replaceable package FuelType = ClaRa_Dev.Basics.Media.Coal_refvalues_LHV35  "Fuel type"  annotation(Dialog(tab="System"));

//____Inlet____________________________________________________________________________
  SI.MassFraction xi_c_in[FuelType.N_c - 1] "Inlet medium composition" annotation(Dialog(tab="Inlet"));
  SI.MassFraction xi_e_in[FuelType.N_e - 1] "Inlet elemental composition" annotation(Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  SI.MassFraction xi_c_out[FuelType.N_c - 1] "Outlet medium composition"  annotation(Dialog(tab="Outlet"));
  SI.MassFraction xi_e_out[FuelType.N_e - 1] "Outlet medium composition"  annotation(Dialog(tab="Outlet"));

  annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComFuel_L2;
