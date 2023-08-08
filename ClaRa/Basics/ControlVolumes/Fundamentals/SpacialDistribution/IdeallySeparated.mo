within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model IdeallySeparated "Separation | Ideal | outlet states depending on filling Level | All geometries"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.4.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases(final modelType="IdeallySeparated");
  extends ClaRa.Basics.Icons.IdealSeparation;

  import ClaRa.Basics.Functions.Stepsmoother;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  outer parameter Boolean useHomotopy;

  parameter Units.Length radius_flange=0.05 "Flange radius";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Shape interpretation|Smoothness of table interpolation";

  constant Units.Length level_abs_min=1e-6;
  final parameter Units.Length z_max_in=min(geo.z_in[1] + radius_flange, geo.height_fill) "Upper edge of inlet flange";
  final parameter Units.Length z_min_in=max(1e-3, geo.z_in[1] - radius_flange) "Lower edge of inlet flange";
  final parameter Units.Length z_max_out=min(geo.z_out[1] + radius_flange, geo.height_fill) "Upper edge of outlet flange";
  final parameter Units.Length z_min_out=max(1e-3, geo.z_out[1] - radius_flange) "Lower edge of outlet flange";

  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table(table=geo.shape, columns={2}, smoothness=smoothness);

  Units.Volume volume_liq "Liquid volume";
  Units.Area A_hor_act "Actual horizontal surface size";
protected
  Units.EnthalpyMassSpecific h_dew;
  Units.EnthalpyMassSpecific h_bubble;
  Units.DensityMassSpecific rho_dew;
  Units.DensityMassSpecific rho_bubble;
  Units.DensityMassSpecific rho_bulk;
  Units.MassFraction steamQuality_bulk;

equation
  //_________________________Required Media Data__________________________________
  h_dew = TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi(
    iCom.p_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  h_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi(
    iCom.p_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  rho_dew = TILMedia.VLEFluidObjectFunctions.dewDensity_pxi(
    iCom.p_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  rho_bubble = TILMedia.VLEFluidObjectFunctions.bubbleDensity_pxi(
    iCom.p_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  rho_bulk = TILMedia.VLEFluidObjectFunctions.density_phxi(
    iCom.p_bulk,
    iCom.h_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  steamQuality_bulk = TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_bulk,
    iCom.h_bulk,
    iCom.xi_bulk,
    iCom.fluidPointer_bulk);
  //_________________________Calculation of the Level______________________________
  A_hor_act = geo.A_hor*table.y[1];
  table.u[1] = level_rel;

  level_abs = min(geo.height_fill, max(level_abs_min, volume_liq/(A_hor_act)));

  volume_liq = max(1e-6, ((1 - steamQuality_bulk)*iCom.mass))/noEvent(max(rho_bubble, rho_bulk));

  level_rel = level_abs/geo.height_fill;

  //_________________________Calculation of the outflowing enthalpy _________________
  h_outflow = if useHomotopy then homotopy(Stepsmoother(
    z_min_out,
    z_max_out,
    level_abs)*noEvent(max(iCom.h_bulk, h_dew)) + (1 - Stepsmoother(
    z_min_out,
    z_max_out,
    level_abs))*noEvent(min(h_bubble, iCom.h_bulk)), iCom.h_bulk) else Stepsmoother(
    z_min_out,
    z_max_out,
    level_abs)*noEvent(max(iCom.h_bulk, h_dew)) + (1 - Stepsmoother(
    z_min_out,
    z_max_out,
    level_abs))*noEvent(min(h_bubble, iCom.h_bulk));

  h_inflow = if useHomotopy then homotopy(Stepsmoother(
    z_min_in,
    z_max_in,
    level_abs)*noEvent(max(iCom.h_bulk, h_dew)) + (1 - Stepsmoother(
    z_min_in,
    z_max_in,
    level_abs))*noEvent(min(h_bubble, iCom.h_bulk)), iCom.h_bulk) else Stepsmoother(
    z_min_in,
    z_max_in,
    level_abs)*noEvent(max(iCom.h_bulk, h_dew)) + (1 - Stepsmoother(
    z_min_in,
    z_max_in,
    level_abs))*noEvent(min(h_bubble, iCom.h_bulk));

  //__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in = (level_abs - geo.z_in[1])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[1] then rho_bubble else rho_dew);
  Delta_p_geo_out = (level_abs - geo.z_out[1])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[1] then rho_bubble else rho_dew);

// initial equation
// The equations introduced here previously for initialisation have been moved to ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2.
// This was done to allow more thoroughly checking of the user parameters and for the sake of transparency. //FG

  annotation (Icon(graphics));
end IdeallySeparated;
