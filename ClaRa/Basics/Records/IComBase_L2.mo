within ClaRa.Basics.Records;
record IComBase_L2 "Basic internal communication record"
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  Units.Pressure p_in "Inlet pressure" annotation (Dialog(tab="Inlet"));
  Units.Temperature T_in "Inlet Temperature" annotation (Dialog(tab="Inlet"));
  Units.MassFlowRate m_flow_in "Inlet mass flow" annotation (Dialog(tab="Inlet"));

//____Outlet_____________________________________________________________________________
  Units.Pressure p_out "Outlet pressure" annotation (Dialog(tab="Outlet"));
  Units.Temperature T_out "Outlet Temperature" annotation (Dialog(tab="Outlet"));
  Units.MassFlowRate m_flow_out "Outlet mass flow" annotation (Dialog(tab="Outlet"));

//_____Bulk______________________________________________________________________________
  Units.Temperature T_bulk "Bulk Temperature" annotation (Dialog(tab="Bulk"));
  Units.Pressure p_bulk "Outlet pressure" annotation (Dialog(tab="Bulk"));

//_____Nominal___________________________________________________________________________
  parameter Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(tab="Nominal"));
  parameter Units.EnthalpyMassSpecific h_nom=1e4 "Nominal enthalpy" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFraction xi_nom[:]={1} "Nominal mass fraction" annotation (Dialog(tab="Nominal"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_nom=100 "Nominal pressure loss" annotation (Dialog(tab="Nominal"), HideResult=true);
annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner",
    Icon(graphics));
end IComBase_L2;
