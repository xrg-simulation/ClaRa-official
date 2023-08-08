within ClaRa.Basics.Media.Fuel;
record CoalOilMixture "Coal, oil, ash, H2O"
extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
  N_c=4,
  N_e=7,
  C_LHV={33693432.49716375,39.5e6,0,-2500e3},
  C_rho={500,500,7000,1000},
  C_cp={1266.67, 1850, 1000, 4190},
  waterIndex=4,
  ashIndex=3,
  defaultComposition={0.7932999999999999, 0, 0.1151},
  xi_e_waf=[0.7986, 0.0517, 0.1315, 0.0132;
            0.8700, 0.1080, 0.0000, 0.0040],
  T_ref=273.15);
end CoalOilMixture;
