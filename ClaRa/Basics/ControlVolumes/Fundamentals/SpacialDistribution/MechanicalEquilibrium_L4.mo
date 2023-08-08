within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
partial model MechanicalEquilibrium_L4
  extends ClaRa.Basics.Icons.MecahnicalEquilibriumIcon;
  outer ClaRa.Basics.Records.IComVLE_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  Basics.Units.MassFlowRate m_flow[iCom.N_cv + 1];
  parameter   Basics.Units.EnthalpyMassSpecific h_start[geo.N_cv] "Start values for enthalpy";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end MechanicalEquilibrium_L4;
