within ClaRa.Basics.Media.FuelTypes;
record Fuel_v3 "Fuel1, Fuel2, ash, H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    N_c=4,
    N_e=7,
    C_LHV={30e3,10e6,0,-2500e3},
    C_rho={500,500,7000,1000},
    C_cp={1266.67,1266.67,1000,4190},
    waterIndex=4,
    ashIndex=3,
    defaultComposition={0.7,0.2,0.08},
    xi_e_waf=[0.7,0.1,0,0.05; 0.5,0.1,0,0.4],
    T_ref=273.15);
end Fuel_v3;
