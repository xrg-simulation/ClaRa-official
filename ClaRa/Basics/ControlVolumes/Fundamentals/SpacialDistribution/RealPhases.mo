within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
partial model RealPhases "The phases are NOT in ideal thermodynamic equilibrium"

  extends ClaRa.Basics.Icons.RealPhases;
  parameter Real level_rel_start=0.5 "Start value for relative filling level (set by applying control volume)"
                                                                                          annotation(Dialog(enable=false, group="Initialisation"));
  outer parameter Boolean useHomotopy "True, if homotopy method is used during initialisation";

  outer ClaRa.Basics.Records.IComVLE_L3_NPort iCom "Internal communication record";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo "Geometry record";

  Units.Pressure Delta_p_geo_in[geo.N_inlet] "Geodetic pressure difference to inlets";
  Units.Pressure Delta_p_geo_out[geo.N_outlet] "Geodetic pressure difference to outlets";

  Units.MassFraction zoneAlloc_in[geo.N_inlet] "Allocation of inlet mass flows to zones |1:liq|2:vap|";
  // For two-zonal models only! Other wise a vector of size N_cv-1 must be introduced
  Units.MassFraction zoneAlloc_out[geo.N_outlet] "Allocation of outlet mass flows to zones |1:liq|2:vap|";

  Units.Length level_abs "Absolute filling absLevel";
  Real level_rel(start=level_rel_start) "Relative filling absLevel";

  ClaRa.Basics.Units.MassFlowRate m_flow_inliq[geo.N_inlet] "Mass flow passing from inlet to zone 1 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_invap[geo.N_inlet] "Mass flow passing from inlet to zone 2 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_outliq[geo.N_outlet] "Mass flow passing from outlet to zone 1 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_outvap[geo.N_outlet] "Mass flow passing from outlet to zone 2 and vice versa";

  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_inliq[geo.N_inlet] "Enthalpy flow passing from inlet to zone 1 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_invap[geo.N_inlet] "Enthalpy flow passing from inlet to zone 2 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_outliq[geo.N_outlet] "Enthalpy flow passing from outlet to zone 1 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_outvap[geo.N_outlet] "Enthalpy flow passing from outlet to zone 2 and vice versa";

end RealPhases;
