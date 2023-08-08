within ClaRa.Basics.Records;
record IComBase_L3
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

  parameter Integer N_cv= 2 "Number of zones";
  parameter Integer N_inlet= 1 "Number of inlet ports";
  parameter Integer N_outlet= 1 "Number of outlet ports";
//____Inlet______________________________________________________________________________
  Units.Pressure p_in[N_inlet] "|Inlet||Inlet pressure";
  Units.Temperature T_in[N_inlet] "|Inlet||Inlet Temperature";
  Units.MassFlowRate m_flow_in[N_inlet] "|Inlet||Inlet mass flow";

//____Outlet_____________________________________________________________________________
  Units.Pressure p_out[N_outlet] "|Outlet||Outlet pressure";
  Units.Temperature T_out[N_outlet] "|Outlet||Outlet Temperature";
  Units.MassFlowRate m_flow_out[N_outlet] "|Outlet||Outlet mass flow";

//_____Bulk______________________________________________________________________________
  Units.Temperature T[N_cv] "|System||Bulk Temperature";
  Units.Pressure p[N_cv] "|System||Outlet pressure";

//_____Nominal___________________________________________________________________________
  parameter Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFlowRate m_flow_nom=1 "Nominal mass flow" annotation (Dialog(tab="Nominal"));
  parameter Units.EnthalpyMassSpecific h_nom=1e4 "Nominal enthalpy" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFraction xi_nom[:]={1} "Nominal mass fraction" annotation (Dialog(tab="Nominal"));
annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComBase_L3;
