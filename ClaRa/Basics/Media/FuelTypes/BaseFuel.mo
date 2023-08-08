within ClaRa.Basics.Media.FuelTypes;
record BaseFuel "Chose fuel below:"
  extends ClaRa.Basics.Media.FuelTypes.EmptyFuel;
  extends ClaRa.Basics.Icons.RecordIcon;
  constant Integer N_c=5 "Number of components";
  constant Integer N_e=5 "Number of elements";
  parameter Real C_LHV[N_c] = {1,1,1,1,1} "Coefficients for LHV calculation";
  parameter Real C_cp[N_c] = {1,1,1,1,1} "Coefficients for cp calculation";
  constant Real C_rho[N_c] = {1,1,1,1,1} "Coefficients for rho calculation";
  constant Integer waterIndex "Index of water in composition";
  constant Integer ashIndex "Index of ash in composition";
  constant ClaRa.Basics.Units.MassFraction  defaultComposition[N_c-1] "Elemental compostion of combustible, e.g. {C,H,O,N,S, H2O, ash}";
  parameter ClaRa.Basics.Units.MassFraction xi_e_waf[:,:] "water and ash free elementary composition of the two pure fuels";
  constant ClaRa.Basics.Units.Temperature T_ref = 273.15 "Reference temperature";
  //
end BaseFuel;
