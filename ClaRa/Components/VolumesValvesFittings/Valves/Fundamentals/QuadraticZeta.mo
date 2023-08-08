within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model QuadraticZeta "Quadratic | zeta definition | unchoked flow | incompressible"
  //extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";

  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;


  Real aperture_ "Effective apperture";

  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristics(table=CL_valve,
      columns={2});
  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  final parameter Real Kvs(unit="m3/h") = A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "|Valve Characteristics|Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  Real Kv(unit="m3/h") "|Valve Characteristics|Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  parameter SI.Pressure Delta_p_eps= 100 "|Expert Settings||Small pressure difference for linearisation around zeor flow";
  parameter SI.Area A_cross= 1 "|Valve Characteristics|Valve inlet cross section";
  parameter Real zeta= 100 "|Valve Characteristics|Pressure Loss coefficient";

equation
  flowIsChoked=0 "1 if flow is choked, 0 if not";
  PR_choked=-1 "Pressure ratio at which choking occurs";
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;
  Kv = aperture_ * Kvs;
  m_flow = if checkValve then SM(Delta_p_eps/10,0, Delta_p) * Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in)
                                                                                           else Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/iCom.rho_in);

end QuadraticZeta;
