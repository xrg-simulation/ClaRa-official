within ClaRa.Basics.Records;
record IComBase_L3
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

  parameter Integer N_cv= 2 "Number of zones";
  parameter Integer N_inlet= 1 "Number of inlet ports";
  parameter Integer N_outlet= 1 "Number of outlet ports";
//____Inlet______________________________________________________________________________
  SI.Pressure p_in[N_inlet] "|Inlet||Inlet pressure";
  SI.Temperature T_in[N_inlet] "|Inlet||Inlet Temperature";
  SI.MassFlowRate  m_flow_in[ N_inlet] "|Inlet||Inlet mass flow";

//____Outlet_____________________________________________________________________________
  SI.Pressure p_out[N_outlet] "|Outlet||Outlet pressure";
  SI.Temperature T_out[N_outlet] "|Outlet||Outlet Temperature";
  SI.MassFlowRate  m_flow_out[N_outlet] "|Outlet||Outlet mass flow";

//_____Bulk______________________________________________________________________________
  SI.Temperature T[N_cv] "|System||Bulk Temperature";
  SI.Pressure p[N_cv] "|System||Outlet pressure";

//_____Nominal___________________________________________________________________________
  parameter SI.Pressure  p_nom=1e5 "Nominal pressure" annotation(Dialog(tab="Nominal"));
  parameter SI.PressureDifference  Delta_p_nom=1e4 "Nominal pressure" annotation(Dialog(tab="Nominal"));
  parameter SI.MassFlowRate  m_flow_nom = 1 "Nominal mass flow" annotation(Dialog(tab="Nominal"));
  parameter SI.EnthalpyMassSpecific  h_nom=1e4 "Nominal enthalpy" annotation(Dialog(tab="Nominal"));
  parameter SI.MassFraction  xi_nom[:]= {1} "Nominal mass fraction" annotation(Dialog(tab="Nominal"));
annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComBase_L3;
