within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution;
model RealSeparated "Separation | Real | outlet states depending on filling Level | All geometries"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealSeparation;
  extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_1;
  import ClaRa.Basics.Functions.Stepsmoother;

  /////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
  import ClaRa_Obsolete.Basics.Functions.TableInterpolation.tableInit;
  import ClaRa_Obsolete.Basics.Functions.TableInterpolation.tableIpo;
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  /////// The following block will be conform to MSL 3.2.1 and will be activated in the future//////////
  //   import ClaRa.Basics.Functions.TableInterpolation.getTableValueNoDer;
  //   import ClaRa.Basics.Functions.TableInterpolation.getTableValue;
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  outer ClaRa.Basics.Records.IComVLE_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  outer ClaRa.Basics.Choices.Init initType;
  outer parameter Boolean useHomotopy;

  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius";
  parameter Real absorbInflow(
    min=0,
    max=1) = 1 "absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Shape interpretation|Smoothness of table interpolation";

  final parameter ClaRa.Basics.Units.Length z_max_in[geo.N_inlet]={min(geo.z_in[i] + radius_flange, geo.height_fill) for i in 1:geo.N_inlet} "Upper edges of inlet flanges";
  final parameter ClaRa.Basics.Units.Length z_min_in[geo.N_inlet]={max(1e-3, geo.z_in[i] - radius_flange) for i in 1:geo.N_inlet} "Lower edges of inlet flanges";
  final parameter ClaRa.Basics.Units.Length z_max_out[geo.N_outlet]={min(geo.z_out[i] + radius_flange, geo.height_fill) for i in 1:geo.N_outlet} "Upper edges of outlet flanges";
  final parameter ClaRa.Basics.Units.Length z_min_out[geo.N_outlet]={max(1e-3, geo.z_out[i] - radius_flange) for i in 1:geo.N_outlet} "Lower edges of outlet flanges";
  ClaRa.Basics.Units.DensityMassSpecific rho[iCom.N_cv];
  ClaRa.Basics.Units.MassFraction steamQuality_in[geo.N_inlet];
  ClaRa.Basics.Units.MassFraction steamQuality_out[geo.N_outlet];
  ClaRa.Basics.Units.Area A_hor_act "Actual horizontal surface size";
protected
  constant ClaRa.Basics.Units.Length level_abs_min=1e-6;
  /////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
  //   final  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableID=
  //       Modelica.Blocks.Types.ExternalCombiTable1D("NoName", "NoName", iCom.shape, {2}, smoothness)
  //     "External table object";
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  /////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
  final parameter Integer tableID=tableInit(
      "NoName",
      "NoName",
      geo.shape,
      smoothness) "External table object";
  //////////////////////////////////////////////////////////////////////////////////////////////////////

equation
  //_________________________Calculation of the Level______________________________
  /////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
  //   if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments then
  //     level_abs=min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(iCom.A_hor*getTableValueNoDer(tableID, 1, level_rel, 1))));
  //   else
  //     level_abs=min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(iCom.A_hor*getTableValue(tableID, 1, level_rel, 1))));
  //   end if;
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  /////// The following block is conform to MSL 3.2 and will be removed in the future////////////////
  level_abs = min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(A_hor_act)));
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  level_rel = level_abs/geo.height_fill;
  A_hor_act = geo.A_hor*tableIpo(
    tableID,
    2,
    level_rel);
  //_________________________Allocate mass flow rates to the two zones_____________
  m_flow_inliq = {semiLinear(
    iCom.m_flow_in[i],
    absorbInflow*(2 - zoneAlloc_in[i]) + (1 - absorbInflow)*(1 - steamQuality_in[i]),
    2 - zoneAlloc_in[i]) for i in 1:geo.N_inlet};
  m_flow_invap = {semiLinear(
    iCom.m_flow_in[i],
    absorbInflow*(zoneAlloc_in[i] - 1) + (1 - absorbInflow)*(steamQuality_in[i]),
    zoneAlloc_in[i] - 1) for i in 1:geo.N_inlet};
  m_flow_outliq = {semiLinear(
    iCom.m_flow_out[i],
    absorbInflow*(2 - zoneAlloc_out[i]) + (1 - absorbInflow)*(1 - steamQuality_out[i]),
    2 - zoneAlloc_out[i]) for i in 1:geo.N_outlet};
  m_flow_outvap = {semiLinear(
    iCom.m_flow_out[i],
    absorbInflow*(zoneAlloc_out[i] - 1) + (1 - absorbInflow)*(steamQuality_out[i]),
    zoneAlloc_out[i] - 1) for i in 1:geo.N_outlet};

  //_________________________Calculation of additional media data_________________
  rho = {TILMedia.VLEFluidObjectFunctions.density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i]) for i in 1:iCom.N_cv};
  steamQuality_in = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_in[i],
    iCom.h_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  steamQuality_out = {TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
    iCom.p_out[i],
    iCom.h_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};

  //_________________________Calculation of the outflowing enthalpy _________________
  for i in 1:iCom.N_outlet loop
    //h_outflow_outliq[i] = Stepsmoother(z_min_out[i],z_max_out[i], level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_out[i],z_max_out[i], level_abs))*iCom.h[1];
    zoneAlloc_out[i] = Stepsmoother(
      z_min_out[i],
      z_max_out[i],
      level_abs) + 1;
  end for;
  for i in 1:iCom.N_inlet loop
    //h_inflow[i]  = Stepsmoother(z_min_in[i], z_max_in[i],  level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_in[i], z_max_in[i],  level_abs))*iCom.h[1];
    zoneAlloc_in[i] = Stepsmoother(
      z_min_in[i],
      z_max_in[i],
      level_abs) + 1;
  end for;

  //__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in = {(level_abs - geo.z_in[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[i] then rho[1] else rho[2]) for i in 1:geo.N_inlet};
  Delta_p_geo_out = {(level_abs - geo.z_out[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[i] then rho[1] else rho[2]) for i in 1:geo.N_outlet};

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end RealSeparated;
