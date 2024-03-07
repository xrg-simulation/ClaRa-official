within ClaRa.Examples;

model SteamPowerPlant_01_OM_furnace "A steam power plant model based on SteamCycle_02 with a detailed boiler model (coal dust fired Benson boiler) without controls"
  //__________________________________________________________________________//
  // Component of the ClaRa library, version: 1.8.1                           //
  //                                                                          //
  // Licensed by the ClaRa development team under the 3-clause BSD License.   //
  // Copyright  2013-2023, ClaRa development team.                            //
  //                                                                          //
  // The ClaRa development team consists of the following partners:           //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                 //
  // XRG Simulation GmbH (Hamburg, Germany).                                  //
  //__________________________________________________________________________//
  // Contents published in ClaRa have been contributed by different authors   //
  // and institutions. Please see model documentation for detailed information//
  // on original authorship and copyrights.                                   //
  //__________________________________________________________________________//
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;
  import Modelica.Utilities.Files.loadResource;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component" annotation(
    Dialog(group = "Fundamental Definitions"),
    choicesAllMatching);
  parameter Real alpha_wall = 15;
  parameter Real emissivity_wall = 0.75;
  parameter Real CF_fouling_glob = 0.8;
  parameter Real CF_fouling_rad_glob = 0.78;
  //Real P_gen_act = electricalPower.x1/633;
  ClaRa.Basics.Units.HeatFlowRate totalHeat;
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner3(m_flow_const = 42/4, xi_const = {0.84, 0.07}, variable_m_flow = true, energyType = 1) annotation(
    Placement(transformation(extent = {{-244, -106}, {-224, -86}})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_split coalSlagFlueGas_split_top annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-134, 222})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource_top(m_flow_const = 0.0, T_const = 658.15) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-192, 248})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink_top(T_const = 658.15, xi_const = {0.84, 0.07}) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-166, 236})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(T_const = 658.15, xi_const = {0.00488, 0.00013, 0.21147, 0.00155, 0.70952, 0.03784, 0, 0.00347, 0}, p_const(displayUnit = "bar") = 99000) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-328, 58})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner1(m_flow_const = 42/4, xi_const = {0.84, 0.07}, variable_m_flow = true, energyType = 1) annotation(
    Placement(transformation(extent = {{-244, -158}, {-224, -138}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner1 annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-194, -154})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner2(m_flow_const = 42/4, xi_const = {0.84, 0.07}, variable_m_flow = true, energyType = 1) annotation(
    Placement(transformation(extent = {{-244, -132}, {-224, -112}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner2 annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-194, -128})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner1(T_slag = 600 + 273.15, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_out = {18.5}, z_in = {11.318}, height = abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]), length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 0.5), redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone, redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed, Tau = 0.01, T_top_initial = INIT.brnr2.T_fg_out, T_start_flueGas_out = INIT.brnr1.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 136, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), slagTemperature_calculationType = 2, redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 101000) annotation(
    Placement(transformation(extent = {{-30, -10}, {30, 10}}, rotation = 0, origin = {-118, -154})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner2(T_slag = burner1.T_slag, redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_in = {burner1.geo.z_out[1]}, z_out = {24}, height = burner2.geo.z_out[1] - burner2.geo.z_in[1], length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 0.5), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed, Tau = 0.1, T_start_flueGas_out = INIT.brnr2.T_fg_out, T_top_initial = INIT.brnr3.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 274, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), slagTemperature_calculationType = 2, redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 100950) annotation(
    Placement(transformation(extent = {{-30, -10.0001}, {30, 10}}, rotation = 0, origin = {-118, -128})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner3(T_slag = burner1.T_slag, redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_in = {burner2.geo.z_out[1]}, z_out = {29.5}, height = burner3.geo.z_out[1] - burner3.geo.z_in[1], length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 0.5), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed, Tau = 0.01, T_start_flueGas_out = INIT.brnr3.T_fg_out, T_top_initial = INIT.brnr4.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 412, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), slagTemperature_calculationType = 2, redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 100900) annotation(
    Placement(transformation(extent = {{-30, -10}, {30, 10}}, rotation = 0, origin = {-118, -102})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner3 annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-194, -102})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_1(redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated", diameter_mean_coke = 40e-6, Q_mean_abs_coke = 0.65), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_in = {burner4.geo.z_out[1]}, z_out = {41.334}, height = flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1], length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 1.2), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed(w_initial = 15), Tau = 0.01, T_start_flueGas_out = INIT.evap_rad.T_fg_out, T_top_initial = INIT.evap_rad.T_fg_out - 50, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", diameter_mean_coke = 40e-6, Q_mean_abs_coke = 0.65, emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 100800) annotation(
    Placement(transformation(extent = {{-148, -60}, {-88, -40}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_2(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), Tau = 0.01, T_start_flueGas_out = INIT.rh2.T_fg_out - 260, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2(temperatureDifference = "Logarithmic mean - smoothed", suspension_calculationType = "Calculated", CF_fouling = 0.9), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_sh_4.geo.z_out[1]}, z_out = {71.45}, width = 14.576, tubeOrientation = 0, height = flameRoom_rh_2.geo.z_out[1] - flameRoom_rh_2.geo.z_in[1], length = 14.576, diameter_t = 0.051, N_tubes = 800, N_passes = 2, N_rows = 32), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100400) annotation(
    Placement(transformation(extent = {{-148, 76}, {-88, 96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature5(T = 658.15) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-84, 206})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner4(T_slag = burner1.T_slag, redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_in = {burner3.geo.z_out[1]}, z_out = {35}, height = burner4.geo.z_out[1] - burner4.geo.z_in[1], length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 0.5), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed, Tau = 0.01, T_start_flueGas_out = INIT.brnr4.T_fg_out, T_top_initial = INIT.evap_rad.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), slagTemperature_calculationType = 2, redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 100850) annotation(
    Placement(transformation(extent = {{-30, -10}, {30, 10}}, rotation = 0, origin = {-118, -76})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner4(m_flow_const = 42/4, xi_const = {0.84, 0.07}, variable_m_flow = true, energyType = 1) annotation(
    Placement(transformation(extent = {{-244, -80}, {-224, -60}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner4 annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-194, -76})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_join coalSlagFlueGas_join annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-134, -206})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_bottom(m_flow_const = 6.5, T_const = 283.15, variable_xi = false, xi_const = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, variable_m_flow = false) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-108, -244})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom(m_flow_const = 0, T_const = 293.15, variable_m_flow = false, xi_const = {0.84, 0.07}) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-158, -244})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slaglSink_bottom(T_const = 373.15) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-134, -244})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow boilerLosses(Q_flow(displayUnit = "MW") = 0) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-90, -200})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_2(redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, z_in = {flameRoom_evap_1.geo.z_out[1]}, z_out = {56.342}, height = flameRoom_evap_2.geo.z_out[1] - flameRoom_evap_2.geo.z_in[1], length = 14.576), redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime(Tau_burn_const = 1.2), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed(w_initial = 15), redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), Tau = 0.01, T_start_flueGas_out = INIT.evap_rad.T_fg_out - 50, T_top_initial = INIT.sh1.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", diameter_mean_coke = 40e-6, Q_mean_abs_coke = 0.65, emissivity_wall = emissivity_wall, CF_fouling = CF_fouling_rad_glob), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 50), p_start_flueGas_out(displayUnit = "bar") = 100750) annotation(
    Placement(transformation(extent = {{-148, -34}, {-88, -14}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_1(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), Tau = 0.01, T_start_flueGas_out = INIT.sh1.T_fg_out - 100, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_evap_2.geo.z_out[1]}, z_out = {59.36}, width = 14.576, tubeOrientation = 0, height = flameRoom_sh_1.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, diameter_t = sh_1_wall.diameter_o, N_tubes = 300, N_passes = 1), redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2(suspension_calculationType = "Calculated", temperatureDifference = "Logarithmic mean - smoothed", CF_fouling = 0.55), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100700) annotation(
    Placement(transformation(extent = {{-148, -8}, {-88, 12}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_2(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), Tau = 0.01, T_start_flueGas_out = INIT.sh2.T_fg_out - 200, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_sh_1.geo.z_out[1]}, z_out = {63.91}, width = 14.576, tubeOrientation = 0, height = flameRoom_sh_2.geo.z_out[1] - flameRoom_sh_2.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, diameter_t = sh_2_wall.diameter_o, N_tubes = 250, N_passes = 2), redeclare model HeatTransfer_TubeBundle = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2(suspension_calculationType = "Calculated", CF_fouling = 0.55), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100600) annotation(
    Placement(transformation(extent = {{-148, 20}, {-88, 40}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_4(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), Tau = 0.01, T_start_flueGas_out = INIT.sh4.T_fg_out - 250, xi_start_flueGas_out = INIT.eco.xi_fg_out, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_sh_2.geo.z_out[1]}, z_out = {67.89}, width = 14.576, tubeOrientation = 0, height = flameRoom_sh_4.geo.z_out[1] - flameRoom_sh_4.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, diameter_t = sh_4_wall.diameter_o, N_tubes = 530, N_passes = 2), redeclare model HeatTransfer_TubeBundle = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2(suspension_calculationType = "Calculated", CF_fouling = 0.6), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100500) annotation(
    Placement(transformation(extent = {{-148, 48}, {-88, 68}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_3(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), Tau = 0.01, T_start_flueGas_out = INIT.sh3.T_fg_out - 200, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_rh_2.geo.z_out[1]}, z_out = {75.18}, width = 14.576, tubeOrientation = 0, height = flameRoom_sh_3.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, diameter_t = sh_3_wall.diameter_o, N_tubes = 500, N_passes = 2), redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2(temperatureDifference = "Logarithmic mean - smoothed", suspension_calculationType = "Calculated", CF_fouling = 0.65), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100300) annotation(
    Placement(transformation(extent = {{-148, 104}, {-88, 124}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_1(redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30), redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), T_start_flueGas_out = INIT.rh1.T_fg_out, Tau = 0.01, xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_sh_3.geo.z_out[1]}, z_out = {82.9}, width = 14.576, tubeOrientation = 0, diameter_t = rh_1_wall.diameter_o, height = flameRoom_rh_1.geo.z_out[1] - flameRoom_rh_1.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, N_tubes = 420, N_passes = 6, N_rows = 50), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100200) annotation(
    Placement(transformation(extent = {{-148, 132}, {-88, 152}})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_eco(redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime, redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple(w_fixed = 10), T_start_flueGas_out = INIT.eco.T_fg_out, Tau = 0.01, redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom = 30, temperatureDifference = "Inlet"), xi_start_flueGas_out = INIT.eco.xi_fg_out, m_flow_nom = 550, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(temperatureDifference = "Inlet", CF_fouling = CF_fouling_glob, alpha_nom = alpha_wall), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes(z_in = {flameRoom_rh_1.geo.z_out[1]}, z_out = {85.6}, width = 14.576, diameter_t = eco_wall.diameter_o, height = flameRoom_eco.geo.z_out[1] - flameRoom_eco.geo.z_in[1], length = 14.576, flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical, N_tubes = 250, N_passes = 6, N_rows = 30, tubeOrientation = 0), redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2(Delta_p_nom = 100), p_start_flueGas_out(displayUnit = "bar") = 100100) annotation(
    Placement(transformation(extent = {{-148, 160}, {-88, 180}})));
  ClaRa.Components.Furnace.Hopper.Hopper_L2 hopper(redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2(suspension_calculationType = "Calculated"), redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(width = 14.576, length = 14.576, height = abs(hopper.geo.z_out[1] - hopper.geo.z_in[1]), z_out = {burner1.geo.z_in[1]}, z_in = {4.03}), T_slag = 600 + 273.15, m_flow_nom = 1000, Tau = 0.01, T_start_flueGas_out = INIT.brnr4.T_fg_out - 500, T_top_initial = INIT.brnr1.T_fg_out, xi_start_flueGas_out = INIT.eco.xi_fg_out, redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2(suspension_calculationType = "Calculated", CF_fouling = CF_fouling_rad_glob), p_start_flueGas_out(displayUnit = "bar") = 100980) annotation(
    Placement(transformation(extent = {{-150, -188}, {-90, -168}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_1_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, length = flameRoom_evap_1.geo.z_out[1] - burner1.geo.z_in[1], diameter_i = 0.0268, diameter_o = 0.038, N_tubes = 330, suppressChattering = "False", Delta_x = {abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]), abs(burner2.geo.z_out[1] - burner2.geo.z_in[1]), abs(burner3.geo.z_out[1] - burner3.geo.z_in[1]), abs(burner4.geo.z_out[1] - burner4.geo.z_in[1]), abs(flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1])}, T_start = {INIT.brnr1.T_vle_wall_out, INIT.brnr2.T_vle_wall_out, INIT.brnr3.T_vle_wall_out, INIT.brnr4.T_vle_wall_out, INIT.evap_rad.T_vle_wall_out}, stateLocation = 2, initOption = 213) annotation(
    Placement(transformation(extent = {{-13.9999, -4.99995}, {13.9998, 4.99995}}, rotation = 90, origin = {107, -120})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_2_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 4, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, 46, 4), diameter_i = 0.0298, length = 46, N_tubes = 330, diameter_o = 0.0424, suppressChattering = "False", T_start = linspace((INIT.brnr4.T_vle_wall_out + INIT.evap_rad.T_vle_wall_out)/2, INIT.evap_rad.T_vle_wall_out, 4), stateLocation = 2, initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99996}, {14, 4.99998}}, rotation = 90, origin = {105, -24})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N = 4, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{52, -34}, {72, -14}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_3_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 4, diameter_i = 0.0206, length = flameRoom_rh_2.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1], N_tubes = 970, diameter_o = 0.0318, suppressChattering = "False", Delta_x = {flameRoom_sh_1.geo.height, flameRoom_sh_2.geo.height, flameRoom_sh_4.geo.height, flameRoom_rh_2.geo.height}, T_start = {INIT.sh1.T_vle_wall_out, INIT.sh2.T_vle_wall_out, INIT.sh4.T_vle_wall_out, INIT.rh2.T_vle_wall_out}, stateLocation = 2, initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -5}, {14, 5}}, rotation = 90, origin = {107, 40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_4_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 3, diameter_o = 0.0424, diameter_i = 0.0298, N_tubes = 500, suppressChattering = "False", T_start = {INIT.sh3.T_vle_wall_out, INIT.rh1.T_vle_wall_out, INIT.eco.T_vle_wall_out}, stateLocation = 2, length = flameRoom_eco.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1]*1, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, evap_4_wall.length, 3), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99998}, {13.9999, 4.99998}}, rotation = 90, origin = {109, 142})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_1_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, 12, 5), diameter_i = 0.0269, N_tubes = 300, suppressChattering = "False", T_start = linspace(INIT.sh1.T_vle_bundle_in, INIT.sh1.T_vle_bundle_out, 5), stateLocation = 2, length = 12*1, diameter_o = 0.0345, initOption = 213) annotation(
    Placement(transformation(origin = {363, -82}, extent = {{-14, -4.99999}, {14, 5.00002}}, rotation = 90)));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{304, -92}, {324, -72}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_2_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_i = 0.0269, N_tubes = 250, suppressChattering = "False", T_start = linspace(INIT.sh2.T_vle_bundle_in, INIT.sh2.T_vle_bundle_out, 5), stateLocation = 2, length = 15*2, diameter_o = 0.0345, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, sh_2_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99999}, {14, 5.00002}}, rotation = 90, origin = {353, 20})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort8(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{308, 10}, {328, 30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_3_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_i = 0.0268, N_tubes = 500, suppressChattering = "False", T_start = linspace(INIT.sh3.T_vle_bundle_in, INIT.sh3.T_vle_bundle_out, 5), stateLocation = 2, length = 15*2, diameter_o = 0.0300, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, sh_3_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99999}, {14, 5.00002}}, rotation = 90, origin = {353, 104})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort9(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{306, 94}, {326, 114}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_4_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_i = 0.0238, N_tubes = 530, diameter_o = 0.038, suppressChattering = "False", T_start = linspace(INIT.sh4.T_vle_bundle_in, INIT.sh4.T_vle_bundle_out, 5), stateLocation = 2, length = 15*2, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, sh_4_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99999}, {14, 5.00002}}, rotation = 90, origin = {346, 216})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort10(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{302, 206}, {322, 226}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_i = 0.0334, N_tubes = 250, diameter_o = 0.0424, suppressChattering = "False", T_start = linspace(INIT.eco.T_vle_bundle_in, INIT.eco.T_vle_bundle_out, 5), stateLocation = 2, length = 15*6, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, eco_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -5.0001}, {14, 5.0001}}, rotation = 90, origin = {94.9999, -298})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort13(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{54, -308}, {74, -288}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_1_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_o = 0.051, diameter_i = 0.0413, N_tubes = 420, suppressChattering = "False", T_start = linspace(INIT.rh1.T_vle_bundle_in, INIT.rh1.T_vle_bundle_out, 5), stateLocation = 2, length = 15.3*6, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, rh_1_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -5.00007}, {14, 5.00007}}, rotation = 90, origin = {577, -2})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort11(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{534, -12}, {554, 8}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_2_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 5, diameter_o = 0.051, diameter_i = 0.0397, N_tubes = 800, suppressChattering = "False", T_start = linspace(INIT.rh2.T_vle_bundle_in, INIT.rh2.T_vle_bundle_out, 5), stateLocation = 2, length = 15*2, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, rh_2_wall.length, 5), initOption = 213) annotation(
    Placement(transformation(extent = {{-13.9999, -4.99997}, {13.9999, 4.99993}}, rotation = 90, origin = {575, 124})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort12(N = 5, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{524, 114}, {544, 134}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_0_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, diameter_o = 0.038, N_ax = 4, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, hopper.geo.z_out[1] - hopper.geo.z_in[1], 4), diameter_i = 0.0268, length = hopper.geo.z_out[1] - hopper.geo.z_in[1], N_tubes = 970, suppressChattering = "False", T_start = ones(4)*(INIT.brnr1.T_vle_wall_in), stateLocation = 2, initOption = 213) annotation(
    Placement(transformation(extent = {{-14, -4.99981}, {14, 4.99977}}, rotation = 90, origin = {97.0002, -180})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(N = 4, equalityMode = "Equal Temperatures") annotation(
    Placement(transformation(extent = {{48, -192}, {68, -172}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 ct_1_wall(redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel, N_ax = 7, Delta_x = ClaRa.Basics.Functions.GenerateGrid({0, 0}, 32, 7), diameter_i = 0.027, N_tubes = 310, diameter_o = 0.0445, suppressChattering = "False", T_start = linspace(INIT.ct.T_vle_wall_in, INIT.ct.T_vle_wall_out, 7), stateLocation = 2, length = 32*1, initOption = 213) annotation(
    Placement(transformation(extent = {{14, -4.99999}, {-14, 5}}, rotation = 90, origin = {209, 78})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill4(T_out_start = 846, mass_pca_start = 90, initOption = 0, applyGrindingDelay = true) annotation(
    Placement(transformation(extent = {{-178, -86}, {-158, -66}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill1(T_out_start = 846, mass_pca_start = 90, initOption = 0, applyGrindingDelay = true) annotation(
    Placement(transformation(extent = {{-178, -164}, {-158, -144}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill2(T_out_start = 846, mass_pca_start = 90, initOption = 0, applyGrindingDelay = true) annotation(
    Placement(transformation(extent = {{-178, -138}, {-158, -118}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill3(T_out_start = 846, mass_pca_start = 90, initOption = 0, applyGrindingDelay = true) annotation(
    Placement(transformation(extent = {{-178, -112}, {-158, -92}})));
  Modelica.Blocks.Sources.Ramp ramp2(duration = 10, offset = 1.50, startTime = 1500, height = -0.0) annotation(
    Placement(transformation(extent = {{-218, -60}, {-198, -40}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 INIT(P_target_ = 1, p_condenser = NOM.p_condenser, preheater_HP_p_tap = NOM.preheater_HP_p_tap, preheater_HP_m_flow_tap = NOM.preheater_HP_m_flow_tap, preheater_LP1_p_tap = NOM.preheater_LP1_p_tap, preheater_LP1_m_flow_tap = NOM.preheater_LP1_m_flow_tap, p_FWT = NOM.p_FWT, valve_LP1_Delta_p_nom = NOM.valve_LP1_Delta_p_nom, valve_LP2_Delta_p_nom = NOM.valve_LP2_Delta_p_nom, T_LS_nom = NOM.T_LS_nom, T_RS_nom = NOM.T_RS_nom, p_LS_out_nom = NOM.p_LS_out_nom, p_RS_out_nom = NOM.p_RS_out_nom, Delta_p_LS_nom = NOM.Delta_p_LS_nom, Delta_p_RS_nom = NOM.Delta_p_RS_nom, CharLine_Delta_p_HP_mLS_ = NOM.CharLine_Delta_p_HP_mLS_, CharLine_Delta_p_IP_mRS_ = NOM.CharLine_Delta_p_IP_mRS_, efficiency_Pump_cond = NOM.efficiency_Pump_cond, efficiency_Pump_preheater_LP1 = NOM.efficiency_Pump_preheater_LP1, efficiency_Pump_FW = NOM.efficiency_Pump_FW, efficiency_Turb_HP = NOM.efficiency_Turb_HP, efficiency_Turb_LP1 = NOM.efficiency_Turb_LP1, efficiency_Turb_LP2 = NOM.efficiency_Turb_LP2, m_flow_nom = NOM.m_flow_nom, IP3_pressure(displayUnit = "kPa"), efficiency_Turb_IP1 = NOM.efficiency_Turb_IP1, efficiency_Turb_IP2 = NOM.efficiency_Turb_IP2, efficiency_Turb_IP3 = NOM.efficiency_Turb_IP3, efficiency_Turb_LP3 = NOM.efficiency_Turb_LP3, efficiency_Turb_LP4 = NOM.efficiency_Turb_LP4) annotation(
    Placement(transformation(extent = {{1446, 402}, {1466, 422}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 NOM(final P_target_ = 1, Delta_p_RS_nom = 4.91e5, efficiency_Pump_cond = 0.9, efficiency_Pump_FW = 0.9, efficiency_Turb_HP = 1, efficiency_Turb_IP1 = 1, efficiency_Turb_IP2 = 1, efficiency_Turb_IP3 = 1, efficiency_Turb_LP1 = 1, efficiency_Turb_LP2 = 1, efficiency_Turb_LP3 = 1, efficiency_Turb_LP4 = 1, efficiency_Pump_preheater_LP1 = 0.9, efficiency_Pump_preheater_LP3 = 0.9, preheater_HP_p_tap = 46e5) annotation(
    Placement(transformation(extent = {{1446, 364}, {1466, 384}})));
  inner ClaRa.SimCenter simCenter(contributeToCycleSummary = true, showExpertSummary = true, redeclare ClaRa.Basics.Media.Slag.Slag_v2 slagModel, redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, redeclare ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v3 fuelModel1(C_cp = {989.167, 1000, 4190}, xi_e_waf = {{0.884524, 0.047619, 0.0404762, 0.0154762}}, C_LHV = {3.30983e7*1.033, 0, -2500e3})) annotation(
    Placement(transformation(extent = {{1478, 380}, {1518, 400}})));
  Modelica.Blocks.Sources.TimeTable PTarget(table = [0, 1; 2500, 1; 2510, 0.7; 4300, 0.7; 4310, 1; 6100, 1; 6110, 0.7; 7900, 0.7; 7910, 1; 10000, 1]) annotation(
    Placement(transformation(extent = {{-476, -406}, {-456, -386}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheater_L4 regenerativeAirPreheater(s_sp = 0.6e-3, redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8, A_flueGas = 0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub), A_air = 0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub), diameter_reg = 10, height_reg = 3, N_sp = 1000, Delta_p_flueGas_nom = 1000, Delta_p_freshAir_nom = 1000, T_start_wall = linspace(385, 675, regenerativeAirPreheater.N_cv), T_start_flueGas = linspace(677, 398, regenerativeAirPreheater.N_cv), T_start_freshAir = linspace(376, 673, regenerativeAirPreheater.N_cv), frictionAtFlueGasOutlet = false, frictionAtFreshAirInlet = false, frictionAtFreshAirOutlet = true, redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4, N_cv = 5, m_flow_freshAir_nom = 475, m_flow_flueGas_nom = 475 + 42, xi_nom_flueGas = NOM.eco.xi_fg_out, xi_start_freshAir = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, xi_nom_freshAir = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, xi_start_flueGas = INIT.eco.xi_fg_out, p_freshAir_nom = 12000, p_flueGas_nom = 10500, p_start_freshAir(each displayUnit = "bar") = linspace(1.35e5, 1.34e5, regenerativeAirPreheater.N_cv), stateLocation = 1, p_start_flueGas(each displayUnit = "bar") = linspace(1e5, 0.99e5, regenerativeAirPreheater.N_cv), frictionAtFlueGasInlet = true) annotation(
    Placement(transformation(extent = {{-392, 14}, {-372, 34}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitGas_L2_flex splitGas_L2_flex(N_ports_out = 4, volume = 2, xi_nom = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, m_flow_out_nom = {475.6/4, 475.6/4, 475.6/4, 475.6/4}, T_start = 673, xi_start = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, T_nom = 1119.15, p_start(displayUnit = "bar") = 133900) annotation(
    Placement(transformation(extent = {{-400, -116}, {-380, -96}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(variable_xi = false, xi_const = {0, 0, 0.0005, 0, 0.7681, 0.2314, 0, 0, 0}, variable_T = false, T_const = 273.15 + 30, m_flow_const = 475.6 + 24, variable_m_flow = true) annotation(
    Placement(transformation(extent = {{-440, 20}, {-420, 40}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y = burner1.lambdaComb_primary) annotation(
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 180, origin = {-556, 66})));
  Modelica.Blocks.Sources.Ramp lambda(duration = 1000, startTime = 4000, height = 0, offset = 1.2) annotation(
    Placement(transformation(extent = {{-566, 26}, {-546, 46}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda(controllerType = Modelica.Blocks.Types.SimpleController.PI, Ni = 0.90, y_min = 100, sign = 1, k = 1, t_activation = 0, Tau_i = 1, y_ref = 475.6 + 24, y_max = 700, y_inactive = 475.6 + 24, y_start = 475.6 + 24, u_ref = 1.2, initOption = 501) annotation(
    Placement(transformation(extent = {{-514, 46}, {-494, 26}})));
  Modelica.Blocks.Math.Gain gain(k = 43/4) annotation(
    Placement(transformation(extent = {{-400, -152}, {-380, -132}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 475.6 + 24) annotation(
    Placement(transformation(extent = {{-478, 26}, {-458, 46}})));
  Visualisation.QuadrupleGas quadrupleGas(value4 = 11) annotation(
    Placement(transformation(extent = {{-82, -146}, {-62, -136}})));
  Visualisation.QuadrupleGas quadrupleGas1(value4 = 11) annotation(
    Placement(transformation(extent = {{-80, -125}, {-60, -115}})));
  Visualisation.QuadrupleGas quadrupleGas2(value4 = 11) annotation(
    Placement(transformation(extent = {{-74, -99}, {-54, -89}})));
  Visualisation.QuadrupleGas quadrupleGas3(value4 = 11) annotation(
    Placement(transformation(extent = {{-72, -73}, {-52, -63}})));
  Visualisation.QuadrupleGas quadrupleGas4(value4 = 11) annotation(
    Placement(transformation(extent = {{-72, -47}, {-52, -37}})));
  Visualisation.QuadrupleGas quadrupleGas5(value4 = 11) annotation(
    Placement(transformation(extent = {{-174, -21}, {-154, -11}})));
  Visualisation.QuadrupleGas quadrupleGas6(value4 = 11) annotation(
    Placement(transformation(extent = {{-176, 5}, {-156, 15}})));
  Visualisation.QuadrupleGas quadrupleGas7(value4 = 11) annotation(
    Placement(transformation(extent = {{-178, 33}, {-158, 43}})));
  Visualisation.QuadrupleGas quadrupleGas8(value4 = 11) annotation(
    Placement(transformation(extent = {{-178, 61}, {-158, 71}})));
  Visualisation.QuadrupleGas quadrupleGas9(value4 = 11) annotation(
    Placement(transformation(extent = {{-176, 89}, {-156, 99}})));
  Visualisation.QuadrupleGas quadrupleGas10(value4 = 11) annotation(
    Placement(transformation(extent = {{-178, 117}, {-158, 127}})));
  Visualisation.QuadrupleGas quadrupleGas11(value4 = 11) annotation(
    Placement(transformation(extent = {{-178, 145}, {-158, 155}})));
  Visualisation.QuadrupleGas quadrupleGas12(value4 = 11) annotation(
    Placement(transformation(extent = {{-182, 186}, {-140, 210}})));
  Visualisation.QuadrupleGas quadrupleGas13(value4 = 11) annotation(
    Placement(transformation(extent = {{-390, -8}, {-370, 2}})));
  Visualisation.QuadrupleGas quadrupleGas14(value4 = 11) annotation(
    Placement(transformation(extent = {{-366, 36}, {-346, 46}})));
  Components.Control.FeedForward.FeedForwardBlock_3508 feedForwardBlock_3508_1 annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-432, -392})));
  Modelica.Blocks.Sources.RealExpression P_max_(y = 1) annotation(
    Placement(transformation(extent = {{-478, -374}, {-458, -354}})));
  Components.Mills.HardCoalMills.RollerBowlMill_L1 rollerBowlMill_L1_1(m_flow_dust_0 = 1) annotation(
    Placement(transformation(extent = {{-390, -407}, {-370, -387}})));
  Modelica.Blocks.Sources.RealExpression P_min_(y = 0.5) annotation(
    Placement(transformation(extent = {{-478, -356}, {-458, -336}})));
  Modelica.Blocks.Sources.RealExpression P_min_1(y = 0.02/60) annotation(
    Placement(transformation(extent = {{-478, -338}, {-458, -318}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 1, T = 100) annotation(
    Placement(transformation(extent = {{-416, -400}, {-408, -392}})));
equation
  totalHeat = burner1.Q_flow_wall + burner2.Q_flow_wall + burner3.Q_flow_wall + burner4.Q_flow_wall + flameRoom_evap_1.Q_flow_wall + flameRoom_evap_2.Q_flow_wall + flameRoom_sh_1.Q_flow_wall + flameRoom_sh_2.Q_flow_wall + flameRoom_sh_4.Q_flow_wall + flameRoom_rh_2.Q_flow_wall;
  connect(burner1.inlet, hopper.outlet) annotation(
    Line(points = {{-134, -164}, {-134, -168}, {-136, -168}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(burner1.heat_bottom, hopper.heat_top) annotation(
    Line(points = {{-116, -164}, {-116, -168}, {-118, -168}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(coalSlagFlueGas_join.fuelSlagFlueGas_outlet, hopper.inlet) annotation(
    Line(points = {{-134, -196}, {-134, -188}, {-136, -188}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(burner1.heat_wall, evap_1_wall.outerPhase[1]) annotation(
    Line(points = {{-88, -154}, {0, -154}, {0, -120}, {102.4, -120}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(burner2.heat_wall, evap_1_wall.outerPhase[2]) annotation(
    Line(points = {{-88, -128}, {0, -128}, {0, -120}, {102.2, -120}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(burner3.heat_wall, evap_1_wall.outerPhase[3]) annotation(
    Line(points = {{-88, -102}, {0, -102}, {0, -120}, {102, -120}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_evap_1.heat_wall, evap_1_wall.outerPhase[5]) annotation(
    Line(points = {{-88, -50}, {0, -50}, {0, -120}, {101.6, -120}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_evap_2.heat_wall, scalar2VectorHeatPort.heatScalar) annotation(
    Line(points = {{-88, -24}, {52, -24}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, evap_2_wall.outerPhase) annotation(
    Line(points = {{72, -24}, {100, -24}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_2.heat_wall, evap_3_wall.outerPhase[4]) annotation(
    Line(points = {{-88, 86}, {0, 86}, {0, 40}, {101.625, 40}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_1.heat_wall, evap_4_wall.outerPhase[2]) annotation(
    Line(points = {{-88, 142}, {8, 142}, {8, 142}, {104, 142}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(scalar2VectorHeatPort13.heatVector, eco_wall.outerPhase) annotation(
    Line(points = {{74, -298}, {89.9998, -298}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(scalar2VectorHeatPort12.heatVector, rh_2_wall.outerPhase) annotation(
    Line(points = {{544, 124}, {570, 124}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_1.heat_TubeBundle, scalar2VectorHeatPort11.heatScalar) annotation(
    Line(points = {{-98, 132}, {84, 132}, {84, -2}, {534, -2}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle, scalar2VectorHeatPort13.heatScalar) annotation(
    Line(points = {{-98, 160}, {-40, 160}, {-40, -298}, {54, -298}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_eco.heat_wall, evap_4_wall.outerPhase[3]) annotation(
    Line(points = {{-88, 170}, {0, 170}, {0, 142}, {103.667, 142}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_2.heat_TubeBundle, scalar2VectorHeatPort12.heatScalar) annotation(
    Line(points = {{-98, 76}, {60, 76}, {60, 124}, {524, 124}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(burner4.heat_wall, evap_1_wall.outerPhase[4]) annotation(
    Line(points = {{-88, -76}, {0, -76}, {0, -120}, {101.8, -120}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector, evap_0_wall.outerPhase) annotation(
    Line(points = {{68, -182}, {80, -182}, {80, -180}, {92.0004, -180}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(hopper.heat_wall, scalar2VectorHeatPort2.heatScalar) annotation(
    Line(points = {{-90, -178}, {-22, -178}, {-22, -182}, {48, -182}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_1.heat_TubeBundle, scalar2VectorHeatPort1.heatScalar) annotation(
    Line(points = {{-98, -8}, {20, -8}, {20, -82}, {304, -82}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_1.heat_wall, evap_3_wall.outerPhase[1]) annotation(
    Line(points = {{-88, 2}, {0, 2}, {0, 40}, {102.375, 40}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_3.heat_TubeBundle, scalar2VectorHeatPort9.heatScalar) annotation(
    Line(points = {{-98, 104}, {306, 104}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_3.heat_wall, evap_4_wall.outerPhase[1]) annotation(
    Line(points = {{-88, 114}, {0, 114}, {0, 142}, {104.333, 142}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_4.heat_TubeBundle, scalar2VectorHeatPort10.heatScalar) annotation(
    Line(points = {{-98, 48}, {40, 48}, {40, 216}, {302, 216}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_4.heat_wall, evap_3_wall.outerPhase[3]) annotation(
    Line(points = {{-88, 58}, {0, 58}, {0, 40}, {101.875, 40}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_2.heat_TubeBundle, scalar2VectorHeatPort8.heatScalar) annotation(
    Line(points = {{-98, 20}, {308, 20}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_2.heat_wall, evap_3_wall.outerPhase[2]) annotation(
    Line(points = {{-88, 30}, {0, 30}, {0, 40}, {102.125, 40}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes, ct_1_wall.outerPhase[1]) annotation(
    Line(points = {{-98, 180}, {20, 180}, {20, 78}, {204.429, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_1.heat_CarrierTubes, ct_1_wall.outerPhase[2]) annotation(
    Line(points = {{-98, 152}, {20, 152}, {20, 78}, {204.286, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_3.heat_CarrierTubes, ct_1_wall.outerPhase[3]) annotation(
    Line(points = {{-98, 124}, {20, 124}, {20, 78}, {204.143, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_rh_2.heat_CarrierTubes, ct_1_wall.outerPhase[4]) annotation(
    Line(points = {{-98, 96}, {20, 96}, {20, 78}, {204, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_4.heat_CarrierTubes, ct_1_wall.outerPhase[5]) annotation(
    Line(points = {{-98, 68}, {20, 68}, {20, 78}, {203.857, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(flameRoom_sh_2.heat_CarrierTubes, ct_1_wall.outerPhase[6]) annotation(
    Line(points = {{-98, 40}, {20, 40}, {20, 78}, {203.714, 78}}, color = {167, 25, 48}, thickness = 0.5, smooth = Smooth.None));
  connect(coalGas_join_burner4.fuelFlueGas_outlet, mill4.inlet) annotation(
    Line(points = {{-184, -76}, {-178, -76}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(mill4.outlet, burner4.fuelFlueGas_inlet) annotation(
    Line(points = {{-158, -76}, {-148, -76}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(coalGas_join_burner3.fuelFlueGas_outlet, mill3.inlet) annotation(
    Line(points = {{-184, -102}, {-178, -102}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(mill3.outlet, burner3.fuelFlueGas_inlet) annotation(
    Line(points = {{-158, -102}, {-148, -102}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, mill2.inlet) annotation(
    Line(points = {{-184, -128}, {-178, -128}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(mill2.outlet, burner2.fuelFlueGas_inlet) annotation(
    Line(points = {{-158, -128}, {-154, -128}, {-154, -128}, {-148, -128}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(coalGas_join_burner1.fuelFlueGas_outlet, mill1.inlet) annotation(
    Line(points = {{-184, -154}, {-178, -154}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(mill1.outlet, burner1.fuelFlueGas_inlet) annotation(
    Line(points = {{-158, -154}, {-148, -154}}, color = {118, 106, 98}, thickness = 0.5, smooth = Smooth.None));
  connect(ramp2.y, mill4.classifierSpeed) annotation(
    Line(points = {{-197, -50}, {-180, -50}, {-180, -58}, {-168, -58}, {-168, -65.2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(ramp2.y, mill3.classifierSpeed) annotation(
    Line(points = {{-197, -50}, {-180, -50}, {-180, -88}, {-168, -88}, {-168, -91.2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(ramp2.y, mill2.classifierSpeed) annotation(
    Line(points = {{-197, -50}, {-180, -50}, {-180, -116}, {-168, -116}, {-168, -117.2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(ramp2.y, mill1.classifierSpeed) annotation(
    Line(points = {{-197, -50}, {-180, -50}, {-180, -140}, {-168, -140}, {-168, -143.2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(hopper.heat_bottom, boilerLosses.port) annotation(
    Line(points = {{-118, -188}, {-118, -200}, {-100, -200}}, color = {167, 25, 48}, thickness = 0.5));
  connect(coalFlowSource_bottom.fuel_a, coalSlagFlueGas_join.fuel_inlet) annotation(
    Line(points = {{-158, -234}, {-158, -222}, {-140, -222}, {-140, -216}}, color = {27, 36, 42}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(slaglSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet) annotation(
    Line(points = {{-133.8, -234}, {-134, -234}, {-134, -216}}, color = {234, 171, 0}, thickness = 0.5));
  connect(fluelGasFlowSource_bottom.gas_a, coalSlagFlueGas_join.flueGas_inlet) annotation(
    Line(points = {{-108, -234}, {-108, -222}, {-128, -222}, {-128, -216}}, color = {118, 106, 98}, thickness = 0.5));
  connect(coalFlowSource_burner4.fuel_a, coalGas_join_burner4.fuel_inlet) annotation(
    Line(points = {{-224, -70}, {-204, -70}}, color = {27, 36, 42}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(coalFlowSource_burner3.fuel_a, coalGas_join_burner3.fuel_inlet) annotation(
    Line(points = {{-224, -96}, {-204, -96}}, color = {27, 36, 42}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(coalFlowSource_burner2.fuel_a, coalGas_join_burner2.fuel_inlet) annotation(
    Line(points = {{-224, -122}, {-204, -122}}, color = {27, 36, 42}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(coalFlowSource_burner1.fuel_a, coalGas_join_burner1.fuel_inlet) annotation(
    Line(points = {{-224, -148}, {-204, -148}}, color = {27, 36, 42}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(coalSlagFlueGas_split_top.fuelSlagFlueGas_inlet, flameRoom_eco.outlet) annotation(
    Line(points = {{-134, 212}, {-134, 180}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_eco.inlet, flameRoom_rh_1.outlet) annotation(
    Line(points = {{-134, 160}, {-134, 152}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_eco.heat_bottom, flameRoom_rh_1.heat_top) annotation(
    Line(points = {{-116, 160}, {-116, 152}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_evap_1.outlet, flameRoom_evap_2.inlet) annotation(
    Line(points = {{-134, -40}, {-134, -34}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_evap_1.heat_top, flameRoom_evap_2.heat_bottom) annotation(
    Line(points = {{-116, -40}, {-116, -34}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_evap_2.outlet, flameRoom_sh_1.inlet) annotation(
    Line(points = {{-134, -14}, {-134, -12}, {-134, -8}, {-134, -8}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_evap_2.heat_top, flameRoom_sh_1.heat_bottom) annotation(
    Line(points = {{-116, -14}, {-116, -8}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_sh_1.heat_top, flameRoom_sh_2.heat_bottom) annotation(
    Line(points = {{-116, 12}, {-116, 20}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_sh_1.outlet, flameRoom_sh_2.inlet) annotation(
    Line(points = {{-134, 12}, {-134, 16}, {-134, 16}, {-134, 20}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_sh_2.outlet, flameRoom_sh_4.inlet) annotation(
    Line(points = {{-134, 40}, {-134, 48}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_sh_2.heat_top, flameRoom_sh_4.heat_bottom) annotation(
    Line(points = {{-116, 40}, {-116, 48}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_sh_4.outlet, flameRoom_rh_2.inlet) annotation(
    Line(points = {{-134, 68}, {-134, 76}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_sh_4.heat_top, flameRoom_rh_2.heat_bottom) annotation(
    Line(points = {{-116, 68}, {-116, 76}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_rh_2.heat_top, flameRoom_sh_3.heat_bottom) annotation(
    Line(points = {{-116, 96}, {-116, 104}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_rh_2.outlet, flameRoom_sh_3.inlet) annotation(
    Line(points = {{-134, 96}, {-134, 104}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_sh_3.outlet, flameRoom_rh_1.inlet) annotation(
    Line(points = {{-134, 124}, {-134, 132}}, color = {118, 106, 98}, thickness = 0.5));
  connect(flameRoom_sh_3.heat_top, flameRoom_rh_1.heat_bottom) annotation(
    Line(points = {{-116, 124}, {-116, 132}}, color = {167, 25, 48}, thickness = 0.5));
  connect(flameRoom_eco.heat_top, fixedTemperature5.port) annotation(
    Line(points = {{-116, 180}, {-116, 206}, {-94, 206}}, color = {167, 25, 48}, thickness = 0.5));
  connect(burner1.outlet, burner2.inlet) annotation(
    Line(points = {{-134, -144}, {-134, -138}}, color = {118, 106, 98}, thickness = 0.5));
  connect(burner1.heat_top, burner2.heat_bottom) annotation(
    Line(points = {{-116, -144}, {-116, -138}}, color = {167, 25, 48}, thickness = 0.5));
  connect(burner2.outlet, burner3.inlet) annotation(
    Line(points = {{-134, -118}, {-134, -112}}, color = {118, 106, 98}, thickness = 0.5));
  connect(burner2.heat_top, burner3.heat_bottom) annotation(
    Line(points = {{-116, -118}, {-116, -112}}, color = {167, 25, 48}, thickness = 0.5));
  connect(burner3.outlet, burner4.inlet) annotation(
    Line(points = {{-134, -92}, {-134, -86}}, color = {118, 106, 98}, thickness = 0.5));
  connect(burner3.heat_top, burner4.heat_bottom) annotation(
    Line(points = {{-116, -92}, {-116, -86}}, color = {167, 25, 48}, thickness = 0.5));
  connect(burner4.outlet, flameRoom_evap_1.inlet) annotation(
    Line(points = {{-134, -66}, {-134, -60}}, color = {118, 106, 98}, thickness = 0.5));
  connect(burner4.heat_top, flameRoom_evap_1.heat_bottom) annotation(
    Line(points = {{-116, -66}, {-116, -60}}, color = {167, 25, 48}, thickness = 0.5));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_inlet) annotation(
    Line(points = {{-182, 248}, {-134, 248}, {-134, 232}}, color = {234, 171, 0}, pattern = LinePattern.Solid, thickness = 0.5));
  connect(coalSink_top.fuel_a, coalSlagFlueGas_split_top.fuel_outlet) annotation(
    Line(points = {{-156, 236}, {-140, 236}, {-140, 232}}, color = {27, 36, 42}, thickness = 0.5));
  connect(flameRoom_sh_1.heat_CarrierTubes, ct_1_wall.outerPhase[7]) annotation(
    Line(points = {{-98, 12}, {20, 12}, {20, 78}, {203.571, 78}}, color = {167, 25, 48}, thickness = 0.5));
  connect(regenerativeAirPreheater.freshAirOutlet, splitGas_L2_flex.inlet) annotation(
    Line(points = {{-392, 18}, {-406, 18}, {-406, -106}, {-400, -106}}, color = {118, 106, 98}, thickness = 0.5));
  connect(fluelGasFlowSource_burner1.gas_a, regenerativeAirPreheater.freshAirInlet) annotation(
    Line(points = {{-420, 30}, {-392, 30}}, color = {118, 106, 98}, thickness = 0.5));
  connect(regenerativeAirPreheater.flueGasOutlet, flueGasPressureSink_top.gas_a) annotation(
    Line(points = {{-372, 30}, {-328, 30}, {-328, 48}}, color = {118, 106, 98}, thickness = 0.5));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_outlet) annotation(
    Line(points = {{-372, 18}, {-290, 18}, {-290, 276}, {-128, 276}, {-128, 232}}, color = {118, 106, 98}, thickness = 0.5));
  connect(PID_lambda.u_m, actual_lambda.y) annotation(
    Line(points = {{-503.9, 48}, {-503.9, 66}, {-545, 66}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(lambda.y, PID_lambda.u_s) annotation(
    Line(points = {{-545, 36}, {-516, 36}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.y, coalFlowSource_burner2.m_flow) annotation(
    Line(points = {{-379, -142}, {-344, -142}, {-344, -116}, {-244, -116}}, color = {0, 0, 127}));
  connect(gain.y, coalFlowSource_burner1.m_flow) annotation(
    Line(points = {{-379, -142}, {-244, -142}}, color = {0, 0, 127}));
  connect(gain.y, coalFlowSource_burner3.m_flow) annotation(
    Line(points = {{-379, -142}, {-344, -142}, {-344, -90}, {-244, -90}}, color = {0, 0, 127}));
  connect(gain.y, coalFlowSource_burner4.m_flow) annotation(
    Line(points = {{-379, -142}, {-344, -142}, {-344, -64}, {-244, -64}}, color = {0, 0, 127}));
  connect(splitGas_L2_flex.outlet[1], coalGas_join_burner4.flueGas_inlet) annotation(
    Line(points = {{-380, -106.375}, {-376, -106.375}, {-376, -82}, {-204, -82}}, color = {118, 106, 98}, thickness = 0.5));
  connect(splitGas_L2_flex.outlet[2], coalGas_join_burner3.flueGas_inlet) annotation(
    Line(points = {{-380, -106.125}, {-376, -106.125}, {-376, -108}, {-204, -108}}, color = {118, 106, 98}, thickness = 0.5));
  connect(splitGas_L2_flex.outlet[3], coalGas_join_burner2.flueGas_inlet) annotation(
    Line(points = {{-380, -105.875}, {-376, -105.875}, {-376, -134}, {-204, -134}}, color = {118, 106, 98}, thickness = 0.5));
  connect(splitGas_L2_flex.outlet[4], coalGas_join_burner1.flueGas_inlet) annotation(
    Line(points = {{-380, -105.625}, {-376, -105.625}, {-376, -160}, {-204, -160}}, color = {118, 106, 98}, thickness = 0.5));
  connect(PID_lambda.y, firstOrder.u) annotation(
    Line(points = {{-493, 36}, {-480, 36}}, color = {0, 0, 127}));
  connect(firstOrder.y, fluelGasFlowSource_burner1.m_flow) annotation(
    Line(points = {{-457, 36}, {-440, 36}}, color = {0, 0, 127}));
  connect(scalar2VectorHeatPort11.heatVector, rh_1_wall.outerPhase) annotation(
    Line(points = {{554, -2}, {572, -2}}, color = {167, 25, 48}, thickness = 0.5));
  connect(scalar2VectorHeatPort1.heatVector, sh_1_wall.outerPhase) annotation(
    Line(points = {{324, -82}, {358, -82}}, color = {167, 25, 48}, thickness = 0.5));
  connect(scalar2VectorHeatPort8.heatVector, sh_2_wall.outerPhase) annotation(
    Line(points = {{328, 20}, {348, 20}}, color = {167, 25, 48}, thickness = 0.5));
  connect(scalar2VectorHeatPort9.heatVector, sh_3_wall.outerPhase) annotation(
    Line(points = {{326, 104}, {348, 104}}, color = {167, 25, 48}, thickness = 0.5));
  connect(scalar2VectorHeatPort10.heatVector, sh_4_wall.outerPhase) annotation(
    Line(points = {{322, 216}, {341, 216}}, color = {167, 25, 48}, thickness = 0.5));
  connect(burner1.eyeOut, quadrupleGas.eye) annotation(
    Line(points = {{-148, -146}, {-152, -146}, {-152, -141}, {-82, -141}}, color = {190, 190, 190}));
  connect(quadrupleGas6.eye, flameRoom_sh_1.eyeOut) annotation(
    Line(points = {{-176, 10}, {-148, 10}}, color = {190, 190, 190}));
  connect(quadrupleGas5.eye, flameRoom_evap_2.eyeOut) annotation(
    Line(points = {{-174, -16}, {-148, -16}}, color = {190, 190, 190}));
  connect(quadrupleGas4.eye, flameRoom_evap_1.eyeOut) annotation(
    Line(points = {{-72, -42}, {-148, -42}}, color = {190, 190, 190}));
  connect(quadrupleGas3.eye, burner4.eyeOut) annotation(
    Line(points = {{-72, -68}, {-148, -68}}, color = {190, 190, 190}));
  connect(quadrupleGas2.eye, burner3.eyeOut) annotation(
    Line(points = {{-74, -94}, {-148, -94}}, color = {190, 190, 190}));
  connect(quadrupleGas1.eye, burner2.eyeOut) annotation(
    Line(points = {{-80, -120}, {-148, -120}}, color = {190, 190, 190}));
  connect(quadrupleGas12.eye, flameRoom_eco.eyeOut) annotation(
    Line(points = {{-182, 198}, {-182, 198}, {-182, 178}, {-166, 178}, {-166, 178}, {-148, 178}}, color = {190, 190, 190}));
  connect(quadrupleGas11.eye, flameRoom_rh_1.eyeOut) annotation(
    Line(points = {{-178, 150}, {-148, 150}}, color = {190, 190, 190}));
  connect(quadrupleGas10.eye, flameRoom_sh_3.eyeOut) annotation(
    Line(points = {{-178, 122}, {-148, 122}}, color = {190, 190, 190}));
  connect(quadrupleGas9.eye, flameRoom_rh_2.eyeOut) annotation(
    Line(points = {{-176, 94}, {-148, 94}}, color = {190, 190, 190}));
  connect(quadrupleGas8.eye, flameRoom_sh_4.eyeOut) annotation(
    Line(points = {{-178, 66}, {-148, 66}}, color = {190, 190, 190}));
  connect(quadrupleGas7.eye, flameRoom_sh_2.eyeOut) annotation(
    Line(points = {{-178, 38}, {-148, 38}}, color = {190, 190, 190}));
  connect(quadrupleGas13.eye, regenerativeAirPreheater.eye_freshAir) annotation(
    Line(points = {{-390, -3}, {-392, -3}, {-392, 8}, {-392.2, 8}, {-392.2, 15.4}}, color = {190, 190, 190}));
  connect(regenerativeAirPreheater.eye_flueGas, quadrupleGas14.eye) annotation(
    Line(points = {{-371.8, 32.6}, {-371.8, 37.3}, {-366, 37.3}, {-366, 41}}, color = {190, 190, 190}));
  connect(PTarget.y, feedForwardBlock_3508_1.P_G_target_) annotation(
    Line(points = {{-455, -396}, {-444, -396}}, color = {0, 0, 127}));
  connect(feedForwardBlock_3508_1.P_max_, P_max_.y) annotation(
    Line(points = {{-440, -380}, {-440, -364}, {-457, -364}}, color = {0, 0, 127}));
  connect(feedForwardBlock_3508_1.P_min_, P_min_.y) annotation(
    Line(points = {{-436, -380}, {-436, -346}, {-457, -346}}, color = {0, 0, 127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_max_) annotation(
    Line(points = {{-457, -328}, {-432, -328}, {-432, -380}}, color = {0, 0, 127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_StG_) annotation(
    Line(points = {{-457, -328}, {-428, -328}, {-428, -380}}, color = {0, 0, 127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_T_) annotation(
    Line(points = {{-457, -328}, {-424, -328}, {-424, -380}}, color = {0, 0, 127}));
  connect(feedForwardBlock_3508_1.QF_FF_, firstOrder1.u) annotation(
    Line(points = {{-421, -396}, {-416.8, -396}}, color = {0, 0, 127}));
  connect(firstOrder1.y, rollerBowlMill_L1_1.rawCoal) annotation(
    Line(points = {{-407.6, -396}, {-390.8, -396}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain.u) annotation(
    Line(points = {{-407.6, -396}, {-406, -396}, {-406, -142}, {-402, -142}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-580, -480}, {1540, 460}}), graphics = {Rectangle(extent = {{1478, 440}, {1520, 360}}, lineColor = {175, 175, 175}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Sphere), Rectangle(extent = {{1438, 440}, {1478, 360}}, lineColor = {175, 175, 175}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Sphere), Text(extent = {{1442, 442}, {1470, 422}}, lineColor = {75, 75, 75}, fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, textStyle = {TextStyle.Bold}, textString = "CycleINIT"), Text(extent = {{1436, 402}, {1476, 382}}, lineColor = {75, 75, 75}, fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, textStyle = {TextStyle.Bold}, textString = "CycleSettings"), Text(extent = {{1480, 422}, {1514, 404}}, lineColor = {75, 75, 75}, fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, textStyle = {TextStyle.Bold}, textString = "Model
Properties"), Text(extent = {{-578, 436}, {-382, 372}}, lineColor = {115, 150, 0}, horizontalAlignment = TextAlignment.Left, fontSize = 5, textString = "______________________________________________________________________________________________
PURPOSE:
Example of a steam cycle of a 580 MW hard coal power plant. It has a single reheat, one HP preheater and four LP preheaters.
This model uses the same steam cycle as in example SteamCycle_01 but a more complex boiler model which features gas and particle radiation.
Initial and nominal values are computed with help of the static cycle package. 
Levels of preheaters and condenser are controlled by simple PI-controllers, the heating power and feedwater pump power is set by a feed forward block.
Models provide information for automatic efficiency calculation within SimCenter-model.
______________________________________________________________________________________________
    "), Text(extent = {{-578, 342}, {-378, 324}}, lineColor = {115, 150, 0}, horizontalAlignment = TextAlignment.Left, fontSize = 5, textString = "______________________________________________________________________________________________
Scenario:  
Two successive load reductions to 70 percent load at t=2500s and t=6100s with a length of 30 minutes each.
______________________________________________________________________________________________
    ")}),
    experiment(StopTime = 600, __Dymola_NumberOfIntervals = 1000, Tolerance = 1e-05, __Dymola_Algorithm = "Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio = true, initialScale = 0.1)),
    __Dymola_experimentFlags(Hidden(SmallerDAEIncidence = false)));
end SteamPowerPlant_01_OM_furnace;
