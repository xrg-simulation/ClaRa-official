within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_EN60534_base "Quadratic|Kv definition | supercritical flow | compressible |EN60534"

  extends ClaRa.Basics.Icons.Delta_p;
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  outer Boolean checkValve;
  outer Boolean useHomotopy;
  parameter Integer  paraOption=1 "Type of parametrisation" annotation(Dialog(group="General Parametrisation"), choices(choice = 1 "Kvs", choice = 2 "Nominal Point", choice=3 "Zeta"));
  parameter Real diameter_inlet=10 "Inlet fitting's diameter"
                                                             annotation(Dialog(group = "Valve Geometry",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/Valve.png"));
  parameter Real diameter_valve=10 "Valve diameter"
                                                   annotation(Dialog(group = "Valve Geometry"));
  parameter Real diameter_outlet=10 "Outlet fitting's diameter"
                                                               annotation(Dialog(group = "Valve Geometry"));

  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";
  Real Kv(unit="m3/h") "Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  parameter Real x_T= 0.75 "Differential pressure ratio at which choking occurs"
                                                                                annotation(Dialog(group = "Valve Geometry",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/Valve.png"));

  parameter Real Kvs(unit="m3/h") = 1 "Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))"
                                                                                                                                   annotation(Dialog(group="Valve Characteristics", enable=(paraOption==1)));
  parameter SI.Pressure Delta_p_eps= 100 "Small pressure difference for linearisation around zero flow" annotation(Dialog(tab="Expert Settings"));

  parameter SI.MassFlowRate m_flow_nominal= Kvs/1000/3600 "Nominal mass flowrate at full opening" annotation(Dialog(group="Valve Characteristics")); //If paraOption Nominal Point is chosen this value will define the valve characteristic. Otherwise only for homotopy-based initialisation.
  parameter SI.Pressure Delta_p_nom = 1e5 "Nominal pressure difference for Kv definition"
                                                                                         annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));
  parameter SI.DensityMassSpecific rho_in_nom= 1000 "Nominal density for Kv definition"
                                                                                       annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));

  parameter SI.Area A_cross= 1 "Valve inlet cross section"
                                                          annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));
  parameter Real zeta= 100 "Pressure Loss coefficient"
                                                      annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristics(table=CL_valve,
      columns={2});
  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";
  final parameter Real Kvs_actual(unit="m3/h")=if paraOption==1 then Kvs else if paraOption==2 then 3600 * m_flow_nominal/rho_in_nom * sqrt(rho_in_nom/1000*1e5/Delta_p_nom) else A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "Actual value of Kvs depending on parametrisation option";
  Real aperture_ "Effective apperture";

  Boolean normIsValid=Kvs/0.865/diameter_valve^2<0.047 "Validity of DIN";

  Real F_P = 1/sqrt(1+(((1-diameter_valve^4/diameter_inlet^4) - (1-diameter_valve^4/diameter_outlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2 + (1-(diameter_valve/diameter_outlet)^2)^2)*Kv^2/diameter_valve^4)/K1) "Pipe geometry correction factor";
  SI.Pressure Delta_p_choke "Pressure difference at which choking occurs, always positive i.e. independent of flow direction";

  Real Y "Expansion factor";
  Real gamma "Heat capacity ratio at actual inlet";

protected
  constant Real K1= 0.0016 "Coefficient for calculation of F_P";
  constant Real K2= 0.0018 "Coefficient for calculation of X_TP";
  Real x_TChoked "Pressure ratio at which choking of flow occurs";
  Real Delta_p_ "(p_inlet-p_outlet)/p_inlet; naming in DIN EN 60534: x";

  Real F_gamma "Normalising factor for heat capacity ratio";
  SI.Pressure p_in = max(iCom.p_in, iCom.p_out);
  SI.Pressure Delta_p_actual "Actual pressure difference with respect to choking flow";
  Real x_TP = (x_T/F_P^2) / (1+(x_T*((1-diameter_valve^4/diameter_inlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2)/K2*(Kv^2/diameter_valve^4)));
equation
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;
  gamma = if (checkValve == true and iCom.opening_leak_ <= 0) or iCom.opening_ < iCom.opening_leak_ then iCom.gamma_in else (if useHomotopy then homotopy(SM(1000, -1000, Delta_p)*iCom.gamma_in + SM(-1000, 1000, Delta_p)*iCom.gamma_out, iCom.gamma_in) else SM(1000, -1000, Delta_p)*iCom.gamma_in + SM(-1000, 1000, Delta_p)*iCom.gamma_out);

 //____________ Pressure drop in design flow direction_______________
  Delta_p_choke=p_in*x_TChoked;
  Delta_p_ = if checkValve then noEvent(max(0, min(Delta_p/p_in,x_TChoked))) else min(abs(Delta_p)/p_in,x_TChoked);
  F_gamma=gamma/1.4;
  x_TChoked=F_gamma*x_TP;
  Delta_p_actual=sign(Delta_p)*min(abs(Delta_p),abs(x_TChoked*p_in));//recalculate Delta_p for usage of ThermoRoot
//____________Hydraulics____________________________________________
  Kv = aperture_ * Kvs_actual;

  Y= noEvent(min(1,max(2/3, 1-Delta_p_/(3*x_TChoked))));


end Quadratic_EN60534_base;
