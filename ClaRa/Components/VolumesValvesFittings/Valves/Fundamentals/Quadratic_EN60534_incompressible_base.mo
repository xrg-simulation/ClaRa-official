within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_EN60534_incompressible_base "Quadratic|Kv definition | supercritical flow | incompressible |EN60534"

  extends ClaRa.Basics.Icons.Delta_p;
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  parameter Integer  paraOption=1 "Type of parametrisation" annotation(Dialog(group="General Parametrisation"), choices(choice = 1 "Kvs", choice = 2 "Nominal Point", choice=3 "Zeta"));
  parameter Real diameter_inlet=10 "Inlet fitting's diameter"
                                                             annotation(Dialog(group = "Valve Geometry",groupImage="modelica://ClaRaPlus/Resources/Images/ParameterDialog/Valve.png"));
  parameter Real diameter_valve=10 "Valve diameter"
                                                   annotation(Dialog(group = "Valve Geometry"));
  parameter Real diameter_outlet=10 "Outlet fitting's diameter"
                                                               annotation(Dialog(group = "Valve Geometry"));

  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";
  parameter Real F_L= 0.75 "Liquid pressure recovery factor when no reducers are installed" annotation(Dialog(group = "Valve Geometry"));

  parameter Real Kvs(unit="m3/h") = 1 "Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))"
                                                                                                                                   annotation(Dialog(group="Valve Characteristics", enable=(paraOption==1)));
  parameter SI.Pressure Delta_p_eps= 100 "Small pressure difference for linearisation around zeor flow" annotation(Dialog(tab="Expert Settings"));

  parameter SI.MassFlowRate m_flow_nominal= Kvs/1000/3600 "Nominal mass flowrate at full opening" annotation(Dialog(group="Valve Characteristics")); //If paraOption Nominal Point is chosen this value will define the valve characteristic. Otherwise only for homotopy-based initialisation.
  parameter SI.Pressure Delta_p_nom = 1e5 "Nominal pressure difference for Kv definition"
                                                                                         annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));
  parameter SI.DensityMassSpecific rho_in_nom= 1000 "Nominal density for Kv definition"
                                                                                       annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));

  parameter SI.Area A_cross= 1 "Valve inlet cross section"
                                                          annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));
  parameter Real zeta= 100 "Pressure Loss coefficient"
                                                      annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));

  Real aperture_ "Effective apperture";
  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";
  final parameter Real Kvs_actual(unit="m3/h")=if paraOption==1 then Kvs else if paraOption==2 then 3600 * m_flow_nominal/rho_in_nom * sqrt(rho_in_nom/1000*1e5/Delta_p_nom) else A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "Actual value of Kvs depending on parametrisation option";
  Real Kv(unit="m3/h") "Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  SI.Pressure Delta_p_choke "Pressure difference at which choking occurs, always positive i.e. independent of flow direction";

  Boolean normIsValid=Kvs/0.865/diameter_valve^2<0.047 "Validity of DIN";
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristics(table=CL_valve,
      columns={2});
  Real F_P = 1/sqrt(1+(((1-diameter_valve^4/diameter_inlet^4) - (1-diameter_valve^4/diameter_outlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2 + (1-(diameter_valve/diameter_outlet)^2)^2)*Kv^2/diameter_valve^4)/K1) "Pipe geometry correction factor";

protected
  constant Real K1= 0.0016 "Coefficient for calculation of F_P";
  SI.Pressure p_in = max(iCom.p_in, iCom.p_out);
  Real F_LP = F_L / sqrt(1+(F_L^2*((1-diameter_valve^4/diameter_inlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2)/K1*(Kv^2/diameter_valve^4)));

equation
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;

 //____________ Pressure drop in design flow direction_______________
  Delta_p_choke =(F_LP/F_P)^2*(p_in - (0.96-0.28*sqrt(iCom.p_vap_in/iCom.p_crit))*iCom.p_vap_in);
//____________Hydraulics____________________________________________
  Kv = aperture_ * Kvs_actual;



end Quadratic_EN60534_incompressible_base;
