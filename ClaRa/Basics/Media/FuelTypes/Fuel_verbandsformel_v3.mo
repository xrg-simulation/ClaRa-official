within ClaRa.Basics.Media.FuelTypes;
record Fuel_verbandsformel_v3 "LHV acc. Verbandsformel | former 'Coal_v3' | C,H,O,N,S,ash,H2O"
  extends ClaRa.Basics.Media.FuelTypes.BaseFuel(
    N_c=7,
    N_e=7,
    C_LHV={33907e3,142324e3 - 2512e3*9,-142324e3/8,0,10465e3,0,-2512e3},
    C_rho={500,500,500,500,500,7000,1000},
    C_cp={1037.08, 1037.08, 1037.08, 1037.08, 1037.08, 1000, 4190},
    waterIndex=7,
    ashIndex=6,
    defaultComposition={0.661,0.0383,0.066,0.016,0.0057,0.135},
    xi_e_waf=zeros(0, 0),
    T_ref=273.15);
end Fuel_verbandsformel_v3;
