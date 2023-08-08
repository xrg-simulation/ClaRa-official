within ClaRa.Basics.Records;
record IComBase_L2 "Basic internal communication record"
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  SI.Pressure p_in "Inlet pressure" annotation(Dialog(tab="Inlet"));
  SI.Temperature T_in "Inlet Temperature" annotation(Dialog(tab="Inlet"));
  SI.MassFlowRate  m_flow_in "Inlet mass flow" annotation(Dialog(tab="Inlet"));

//____Outlet_____________________________________________________________________________
   SI.Pressure p_out "Outlet pressure" annotation(Dialog(tab="Outlet"));
  SI.Temperature T_out "Outlet Temperature"     annotation(Dialog(tab="Outlet"));
  SI.MassFlowRate  m_flow_out "Outlet mass flow" annotation(Dialog(tab="Outlet"));

//_____Bulk______________________________________________________________________________
  SI.Temperature T_bulk "Bulk Temperature" annotation(Dialog(tab="Bulk"));
  SI.Pressure p_bulk "Outlet pressure" annotation(Dialog(tab="Bulk"));

//_____Nominal___________________________________________________________________________
  parameter SI.Pressure  p_nom=1e5 "Nominal pressure" annotation(Dialog(tab="Nominal"));
  parameter SI.MassFlowRate  m_flow_nom=10 "Nominal mass flow" annotation(Dialog(tab="Nominal"));
  parameter SI.EnthalpyMassSpecific  h_nom=1e4 "Nominal enthalpy" annotation(Dialog(tab="Nominal"));
  parameter SI.MassFraction  xi_nom[:]= {1} "Nominal mass fraction" annotation(Dialog(tab="Nominal"));
annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner",
    Icon(graphics));
end IComBase_L2;
