within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL;
partial model PressureLoss_L4 "Gas || PL Base Class"
  extends ClaRa.Basics.Icons.Delta_p;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4;

  outer parameter Boolean frictionAtInlet;
  outer parameter Boolean frictionAtOutlet;

  import SI = ClaRa.Basics.Units;
  outer ClaRa.Basics.Records.IComGas_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  final parameter Basics.Units.Length Delta_x[iCom.N_cv]=geo.Delta_x;
  final parameter Basics.Units.Length Delta_x_FM[iCom.N_cv + 1]=geo.Delta_x_FM "flowModel grid";

  final parameter Basics.Units.MassFlowRate m_flow_nom=iCom.m_flow_nom "Nominal mass flow rate";

  final parameter Basics.Units.PressureDifference Delta_p_nom=iCom.Delta_p_nom "Nominal pressure loss wrt. all parallel tubes";

  Basics.Units.PressureDifference Delta_p[iCom.N_cv + 1] "Pressure difference";
  Basics.Units.DensityMassSpecific rho[iCom.N_cv + 1] "Density in FlowModel cells";
  Basics.Units.MassFlowRate m_flow[iCom.N_cv + 1];

  annotation (Icon(graphics));
end PressureLoss_L4;
