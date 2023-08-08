within ClaRa.Components.TurboMachines.Fundamentals;
record IComTurbine
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  Basics.Units.MassFlowRate m_flow_in "Inlet mass flow" annotation (Dialog(tab="Inlet"));
  Basics.Units.DensityMassSpecific rho_in "Inlet density" annotation (Dialog(tab="Inlet"));
//_____Nominal___________________________________________________________________________
  parameter Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(tab="Nominal"));
  parameter Basics.Units.DensityMassSpecific rho_nom=10 "Nominal inlet density" annotation (Dialog(tab="Nominal"));

  Basics.Units.RPM rpm "Shaft speed";
  Basics.Units.EnthalpyMassSpecific Delta_h_is "Isentropic enthalpy drop";
end IComTurbine;
