within ClaRa.Basics.Records;
record IComFuel_L2 "Basic internal communication record for heat transfer"
  extends ClaRa.Basics.Records.IComBase_L2;

//____Variables for system description__________________________________________________
 parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel = ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1()  "Fuel type";
//____Inlet____________________________________________________________________________
  Units.MassFraction xi_c_in[fuelModel.N_c - 1] "Inlet medium composition" annotation (Dialog(tab="Inlet"));
  Units.MassFraction xi_e_in[fuelModel.N_e - 1] "Inlet elemental composition" annotation (Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  Units.MassFraction xi_c_out[fuelModel.N_c - 1] "Outlet medium composition" annotation (Dialog(tab="Outlet"));
  Units.MassFraction xi_e_out[fuelModel.N_e - 1] "Outlet medium composition" annotation (Dialog(tab="Outlet"));

  annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComFuel_L2;
