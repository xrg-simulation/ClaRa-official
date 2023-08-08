within ClaRa.Basics.Media.FuelTypes;
record Fuel_refvalues_v3 "{fuel_waf, ash, h2o } |  former 'Coal Reference'  | C,H,O,N,S,Ash,H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    final N_c=3,
    N_e=7,
    C_LHV={38367217.28081321,0,-2500e3},
    C_rho={500,7000,1000},
    C_cp={1037.08,1000,4190},
    waterIndex=3,
    ashIndex=2,
    defaultComposition={0.787,0.135},
    xi_e_waf={{0.8398983481575604,0.04866581956797967,0.08386277001270648,0.020330368487928845}},
    T_ref=273.15);
end Fuel_refvalues_v3;
