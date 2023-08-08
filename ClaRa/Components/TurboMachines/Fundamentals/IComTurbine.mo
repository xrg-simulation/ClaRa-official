within ClaRa.Components.TurboMachines.Fundamentals;
record IComTurbine
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
   SI.MassFlowRate  m_flow_in "Inlet mass flow" annotation(Dialog(tab="Inlet"));
   SI.DensityMassSpecific  rho_in "Inlet density" annotation(Dialog(tab="Inlet"));
//_____Nominal___________________________________________________________________________
  parameter  SI.MassFlowRate  m_flow_nom=10 "Nominal mass flow" annotation(Dialog(tab="Nominal"));
  parameter  SI.DensityMassSpecific  rho_nom=10 "Nominal inlet density" annotation(Dialog(tab="Nominal"));

   SI.RPM rpm "Shaft speed";
   SI.EnthalpyMassSpecific Delta_h_is "Isentropic enthalpy drop";
end IComTurbine;
