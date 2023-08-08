within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
partial model IdealPhases "The phases are in ideal thermodynamic equilibrium"

  outer ClaRa.Basics.Records.IComVLE_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  extends ClaRa.Basics.Icons.IdealPhases;

  ClaRa.Basics.Units.EnthalpyMassSpecific h_inflow;
  ClaRa.Basics.Units.EnthalpyMassSpecific h_outflow;
  ClaRa.Basics.Units.PressureDifference Delta_p_geo_in;
  ClaRa.Basics.Units.PressureDifference Delta_p_geo_out;
public
  Units.Length level_abs "Absolute filling absLevel";
  Real level_rel(start=level_rel_start) "Relative filling absLevel";
  parameter Real level_rel_start=0.5 "Start value for relative filling Level";
  parameter String modelType;
end IdealPhases;
