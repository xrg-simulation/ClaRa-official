within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model QuadraticZeta "Quadratic|zeta definition | subcritical flow condition"
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  final parameter Real Kvs(unit="m3/h") = A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "|Valve Characteristics|Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  Real Kv(unit="m3/h") "|Valve Characteristics|Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  parameter SI.Pressure Delta_p_eps= 100 "|Expert Settings||Small pressure difference for linearisation around zeor flow";
  parameter SI.Area A_cross= 1 "|Valve Characteristics|Valve inlet cross section";
  parameter Real zeta= 100 "|Valve Characteristics|Pressure Loss coefficient";

equation
  gamma = 2e30 "is not used";
  Kv = aperture_ * Kvs;
//  m_flow = noEvent(if checkValve then if Delta_p >0 then Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in) else
  //                                                                                                  0 else Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in));
  m_flow = if checkValve then SM(Delta_p_eps/10,0, Delta_p) * Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in)
                                                                                           else Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in);

end QuadraticZeta;
