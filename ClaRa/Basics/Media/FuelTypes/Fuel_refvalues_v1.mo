within ClaRa.Basics.Media.FuelTypes;
record Fuel_refvalues_v1 "{fuel_waf, ash, h2o } |  former 'Coal_v1'  | C,H,O,N,S,Ash,H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    N_c=3,
    N_e=7,
    C_LHV={30769230.769230768,0,-2500e3},
    C_rho={500,7000,1000},
    C_cp={1266.67,1000,4190},
    waterIndex=3,
    ashIndex=2,
    defaultComposition={0.975,0.025},
    xi_e_waf={{0.8205128205128206,0.05128205128205129,0.05128205128205129,0.05128205128205129}},
    T_ref=273.15);
end Fuel_refvalues_v1;
