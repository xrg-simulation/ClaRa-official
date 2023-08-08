within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model QuadraticNominalPoint "Quadratic|Nominal operation point | subcritical flow"
//   "A linear pressure loss using a constant pressure loss coefficient"
  //extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  extends ClaRa.Basics.Icons.Delta_p;
  extends ClaRa.Basics.Icons.Obsolete;
  import SI = ClaRa.Basics.Units;
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";

  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  outer Boolean checkValve;
  outer Boolean useHomotopy;

  SI.MassFlowRate m_flow;
  Real aperture_ "Effective apperture";

  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristics(table=CL_valve,
      columns={2});
  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";

  import SM = ClaRa.Basics.Functions.Stepsmoother;

  final parameter Real Kvs(unit="m3/h") = 3600 * m_flow_nom/rho_in_nom * sqrt(rho_in_nom/1000*1e5/Delta_p_nom) "|Valve Characteristics|Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  Real Kv(unit="m3/h") "|Valve Characteristics|Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  parameter SI.Pressure Delta_p_eps= 100 "|Expert Settings||Small pressure difference for linearisation around zeor flow";
// protected
  parameter SI.Pressure Delta_p_nom = 1e5 "|Valve Characteristics|Nominal pressure difference for Kv definition";
  parameter SI.DensityMassSpecific rho_in_nom= 1000 "|Valve Characteristics|Nominal density for Kv definition";
  parameter SI.MassFlowRate m_flow_nom= 1 "|Valve Characteristics|Nominal mass flow rate";
  Real flowIsChoked=0 "1 if flow is choked, 0 if not";
  Real PR_choked=-1 "Pressure ratio at which choking occurs";
equation
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;

   Kv = aperture_ * Kvs;
  m_flow = if checkValve then SM(Delta_p_eps/10,0, Delta_p) * Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/max(1e-3,iCom.rho_in))
                                                                                           else Kv/3600 * iCom.rho_in * ClaRa.Basics.Functions.ThermoRoot(Delta_p/1e5, Delta_p_eps/1e5)*sqrt(1000/max(1e-3,iCom.rho_in));
end QuadraticNominalPoint;
