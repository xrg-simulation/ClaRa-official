within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
partial model PressureLoss_L4 "VLE || PL Base Class"
  extends ClaRa.Basics.Icons.Delta_p;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4;
  outer parameter Boolean frictionAtInlet;
  outer parameter Boolean frictionAtOutlet;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.Basics.Records.IComBase_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  final parameter Units.MassFlowRate m_flow_nom=iCom.m_flow_nom "Nominal mass flow rate";

  final parameter Units.PressureDifference Delta_p_nom=iCom.Delta_p_nom "Nominal pressure loss wrt. all parallel tubes";

  Units.PressureDifference Delta_p[iCom.N_cv + 1] "Pressure difference";
  //   Basics.Units.DensityMassSpecific
  //                          rho[iCom.N_cv+1] "Density in FlowModel cells";
  Units.MassFlowRate m_flow[iCom.N_cv + 1];

  annotation (Icon(graphics));
end PressureLoss_L4;
