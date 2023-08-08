within ClaRa.Basics.Media.FuelTypes;
record Fuel_refvalues_v2 "{fuel_waf, ash, h2o } |  former 'Coal_v2'  | C,H,O,N,S,Ash,H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    final N_c=3,
    N_e=7,
    C_LHV={33263506.063947078,0,-2500e3},
    C_rho={500,7000,1000},
    C_cp={1067.34,1000,4190},
    waterIndex=3,
    ashIndex=2,
    defaultComposition={0.907,0.025},
    xi_e_waf={{0.8070562293274531,0.05512679162072767,0.05512679162072767,0.05512679162072767}},
    T_ref=273.15);
end Fuel_refvalues_v2;
