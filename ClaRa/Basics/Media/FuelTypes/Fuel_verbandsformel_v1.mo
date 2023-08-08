within ClaRa.Basics.Media.FuelTypes;
record Fuel_verbandsformel_v1 "LHV acc. Verbandsformel | former 'Coal_v1' | C,H,O,N,S,ash,H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    N_c=7,
    N_e=7,
    C_LHV={33907e3,142324e3 - 2512e3*9,-142324e3/8,0,10465e3,0,-2512e3},
    C_rho={1400,1400,1400,1400,1400,1400,1000},
    C_cp={1266.67,1266.67,1266.67,1266.67,1266.67,1000,4190},
    waterIndex=7,
    ashIndex=6,
    defaultComposition={0.761,0,0,0,0.004,0.125},
    xi_e_waf=zeros(0, 0),
    T_ref=273.15);
    //C_rho={1400,500,500,500,500,7000,1000},
    //defaultComposition={0.8,0.05,0.05,0.05,0.025,0.025},
end Fuel_verbandsformel_v1;
