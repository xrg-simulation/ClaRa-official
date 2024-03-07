within ClaRa.Examples;
model SteamPowerPlant_01_OM_furnaceSteam
  "A steam power plant model based on SteamCycle_02 with a detailed boiler model (coal dust fired Benson boiler) without controls"
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
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Real alpha_wall= 15;
  parameter Real emissivity_wall = 0.75;
  parameter Real CF_fouling_glob = 0.8;
  parameter Real CF_fouling_rad_glob = 0.78;
  //Real P_gen_act = electricalPower.x1/633;
  ClaRa.Basics.Units.HeatFlowRate totalHeat;
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner3(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-106},{-224,-86}})));

  ClaRa.Components.Adapters.FuelSlagFlueGas_split             coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,222})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-192,248})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink_top(T_const=658.15, xi_const={0.84,0.07})             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-166,236})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(                T_const=658.15,
    xi_const={0.00488,0.00013,0.21147,0.00155,0.70952,0.03784,0,0.00347,0},
    p_const(displayUnit="bar") = 99000)                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-328,58})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner1(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-158},{-224,-138}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-154})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner2(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-132},{-224,-112}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-128})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner1(
    T_slag=600 + 273.15,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_out={18.5},
        z_in={11.318},
        height=abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]),
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_top_initial=INIT.brnr2.T_fg_out,
    T_start_flueGas_out=INIT.brnr1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=136,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 101000)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-154})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner2(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_in={burner1.geo.z_out[1]},
        z_out={24},
        height=burner2.geo.z_out[1] - burner2.geo.z_in[1],
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.1,
    T_start_flueGas_out=INIT.brnr2.T_fg_out,
    T_top_initial=INIT.brnr3.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=274,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100950)                                   annotation (Placement(transformation(
        extent={{-30,-10.0001},{30,10}},
        rotation=0,
        origin={-118,-128})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner3(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_in={burner2.geo.z_out[1]},
        z_out={29.5},
        height=burner3.geo.z_out[1] - burner3.geo.z_in[1],
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr3.T_fg_out,
    T_top_initial=INIT.brnr4.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=412,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100900)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-102})));

  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-102})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_1(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_in={burner4.geo.z_out[1]},
        z_out={41.334},
        height=flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1],
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (w_initial=15),
    Tau=0.01,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out - 50,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65,
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100800) annotation (Placement(transformation(extent={{-148,-60},{-88,-40}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_2(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    Tau=0.01,
    T_start_flueGas_out=INIT.rh2.T_fg_out - 260,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        temperatureDifference="Logarithmic mean - smoothed",
        suspension_calculationType="Calculated",
        CF_fouling=0.9),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_4.geo.z_out[1]},
        z_out={71.45},
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_rh_2.geo.z_out[1] - flameRoom_rh_2.geo.z_in[1],
        length=14.576,
        diameter_t=0.051,
        N_tubes=800,
        N_passes=2,
        N_rows=32),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100400)                                                    annotation (Placement(transformation(extent={{-148,76},{-88,96}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature5(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-84,206})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner4(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_in={burner3.geo.z_out[1]},
        z_out={35},
        height=burner4.geo.z_out[1] - burner4.geo.z_in[1],
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr4.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100850)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-76})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner4(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-80},{-224,-60}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-76})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,-206})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_bottom(
    m_flow_const=6.5,
    T_const=283.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_m_flow=false)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-108,-244})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom(
    m_flow_const=0,
    T_const=293.15,
    variable_m_flow=false,
    xi_const={0.84,0.07})
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-158,-244})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slaglSink_bottom(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,-244})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow      boilerLosses(Q_flow(displayUnit="MW") = 0)
                                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,-200})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_2(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        z_in={flameRoom_evap_1.geo.z_out[1]},
        z_out={56.342},
        height=flameRoom_evap_2.geo.z_out[1] - flameRoom_evap_2.geo.z_in[1],
        length=14.576),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (w_initial=15),
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    Tau=0.01,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out - 50,
    T_top_initial=INIT.sh1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65,
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100750)                                   annotation (Placement(transformation(extent={{-148,-34},{-88,-14}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_1(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh1.T_fg_out - 100,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_evap_2.geo.z_out[1]},
        z_out={59.36},
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_1.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_1_wall.diameter_o,
        N_tubes=300,
        N_passes=1),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        suspension_calculationType="Calculated",
        temperatureDifference="Logarithmic mean - smoothed",
        CF_fouling=0.55),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100700)                                                    annotation (Placement(transformation(extent={{-148,-8},{-88,12}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_2(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh2.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_1.geo.z_out[1]},
        z_out={63.91},
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_2.geo.z_out[1] - flameRoom_sh_2.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_2_wall.diameter_o,
        N_tubes=250,
        N_passes=2),
    redeclare model HeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                      suspension_calculationType="Calculated", CF_fouling=0.55),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100600)                                   annotation (Placement(transformation(extent={{-148,20},{-88,40}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_4(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh4.T_fg_out - 250,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_2.geo.z_out[1]},
        z_out={67.89},
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_4.geo.z_out[1] - flameRoom_sh_4.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_4_wall.diameter_o,
        N_tubes=530,
        N_passes=2),
    redeclare model HeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                      suspension_calculationType="Calculated", CF_fouling=0.6),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100500)                                                    annotation (Placement(transformation(extent={{-148,48},{-88,68}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_3(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh3.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_rh_2.geo.z_out[1]},
        z_out={75.18},
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_3.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_3_wall.diameter_o,
        N_tubes=500,
        N_passes=2),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        temperatureDifference="Logarithmic mean - smoothed",
        suspension_calculationType="Calculated",
        CF_fouling=0.65),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100300)                                                   annotation (Placement(transformation(extent={{-148,104},{-88,124}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_1(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    T_start_flueGas_out=INIT.rh1.T_fg_out,
    Tau=0.01,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_3.geo.z_out[1]},
        z_out={82.9},
        width=14.576,
        tubeOrientation=0,
        diameter_t=rh_1_wall.diameter_o,
        height=flameRoom_rh_1.geo.z_out[1] - flameRoom_rh_1.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_tubes=420,
        N_passes=6,
        N_rows=50),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100200)                                    annotation (Placement(transformation(extent={{-148,132},{-88,152}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_eco(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    T_start_flueGas_out=INIT.eco.T_fg_out,
    Tau=0.01,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Inlet"),
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        temperatureDifference="Inlet",
        CF_fouling=CF_fouling_glob,
        alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_rh_1.geo.z_out[1]},
        z_out={85.6},
        width=14.576,
        diameter_t=eco_wall.diameter_o,
        height=flameRoom_eco.geo.z_out[1] - flameRoom_eco.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_tubes=250,
        N_passes=6,
        N_rows=30,
        tubeOrientation=0),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100100)                                   annotation (Placement(transformation(extent={{-148,160},{-88,180}})));

  ClaRa.Components.Furnace.Hopper.Hopper_L2 hopper(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=14.576,
        length=14.576,
        height=abs(hopper.geo.z_out[1] - hopper.geo.z_in[1]),
        z_out={burner1.geo.z_in[1]},
        z_in={4.03}),
    T_slag=600 + 273.15,
    m_flow_nom=1000,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr4.T_fg_out - 500,
    T_top_initial=INIT.brnr1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=CF_fouling_rad_glob),
    p_start_flueGas_out(displayUnit="bar") = 100980)
                         annotation (Placement(transformation(extent={{-150,-188},{-90,-168}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_1_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    length=flameRoom_evap_1.geo.z_out[1] - burner1.geo.z_in[1],
    diameter_i=0.0268,
    diameter_o=0.038,
    N_tubes=330,
    suppressChattering="False",
    Delta_x={abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]),abs(burner2.geo.z_out[1] - burner2.geo.z_in[1]),abs(burner3.geo.z_out[1] - burner3.geo.z_in[1]),abs(burner4.geo.z_out[1] - burner4.geo.z_in[1]),abs(flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1])},
    T_start={INIT.brnr1.T_vle_wall_out,INIT.brnr2.T_vle_wall_out,INIT.brnr3.T_vle_wall_out,INIT.brnr4.T_vle_wall_out,INIT.evap_rad.T_vle_wall_out},
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99995},{13.9998,4.99995}},
        rotation=90,
        origin={107,-120})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_2_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        46,
        4),
    diameter_i=0.0298,
    length=46,
    N_tubes=330,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        (INIT.brnr4.T_vle_wall_out + INIT.evap_rad.T_vle_wall_out)/2,
        INIT.evap_rad.T_vle_wall_out,
        4),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99996},{14,4.99998}},
        rotation=90,
        origin={105,-24})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(
    N=4,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{52,-34},{72,-14}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_3_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=4,
    diameter_i=0.0206,
    length=flameRoom_rh_2.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1],
    N_tubes=970,
    diameter_o=0.0318,
    suppressChattering="False",
    Delta_x={flameRoom_sh_1.geo.height,flameRoom_sh_2.geo.height,flameRoom_sh_4.geo.height,flameRoom_rh_2.geo.height},
    T_start={INIT.sh1.T_vle_wall_out,INIT.sh2.T_vle_wall_out,INIT.sh4.T_vle_wall_out,INIT.rh2.T_vle_wall_out},
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={107,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_4_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=3,
    diameter_o=0.0424,
    diameter_i=0.0298,
    N_tubes=500,
    suppressChattering="False",
    T_start={INIT.sh3.T_vle_wall_out,INIT.rh1.T_vle_wall_out,INIT.eco.T_vle_wall_out},
    stateLocation=2,
    length=flameRoom_eco.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1]*1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_4_wall.length,
        3),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99998},{13.9999,4.99998}},
        rotation=90,
        origin={109,142})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_1_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        12,
        5),
    diameter_i=0.0269,
    N_tubes=300,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh1.T_vle_bundle_in,
        INIT.sh1.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=12*1,
    diameter_o=0.0345,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={349,-82})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{304,-92},{324,-72}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_2_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_i=0.0269,
    N_tubes=250,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh2.T_vle_bundle_in,
        INIT.sh2.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15*2,
    diameter_o=0.0345,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={353,20})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort8(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{308,10},{328,30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_3_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_i=0.0268,
    N_tubes=500,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh3.T_vle_bundle_in,
        INIT.sh3.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15*2,
    diameter_o=0.0300,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={353,104})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort9(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{306,94},{326,114}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_4_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_i=0.0238,
    N_tubes=530,
    diameter_o=0.038,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh4.T_vle_bundle_in,
        INIT.sh4.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15*2,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={346,216})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort10(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{302,206},{322,226}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_i=0.0334,
    N_tubes=250,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        INIT.eco.T_vle_bundle_in,
        INIT.eco.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15*6,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.0001},{14,5.0001}},
        rotation=90,
        origin={94.9999,-298})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort13(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{54,-308},{74,-288}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_1_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_o=0.051,
    diameter_i=0.0413,
    N_tubes=420,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh1.T_vle_bundle_in,
        INIT.rh1.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15.3*6,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.00007},{14,5.00007}},
        rotation=90,
        origin={577,-2})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort11(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{534,-12},{554,8}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_2_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=5,
    diameter_o=0.051,
    diameter_i=0.0397,
    N_tubes=800,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh2.T_vle_bundle_in,
        INIT.rh2.T_vle_bundle_out,
        5),
    stateLocation=2,
    length=15*2,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2_wall.length,
        5),
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99997},{13.9999,4.99993}},
        rotation=90,
        origin={575,124})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort12(N=5,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{524,114},{544,134}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_0_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    diameter_o=0.038,
    N_ax=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        hopper.geo.z_out[1] - hopper.geo.z_in[1],
        4),
    diameter_i=0.0268,
    length=hopper.geo.z_out[1] - hopper.geo.z_in[1],
    N_tubes=970,
    suppressChattering="False",
    T_start=ones(4)*(INIT.brnr1.T_vle_wall_in),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99981},{14,4.99977}},
        rotation=90,
        origin={97.0002,-180})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(N=4,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{48,-192},{68,-172}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 ct_1_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=7,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        32,
        7),
    diameter_i=0.027,
    N_tubes=310,
    diameter_o=0.0445,
    suppressChattering="False",
    T_start=linspace(
        INIT.ct.T_vle_wall_in,
        INIT.ct.T_vle_wall_out,
        7),
    stateLocation=2,
    length=32*1,
    initOption=213) annotation (Placement(transformation(
        extent={{14,-4.99999},{-14,5}},
        rotation=90,
        origin={209,78})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill4(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0, applyGrindingDelay = true)                                                              annotation (Placement(transformation(extent={{-178,-86},{-158,-66}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill1(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0, applyGrindingDelay = true)                                                              annotation (Placement(transformation(extent={{-178,-164},{-158,-144}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill2(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0, applyGrindingDelay = true)                                                              annotation (Placement(transformation(extent={{-178,-138},{-158,-118}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill3(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0, applyGrindingDelay = true)                                                              annotation (Placement(transformation(extent={{-178,-112},{-158,-92}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    offset=1.50,
    startTime=1500,
    height=-0.0)
    annotation (Placement(transformation(extent={{-218,-60},{-198,-40}})));

  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 INIT(
    P_target_=1,
    p_condenser=NOM.p_condenser,
    preheater_HP_p_tap=NOM.preheater_HP_p_tap,
    preheater_HP_m_flow_tap=NOM.preheater_HP_m_flow_tap,
    preheater_LP1_p_tap=NOM.preheater_LP1_p_tap,
    preheater_LP1_m_flow_tap=NOM.preheater_LP1_m_flow_tap,
    p_FWT=NOM.p_FWT,
    valve_LP1_Delta_p_nom=NOM.valve_LP1_Delta_p_nom,
    valve_LP2_Delta_p_nom=NOM.valve_LP2_Delta_p_nom,
    T_LS_nom=NOM.T_LS_nom,
    T_RS_nom=NOM.T_RS_nom,
    p_LS_out_nom=NOM.p_LS_out_nom,
    p_RS_out_nom=NOM.p_RS_out_nom,
    Delta_p_LS_nom=NOM.Delta_p_LS_nom,
    Delta_p_RS_nom=NOM.Delta_p_RS_nom,
    CharLine_Delta_p_HP_mLS_=NOM.CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=NOM.CharLine_Delta_p_IP_mRS_,
    efficiency_Pump_cond=NOM.efficiency_Pump_cond,
    efficiency_Pump_preheater_LP1=NOM.efficiency_Pump_preheater_LP1,
    efficiency_Pump_FW=NOM.efficiency_Pump_FW,
    efficiency_Turb_HP=NOM.efficiency_Turb_HP,
    efficiency_Turb_LP1=NOM.efficiency_Turb_LP1,
    efficiency_Turb_LP2=NOM.efficiency_Turb_LP2,
    m_flow_nom=NOM.m_flow_nom,
    IP3_pressure(displayUnit="kPa"),
    efficiency_Turb_IP1=NOM.efficiency_Turb_IP1,
    efficiency_Turb_IP2=NOM.efficiency_Turb_IP2,
    efficiency_Turb_IP3=NOM.efficiency_Turb_IP3,
    efficiency_Turb_LP3=NOM.efficiency_Turb_LP3,
    efficiency_Turb_LP4=NOM.efficiency_Turb_LP4) annotation (Placement(transformation(extent={{1446,402},{1466,422}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 NOM(
    final P_target_=1,
    Delta_p_RS_nom=4.91e5,
    efficiency_Pump_cond=0.9,
    efficiency_Pump_FW=0.9,
    efficiency_Turb_HP=1,
    efficiency_Turb_IP1=1,
    efficiency_Turb_IP2=1,
    efficiency_Turb_IP3=1,
    efficiency_Turb_LP1=1,
    efficiency_Turb_LP2=1,
    efficiency_Turb_LP3=1,
    efficiency_Turb_LP4=1,
    efficiency_Pump_preheater_LP1=0.9,
    efficiency_Pump_preheater_LP3=0.9,
    preheater_HP_p_tap=46e5) annotation (Placement(transformation(extent={{1446,364},{1466,384}})));
  inner ClaRa.SimCenter simCenter(
    contributeToCycleSummary=true,
    showExpertSummary=true,
    redeclare ClaRa.Basics.Media.Slag.Slag_v2 slagModel,
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    redeclare ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v3 fuelModel1(
      C_cp={989.167,1000,4190},
      xi_e_waf={{0.884524,0.047619,0.0404762,0.0154762}},
      C_LHV={3.30983e7*1.033,0,-2500e3}))                         annotation (Placement(transformation(extent={{1478,380},{1518,400}})));
  Modelica.Blocks.Sources.TimeTable PTarget(table=[0,1; 2500,1; 2510,0.7; 4300,0.7; 4310,1; 6100,1; 6110,0.7; 7900,0.7; 7910,1; 10000,1])
                                                                                                                                         annotation (Placement(transformation(extent={{-476,-406},{-456,-386}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheater_L4 regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    A_flueGas=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    A_air=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    diameter_reg=10,
    height_reg=3,
    N_sp=1000,
    Delta_p_flueGas_nom=1000,
    Delta_p_freshAir_nom=1000,
    T_start_wall=linspace(
        385,
        675,
        regenerativeAirPreheater.N_cv),
    T_start_flueGas=linspace(
        677,
        398,
        regenerativeAirPreheater.N_cv),
    T_start_freshAir=linspace(
        376,
        673,
        regenerativeAirPreheater.N_cv),
    frictionAtFlueGasOutlet=false,
    frictionAtFreshAirInlet=false,
    frictionAtFreshAirOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    N_cv=5,
    m_flow_freshAir_nom=475,
    m_flow_flueGas_nom=475 + 42,
    xi_nom_flueGas=NOM.eco.xi_fg_out,
    xi_start_freshAir={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    xi_nom_freshAir={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    xi_start_flueGas=INIT.eco.xi_fg_out,
    p_freshAir_nom=12000,
    p_flueGas_nom=10500,
    p_start_freshAir(each displayUnit="bar") = linspace(
      1.35e5,
      1.34e5,
      regenerativeAirPreheater.N_cv),
    stateLocation=1,
    p_start_flueGas(each displayUnit="bar") = linspace(
      1e5,
      0.99e5,
      regenerativeAirPreheater.N_cv),
    frictionAtFlueGasInlet=true)      annotation (Placement(transformation(extent={{-392,14},{-372,34}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitGas_L2_flex splitGas_L2_flex(
    N_ports_out=4,
    volume=2,
    xi_nom={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    m_flow_out_nom={475.6/4,475.6/4,475.6/4,475.6/4},
    T_start=673,
    xi_start={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    T_nom=1119.15,
    p_start(displayUnit="bar") = 133900) annotation (Placement(transformation(extent={{-400,-116},{-380,-96}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_T=false,
    T_const=273.15 + 30,
    m_flow_const=475.6 + 24,
    variable_m_flow=true)
                   annotation (Placement(transformation(extent={{-440,20},{-420,40}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y=burner1.lambdaComb_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-556,66})));
  Modelica.Blocks.Sources.Ramp lambda(
    duration=1000,
    startTime=4000,
    height=0,
    offset=1.2)
    annotation (Placement(transformation(extent={{-566,26},{-546,46}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ni=0.90,
    y_min=100,
    sign=1,
    k=1,
    t_activation=0,
    Tau_i=1,
    y_ref=475.6 + 24,
    y_max=700,
    y_inactive=475.6 + 24,
    y_start=475.6 + 24,
    u_ref=1.2,
    initOption=501) annotation (Placement(transformation(extent={{-514,46},{-494,26}})));
  Modelica.Blocks.Math.Gain gain(k=43/4) annotation (Placement(transformation(extent={{-400,-152},{-380,-132}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=475.6 + 24) annotation (Placement(transformation(extent={{-478,26},{-458,46}})));
  Visualisation.QuadrupleGas quadrupleGas(value4=11) annotation (Placement(transformation(extent={{-82,-146},{-62,-136}})));
  Visualisation.QuadrupleGas quadrupleGas1(value4=11) annotation (Placement(transformation(extent={{-80,-125},{-60,-115}})));
  Visualisation.QuadrupleGas quadrupleGas2(value4=11) annotation (Placement(transformation(extent={{-74,-99},{-54,-89}})));
  Visualisation.QuadrupleGas quadrupleGas3(value4=11) annotation (Placement(transformation(extent={{-72,-73},{-52,-63}})));
  Visualisation.QuadrupleGas quadrupleGas4(value4=11) annotation (Placement(transformation(extent={{-72,-47},{-52,-37}})));
  Visualisation.QuadrupleGas quadrupleGas5(value4=11) annotation (Placement(transformation(extent={{-174,-21},{-154,-11}})));
  Visualisation.QuadrupleGas quadrupleGas6(value4=11) annotation (Placement(transformation(extent={{-176,5},{-156,15}})));
  Visualisation.QuadrupleGas quadrupleGas7(value4=11) annotation (Placement(transformation(extent={{-178,33},{-158,43}})));
  Visualisation.QuadrupleGas quadrupleGas8(value4=11) annotation (Placement(transformation(extent={{-178,61},{-158,71}})));
  Visualisation.QuadrupleGas quadrupleGas9(value4=11) annotation (Placement(transformation(extent={{-176,89},{-156,99}})));
  Visualisation.QuadrupleGas quadrupleGas10(value4=11) annotation (Placement(transformation(extent={{-178,117},{-158,127}})));
  Visualisation.QuadrupleGas quadrupleGas11(value4=11) annotation (Placement(transformation(extent={{-178,145},{-158,155}})));
  Visualisation.QuadrupleGas quadrupleGas12(value4=11) annotation (Placement(transformation(extent={{-182,186},{-140,210}})));
  Visualisation.QuadrupleGas quadrupleGas13(value4=11) annotation (Placement(transformation(extent={{-390,-8},{-370,2}})));
  Visualisation.QuadrupleGas quadrupleGas14(value4=11) annotation (Placement(transformation(extent={{-366,36},{-346,46}})));

  Components.Control.FeedForward.FeedForwardBlock_3508 feedForwardBlock_3508_1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-432,-392})));
  Modelica.Blocks.Sources.RealExpression P_max_(y=1) annotation (Placement(transformation(extent={{-478,-374},{-458,-354}})));
  Components.Mills.HardCoalMills.RollerBowlMill_L1 rollerBowlMill_L1_1(m_flow_dust_0=1) annotation (Placement(transformation(extent={{-390,-407},{-370,-387}})));
  Modelica.Blocks.Sources.RealExpression P_min_(y=0.5) annotation (Placement(transformation(extent={{-478,-356},{-458,-336}})));
  Modelica.Blocks.Sources.RealExpression P_min_1(y=0.02/60) annotation (Placement(transformation(extent={{-478,-338},{-458,-318}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1,
    T=100) annotation (Placement(transformation(extent={{-416,-400},{-408,-392}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       evap_1_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap_1.N_cv,
    length=evap_1.length,
    diameter_i=evap_1.diameter_i,
    diameter_o=0.038,
    N_tubes=evap_1.N_tubes,
    suppressChattering="False",
    Delta_x={7.182,5.5,5.5,5.5,6.334},
    T_start={INIT.brnr1.T_vle_wall_out,INIT.brnr2.T_vle_wall_out,INIT.brnr3.T_vle_wall_out,INIT.brnr4.T_vle_wall_out,INIT.evap_rad.T_vle_wall_out},

    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99995},{13.9998,4.99995}},
        rotation=90,
        origin={1413,-580})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       evap_1(
    N_cv=5,
    z_in=11.318,
    z_out=41.334,
    diameter_i=0.0268,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    Delta_x={7.182,5.5,5.5,5.5,6.334},
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=(NOM.brnr1.Delta_p_vle_wall_nom/2 + NOM.brnr2.Delta_p_vle_wall_nom + NOM.brnr3.Delta_p_vle_wall_nom + NOM.brnr4.Delta_p_vle_wall_nom
         + NOM.evap_rad.Delta_p_vle_wall_nom/2),
    p_nom={(NOM.brnr1.p_vle_wall_out + NOM.eco_down.p_out)/2,NOM.brnr2.p_vle_wall_out,NOM.brnr3.p_vle_wall_out,NOM.brnr4.p_vle_wall_out,(NOM.brnr4.p_vle_wall_out
         + NOM.evap_rad.p_vle_wall_out)/2},
    h_nom={(NOM.brnr1.h_vle_wall_out + NOM.eco_down.h_in)/2,NOM.brnr2.h_vle_wall_out,NOM.brnr3.h_vle_wall_out,NOM.brnr4.h_vle_wall_out,(NOM.brnr4.h_vle_wall_out
         + NOM.evap_rad.h_vle_wall_out)/2},
    h_start={(INIT.brnr1.h_vle_wall_out + INIT.eco_down.h_in)/2,INIT.brnr2.h_vle_wall_out,INIT.brnr3.h_vle_wall_out,INIT.brnr4.h_vle_wall_out,(INIT.brnr4.h_vle_wall_out
         + INIT.evap_rad.h_vle_wall_out)/2},
    p_start={(INIT.brnr1.p_vle_wall_out + INIT.eco_down.p_out)/2,INIT.brnr2.p_vle_wall_out,INIT.brnr3.p_vle_wall_out,INIT.brnr4.p_vle_wall_out,(
        INIT.brnr4.p_vle_wall_out + INIT.evap_rad.p_vle_wall_out)/2},
    N_tubes=330,
    showData=true,
    contributeToCycleSummary=false,
    length=41.334 - 11.318)
                 annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-580})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       evap_2_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    diameter_i=evap_2.diameter_i,
    length=evap_2.length,
    N_tubes=evap_2.N_tubes,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        (INIT.brnr4.T_vle_wall_out + INIT.evap_rad.T_vle_wall_out)/2,
        INIT.evap_rad.T_vle_wall_out,
        evap_2.N_cv),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99996},{14,4.99998}},
        rotation=90,
        origin={1411,-484})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       evap_2(
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    diameter_i=0.0298,
    z_in=41.334,
    z_out=56.342,
    N_tubes=evap_1.N_tubes,
    N_cv=4,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=NOM.evap_rad.Delta_p_vle_wall_nom/2,
    h_start=linspace(
        (INIT.brnr4.h_vle_wall_out + INIT.evap_rad.h_vle_wall_out)/2,
        INIT.evap_rad.h_vle_wall_out,
        evap_2.N_cv),
    p_start=linspace(
        (INIT.brnr4.p_vle_wall_out + INIT.evap_rad.p_vle_wall_out)/2,
        INIT.evap_rad.p_vle_wall_out,
        evap_2.N_cv),
    p_nom=linspace(
        (NOM.brnr4.p_vle_wall_out + NOM.evap_rad.p_vle_wall_out)/2,
        NOM.evap_rad.p_vle_wall_out,
        evap_2.N_cv),
    h_nom=linspace(
        (NOM.brnr4.h_vle_wall_out + NOM.evap_rad.h_vle_wall_out)/2,
        NOM.evap_rad.h_vle_wall_out,
        evap_2.N_cv),
    length=46,
    showData=true,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-484})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort3(
    length=evap_2.length,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    N=4,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1358,-494},{1378,-474}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       evap_3_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap_3.N_cv,
    diameter_i=evap_3.diameter_i,
    length=evap_3.length,
    N_tubes=evap_3.N_tubes,
    diameter_o=0.0318,
    suppressChattering="False",
    Delta_x={3.018,4.55,3.98,3.56},
    T_start={INIT.sh1.T_vle_wall_out,INIT.sh2.T_vle_wall_out,INIT.sh4.T_vle_wall_out,INIT.rh2.T_vle_wall_out},
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1413,-420})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       evap_3(
    N_cv=4,
    diameter_i=0.0206,
    z_in=56.342,
    z_out=71.45,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    Delta_x={3.018,4.55,3.98,3.56},
    useHomotopy=true,
    initOption=0,
    length=71.45 - 56.342,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    p_nom={NOM.sh1.p_vle_wall_out,NOM.sh2.p_vle_wall_out,NOM.sh4.p_vle_wall_out,NOM.rh2.p_vle_wall_out},
    h_nom={NOM.sh1.h_vle_wall_out,NOM.sh2.h_vle_wall_out,NOM.sh4.h_vle_wall_out,NOM.rh2.h_vle_wall_out},
    h_start={INIT.sh1.h_vle_wall_out,INIT.sh2.h_vle_wall_out,INIT.sh4.h_vle_wall_out,INIT.rh2.h_vle_wall_out},
    p_start={INIT.sh1.p_vle_wall_out,INIT.sh2.p_vle_wall_out,INIT.sh4.p_vle_wall_out,INIT.rh2.p_vle_wall_out},
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=(NOM.sh1.Delta_p_vle_wall + NOM.sh2.Delta_p_vle_wall + NOM.sh4.Delta_p_vle_wall + NOM.rh2.Delta_p_vle_wall),
    N_tubes=970,
    showData=true,
    contributeToCycleSummary=false)
                           "former length: 14.618"
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-420})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       evap_4_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap_4.N_cv,
    diameter_o=0.0424,
    diameter_i=evap_4.diameter_i,
    N_tubes=evap_4.N_tubes,
    suppressChattering="False",
    T_start={INIT.sh3.T_vle_wall_out,INIT.rh1.T_vle_wall_out,INIT.eco.T_vle_wall_out},
    stateLocation=2,
    length=evap_4.length*evap_4.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_4_wall.length,
        evap_4.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99998},{13.9999,4.99998}},
        rotation=90,
        origin={1415,-318})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       evap_4(
    diameter_i=0.0298,
    z_in=71.45,
    z_out=85.6,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    N_cv=3,
    Delta_x={7.075,3.5375,3.5375},
    useHomotopy=true,
    initOption=0,
    frictionAtOutlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtInlet=true,
    h_nom={NOM.sh3.h_vle_wall_out,NOM.rh1.h_vle_wall_out,NOM.eco.h_vle_wall_out},
    p_nom={NOM.sh3.p_vle_wall_out,NOM.rh1.p_vle_wall_out,NOM.eco.p_vle_wall_out},
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    h_start={INIT.sh3.h_vle_wall_out,INIT.rh1.h_vle_wall_out,INIT.eco.h_vle_wall_out},
    p_start={INIT.sh3.p_vle_wall_out,INIT.rh1.p_vle_wall_out,INIT.eco.p_vle_wall_out},
    Delta_p_nom=(NOM.sh3.Delta_p_vle_wall + NOM.rh1.Delta_p_vle_wall + NOM.eco.Delta_p_vle_wall),
    showData=true,
    N_tubes=500,
    contributeToCycleSummary=false,
    length=85.6 - 71.45)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-318})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       sh_1_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=sh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    diameter_i=sh_1.diameter_i,
    N_tubes=sh_1.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh1.T_vle_bundle_in,
        INIT.sh1.T_vle_bundle_out,
        sh_1.N_cv),
    stateLocation=2,
    length=sh_1.length*sh_1.N_passes,
    diameter_o=0.0345,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={1655,-542})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       sh_1(
    N_cv=5,
    diameter_i=0.0269,
    z_in=59.36,
    z_out=56.342,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom=linspace(
        NOM.sh1.p_vle_bundle_in,
        NOM.sh1.p_vle_bundle_out,
        sh_1.N_cv),
    m_flow_nom=NOM.sh1.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh1.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh1.h_vle_bundle_in,
        INIT.sh1.h_vle_bundle_out,
        sh_1.N_cv),
    p_start=linspace(
        INIT.sh1.p_vle_bundle_in,
        INIT.sh1.p_vle_bundle_out,
        sh_1.N_cv),
    h_nom=linspace(
        NOM.sh1.h_vle_bundle_in,
        NOM.sh1.h_vle_bundle_out,
        sh_1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    length=12,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=300,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1676,-542})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort4(
    length=sh_1.length,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    N=sh_1.N_cv,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1610,-552},{1630,-532}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       sh_2_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=sh_2.N_cv,
    diameter_i=sh_2.diameter_i,
    N_tubes=sh_2.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh2.T_vle_bundle_in,
        INIT.sh2.T_vle_bundle_out,
        sh_2.N_cv),
    stateLocation=2,
    length=sh_2.length*sh_2.N_passes,
    diameter_o=0.0345,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2_wall.length,
        sh_2.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={1659,-440})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       sh_2(
    N_cv=5,
    diameter_i=0.0269,
    z_in=63.91,
    z_out=59.36,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.sh2.p_vle_bundle_in,
        NOM.sh2.p_vle_bundle_out,
        sh_2.N_cv),
    m_flow_nom=NOM.sh2.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh2.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh2.h_vle_bundle_in,
        INIT.sh2.h_vle_bundle_out,
        sh_2.N_cv),
    p_start=linspace(
        INIT.sh2.p_vle_bundle_in,
        INIT.sh2.p_vle_bundle_out,
        sh_2.N_cv),
    h_nom=linspace(
        NOM.sh2.h_vle_bundle_in,
        NOM.sh2.h_vle_bundle_out,
        sh_2.N_cv),
    showData=true,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=250,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2.length*sh_2.N_passes,
        sh_2.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1678,-440})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort5(
    length=sh_2.length,
    N=sh_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2.length,
        sh_2.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1614,-450},{1634,-430}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       sh_3_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=sh_3.N_cv,
    diameter_i=sh_3.diameter_i,
    N_tubes=sh_3.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh3.T_vle_bundle_in,
        INIT.sh3.T_vle_bundle_out,
        sh_3.N_cv),
    stateLocation=2,
    length=sh_3.length*sh_3.N_passes,
    diameter_o=0.0300,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3_wall.length,
        sh_1.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={1659,-356})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       sh_3(
    N_cv=5,
    diameter_i=0.0268,
    z_in=75.18,
    z_out=71.45,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom=linspace(
        NOM.sh3.p_vle_bundle_in,
        NOM.sh3.p_vle_bundle_out,
        sh_3.N_cv),
    h_nom=linspace(
        NOM.sh3.h_vle_bundle_in,
        NOM.sh3.h_vle_bundle_out,
        sh_3.N_cv),
    m_flow_nom=NOM.sh3.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh3.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh3.h_vle_bundle_in,
        INIT.sh3.h_vle_bundle_out,
        sh_3.N_cv),
    p_start=linspace(
        INIT.sh3.p_vle_bundle_in,
        INIT.sh3.p_vle_bundle_out,
        sh_3.N_cv),
    frictionAtOutlet=true,
    showData=true,
    N_tubes=500,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3.length*sh_3.N_passes,
        sh_3.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1676,-356})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort6(
    length=sh_3.length,
    N=sh_3.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3.length,
        sh_3.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1612,-366},{1632,-346}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       sh_4_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=sh_4.N_cv,
    diameter_i=sh_4.diameter_i,
    N_tubes=sh_4.N_tubes,
    diameter_o=0.038,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh4.T_vle_bundle_in,
        INIT.sh4.T_vle_bundle_out,
        sh_4.N_cv),
    stateLocation=2,
    length=sh_4.length*sh_4.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4_wall.length,
        sh_4.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={1652,-244})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       sh_4(
    N_cv=5,
    diameter_i=0.0238,
    z_in=67.89,
    z_out=63.91,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.sh4.p_vle_bundle_in,
        NOM.sh4.p_vle_bundle_out,
        sh_4.N_cv),
    h_nom=linspace(
        NOM.sh4.h_vle_bundle_in,
        NOM.sh4.h_vle_bundle_out,
        sh_4.N_cv),
    h_start=linspace(
        INIT.sh4.h_vle_bundle_in,
        INIT.sh4.h_vle_bundle_out,
        sh_4.N_cv),
    p_start=linspace(
        INIT.sh4.p_vle_bundle_in,
        INIT.sh4.p_vle_bundle_out,
        sh_4.N_cv),
    m_flow_nom=NOM.sh4.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh4.Delta_p_vle_bundle_nom,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=530,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4.length*sh_4.N_passes,
        sh_4.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1676,-244})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort7(
    length=sh_4.length,
    N=sh_4.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4.length,
        sh_4.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1608,-254},{1628,-234}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       eco_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco.N_cv,
    diameter_i=eco.diameter_i,
    N_tubes=eco.N_tubes,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        INIT.eco.T_vle_bundle_in,
        INIT.eco.T_vle_bundle_out,
        eco.N_cv),
    stateLocation=2,
    length=eco.length*eco.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_wall.length,
        eco.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.0001},{14,5.0001}},
        rotation=90,
        origin={1401,-758})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       eco(
    N_cv=5,
    z_in=85.6,
    z_out=82.9,
    diameter_i=0.0334,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    h_nom=linspace(
        NOM.eco.h_vle_bundle_in,
        NOM.eco.h_vle_bundle_out,
        eco.N_cv),
    p_nom=linspace(
        NOM.eco.p_vle_bundle_in,
        NOM.eco.p_vle_bundle_out,
        eco.N_cv),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=NOM.eco.Delta_p_vle_bundle_nom,
    p_start=linspace(
        INIT.eco.p_vle_bundle_in,
        INIT.eco.p_vle_bundle_out,
        eco.N_cv),
    h_start=linspace(
        INIT.eco.h_vle_bundle_in,
        INIT.eco.h_vle_bundle_out,
        eco.N_cv),
    useHomotopy=true,
    N_tubes=250,
    frictionAtOutlet=true,
    showData=true,
    length=15,
    N_passes=6,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length*eco.N_passes,
        eco.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-758})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort14(
    length=eco.length,
    N=eco.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length,
        eco.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1360,-768},{1380,-748}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       rh_1_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=rh_1.N_cv,
    diameter_o=0.051,
    diameter_i=rh_1.diameter_i,
    N_tubes=rh_1.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh1.T_vle_bundle_in,
        INIT.rh1.T_vle_bundle_out,
        rh_1.N_cv),
    stateLocation=2,
    length=rh_1.length*rh_1.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1_wall.length,
        rh_1.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.00007},{14,5.00007}},
        rotation=90,
        origin={1883,-462})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       rh_1(
    N_cv=5,
    diameter_i=0.0413,
    z_in=82.9,
    z_out=75.18,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom=NOM.rh1.Delta_p_vle_wall_nom,
    p_nom=linspace(
        NOM.rh1.p_vle_bundle_in,
        NOM.rh1.p_vle_bundle_out,
        rh_1.N_cv),
    h_nom=linspace(
        NOM.rh1.h_vle_bundle_in,
        NOM.rh1.h_vle_bundle_out,
        rh_1.N_cv),
    h_start=linspace(
        INIT.rh1.h_vle_bundle_in,
        INIT.rh1.h_vle_bundle_out,
        rh_1.N_cv),
    p_start=linspace(
        INIT.rh1.p_vle_bundle_in,
        INIT.rh1.p_vle_bundle_out,
        rh_1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    length=15.3,
    N_passes=6,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=420,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1.length*rh_1.N_passes,
        rh_1.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1902,-462})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort15(
    length=rh_1.length,
    N=rh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1.length,
        rh_1.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1840,-472},{1860,-452}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       rh_2_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=rh_2.N_cv,
    diameter_o=0.051,
    diameter_i=rh_2.diameter_i,
    N_tubes=rh_2.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh2.T_vle_bundle_in,
        INIT.rh2.T_vle_bundle_out,
        rh_1.N_cv),
    stateLocation=2,
    length=rh_2.length*rh_2.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2_wall.length,
        rh_2.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99997},{13.9999,4.99993}},
        rotation=90,
        origin={1881,-336})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       rh_2(
    N_cv=5,
    diameter_i=0.0397,
    z_in=67.89,
    z_out=71.45,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom=NOM.rh2.Delta_p_vle_wall_nom,
    p_nom=linspace(
        NOM.rh2.p_vle_bundle_in,
        NOM.rh2.p_vle_bundle_out,
        rh_1.N_cv),
    h_nom=linspace(
        NOM.rh2.h_vle_bundle_in,
        NOM.rh2.h_vle_bundle_out,
        rh_1.N_cv),
    h_start=linspace(
        INIT.rh2.h_vle_bundle_in,
        INIT.rh2.h_vle_bundle_out,
        rh_1.N_cv),
    N_tubes=800,
    p_start=linspace(
        INIT.rh2.p_vle_bundle_in,
        INIT.rh2.p_vle_bundle_out,
        rh_1.N_cv),
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2.length*rh_2.N_passes,
        rh_2.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1902,-336})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort16(
    length=rh_2.length,
    N=rh_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2.length,
        rh_2.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1830,-346},{1850,-326}})));
  Components.Sensors.SensorVLE_L1_T    sh_4_out_T(unitOption=2)
    annotation (Placement(transformation(extent={{1682,-230},{1702,-208}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       evap_0_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    diameter_o=0.038,
    N_ax=evap_0.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    diameter_i=evap_0.diameter_i,
    length=evap_0.length,
    N_tubes=evap_0.N_tubes,
    suppressChattering="False",
    T_start=ones(evap_0.N_cv)*(INIT.brnr1.T_vle_wall_in),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99981},{14,4.99977}},
        rotation=90,
        origin={1403,-640})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       evap_0(
    diameter_i=0.0268,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    N_cv=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    N_tubes=970,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    length=11.318 - 4.03,
    z_in=4.03,
    z_out=11.318,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    Delta_p_nom=NOM.brnr1.Delta_p_vle_wall_nom/2,
    p_nom=linspace(
        NOM.eco_down.p_out,
        NOM.eco_down.p_out + NOM.brnr1.Delta_p_vle_wall_nom/2,
        evap_0.N_cv),
    h_nom=linspace(
        NOM.eco_down.h_in,
        (NOM.eco_down.h_in + NOM.brnr1.h_vle_wall_out)/2,
        evap_0.N_cv),
    h_start=linspace(
        INIT.eco_down.h_in,
        (INIT.eco_down.h_in + INIT.brnr1.h_vle_wall_out)/2,
        evap_0.N_cv),
    p_start=linspace(
        INIT.eco_down.p_out,
        INIT.eco_down.p_out - INIT.brnr1.Delta_p_vle/2,
        evap_0.N_cv),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    showData=true,
    contributeToCycleSummary=false)
                               "zin/zout changed to hopper from burner1 in/flameroom out"
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-640})));
  Components.Adapters.Scalar2VectorHeatPort       scalar2VectorHeatPort17(
    length=evap_0.length,
    N=evap_0.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{1354,-650},{1374,-630}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       ct_1_wall1(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=ct_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        ct_1.length,
        ct_1.N_cv),
    diameter_i=ct_1.diameter_i,
    N_tubes=ct_1.N_tubes,
    diameter_o=0.0445,
    suppressChattering="False",
    T_start=linspace(
        INIT.ct.T_vle_wall_in,
        INIT.ct.T_vle_wall_out,
        ct_1.N_cv),
    stateLocation=2,
    length=ct_1.length*ct_1.N_passes,
    initOption=213) annotation (Placement(transformation(
        extent={{14,-4.99999},{-14,5}},
        rotation=90,
        origin={1515,-382})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       ct_1(
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        ct_1.length,
        ct_1.N_cv),
    z_in=85.6,
    diameter_i=0.027,
    z_out=59.36,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.ct.p_vle_wall_in,
        NOM.ct.p_vle_wall_out,
        ct_1.N_cv),
    h_nom=linspace(
        NOM.ct.h_vle_wall_in,
        NOM.ct.h_vle_wall_out,
        ct_1.N_cv),
    Delta_p_nom=NOM.ct.Delta_p_vle_wall,
    h_start=linspace(
        INIT.ct.h_vle_wall_in,
        INIT.ct.h_vle_wall_out,
        ct_1.N_cv),
    p_start=linspace(
        INIT.ct.p_vle_wall_in,
        INIT.ct.p_vle_wall_out,
        ct_1.N_cv),
    m_flow_nom=NOM.ct.m_flow_vle_wall_in,
    showData=true,
    length=32,
    N_tubes=310,
    N_cv=7,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=90,
        origin={1535,-382})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       eco_riser_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.eco.T_vle_bundle_in),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1409,-796})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       eco_down(
    N_cv=5,
    diameter_i=0.2,
    N_tubes=1,
    z_in=eco.z_out,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_down.length,
        eco_down.N_cv),
    z_out=evap_0.z_in,
    length=eco_down.z_in - eco_down.z_out,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_nom=linspace(
        NOM.eco_down.p_in,
        NOM.eco_down.p_out,
        eco_down.N_cv),
    h_nom=ones(eco_down.N_cv)*NOM.eco_down.h_in,
    h_start=ones(eco_down.N_cv)*INIT.eco_down.h_in,
    p_start=linspace(
        INIT.eco_down.p_in,
        INIT.eco_down.p_out,
        eco_down.N_cv),
    Delta_p_nom=NOM.eco_down.Delta_p_nom,
    frictionAtInlet=false,
    contributeToCycleSummary=false)       annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-704})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       eco_down_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.brnr1.T_vle_wall_in),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99997},{13.9999,4.99997}},
        rotation=90,
        origin={1413,-704})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2       separator(
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.1e5),
    useHomotopy=true,
    initOption=0,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (diameter=0.92, length=3),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_nom=NOM.eco.p_vle_wall_out,
    h_nom=NOM.eco.h_vle_wall_out,
    h_start=(INIT.eco.h_vle_wall_out + INIT.ct.h_vle_wall_in)/2,
    p_start=(INIT.eco.p_vle_wall_out + INIT.ct.p_vle_wall_in)/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1480,-282})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4       separator_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    diameter_o=separator.geo.diameter + 0.064,
    diameter_i=separator.geo.diameter,
    length=separator.geo.length,
    T_start={(INIT.eco.T_vle_wall_out + INIT.ct.T_vle_wall_in)/2})
                                                                  annotation (Placement(transformation(
        extent={{-9.99988,-8.00005},{10.0001,8.00002}},
        rotation=0,
        origin={1480,-258})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       rh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    diameter_i=0.2,
    z_in=0,
    z_out=eco.z_in,
    N_tubes=1,
    length=rh_pipe.z_out - rh_pipe.z_in,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_pipe.length,
        rh_pipe.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=100000,
    showData=true,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    p_nom=ones(rh_pipe.N_cv)*NOM.rh2.p_vle_bundle_out,
    h_nom=ones(rh_pipe.N_cv)*NOM.rh2.h_vle_bundle_out,
    frictionAtOutlet=false,
    h_start=linspace(
        INIT.rh2.h_vle_bundle_out,
        INIT.rh2.h_vle_bundle_out,
        rh_pipe.N_cv),
    p_start=linspace(
        INIT.rh2.p_vle_bundle_out,
        INIT.rh2.p_vle_bundle_out,
        rh_pipe.N_cv),
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1902,-288})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       rh_pipe_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.rh2.T_vle_bundle_out),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-13,-5},{13,5}},
        rotation=90,
        origin={1881,-288})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       sh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    N_tubes=1,
    diameter_i=0.2,
    z_in=sh_4.z_out,
    z_out=0,
    length=sh_pipe.z_in - sh_pipe.z_out,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    showData=true,
    p_nom=ones(sh_pipe.N_cv)*(NOM.sh4_down.p_in + NOM.sh4_down.p_out)/2,
    h_nom=ones(sh_pipe.N_cv)*NOM.sh4_down.h_in,
    m_flow_nom=NOM.sh4_down.m_flow,
    Delta_p_nom=NOM.sh4_down.Delta_p_nom,
    h_start=linspace(
        INIT.sh4_down.h_in,
        INIT.sh4_down.h_in,
        sh_pipe.N_cv),
    p_start=linspace(
        INIT.sh4_down.p_in,
        INIT.sh4_down.p_out,
        sh_pipe.N_cv),
    frictionAtOutlet=false,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        sh_pipe.length,
        sh_pipe.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1676,-198})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4       sh_pipe_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.sh4.T_vle_bundle_out),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={1653,-198})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_HP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_HP.p_in,
    m_flow_nom=NOM.Turbine_HP.m_flow,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_HP.p_in,
        NOM.Turbine_HP.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.efficiency_Turb_HP; 1,
            NOM.efficiency_Turb_HP])),
    p_in_start=INIT.Turbine_HP.p_in,
    p_out_start=INIT.Turbine_HP.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_HP.efficiency)
    annotation (Placement(transformation(extent={{2148,-490},{2158,-470}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_IP1(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency;
            1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    p_nom=NOM.Turbine_IP1.p_in,
    m_flow_nom=NOM.Turbine_IP1.m_flow,
    Pi=NOM.Turbine_IP1.p_out/NOM.Turbine_IP1.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP1.p_in,
        NOM.Turbine_IP1.h_in),
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_IP1.efficiency)
                            annotation (Placement(transformation(extent={{2232,-490},{2242,-470}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP4(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP4.efficiency;
            1,NOM.Turbine_LP4.efficiency])),
    p_in_start=INIT.Turbine_LP4.p_in,
    p_out_start=INIT.Turbine_LP4.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP4.p_in,
    m_flow_nom=NOM.Turbine_LP4.m_flow,
    Pi=NOM.Turbine_LP4.p_out/NOM.Turbine_LP4.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP4.p_in,
        NOM.Turbine_LP4.h_in),
    eta_mech=NOM.Turbine_LP4.efficiency)
    annotation (Placement(transformation(extent={{2572,-490},{2582,-470}})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple       Pump_FW(eta_mech=NOM.efficiency_Pump_cond)
                                                                               annotation (Placement(transformation(extent={{2236,-700},{2216,-720}})));
  Visualisation.Quadruple       quadruple(decimalSpaces(p=3))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2626,-460})));
  Visualisation.Quadruple       quadruple1
    annotation (Placement(transformation(extent={{1938,-268},{1998,-248}})));
  Visualisation.Quadruple       quadruple2
    annotation (Placement(transformation(extent={{1712,-182},{1772,-162}})));
  Visualisation.Quadruple       quadruple3
    annotation (Placement(transformation(extent={{2266,-430},{2326,-410}})));
  Visualisation.Quadruple       quadruple4
    annotation (Placement(transformation(extent={{2166,-430},{2226,-410}})));
  Visualisation.Quadruple       quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{2756,-630},{2816,-610}})));
  Components.MechanicalSeparation.FeedWaterTank_L3 feedWaterTank(
    diameter=5,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    p_start(displayUnit="bar") = INIT.feedwatertank.p_FWT,
    z_tapping=4.5,
    z_vent=4.5,
    z_condensate=4.5,
    initOptionWall=1,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),

    m_flow_cond_nom=NOM.feedwatertank.m_flow_cond,
    p_nom=NOM.feedwatertank.p_FWT,
    h_nom=NOM.feedwatertank.h_cond_in,
    m_flow_heat_nom=NOM.feedwatertank.m_flow_tap1 + NOM.feedwatertank.m_flow_tap2,
    initOption=204,
    T_wall_start=ones(feedWaterTank.wall.N_rad)*(120 + 273.15),
    showLevel=true,
    length=12,
    z_aux=1,
    level_rel_start=0.51,
    equalPressures=true,
    absorbInflow=0.75,
    Tau_cond=1,
    Tau_evap=10)                                    annotation (Placement(transformation(extent={{2250,-668},{2310,-648}})));
  Components.TurboMachines.Pumps.PumpVLE_L1_affinity     Pump_cond(
    showExpertSummary=true,
    contributeToCycleSummary=false,
    J=1,
    rpm_nom=3000,
    redeclare model Energetics = Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (eta_hyd_nom=NOM.Pump_cond.efficiency),
    V_flow_max=NOM.Pump_cond.m_flow/NOM.Pump_cond.rho_in*2,
    Delta_p_max=-NOM.Pump_cond.Delta_p*2,
    useMechanicalPort=true)                                                                            annotation (Placement(transformation(extent={{2726,
            -648},{2706,-668}})));
  Visualisation.Quadruple       quadruple6
    annotation (Placement(transformation(extent={{2258,-690},{2318,-670}})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_IP1(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=NOM.valve_IP1.Delta_p, m_flow_nom=NOM.valve_IP1.m_flow),
      checkValve=true)                                                                                                                                                                                                         annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={2296,-560})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_LP1.p_in,
    m_flow_nom=NOM.Turbine_LP1.m_flow,
    Pi=NOM.Turbine_LP1.p_out/NOM.Turbine_LP1.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP1.p_in,
        NOM.Turbine_LP1.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency;
            1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_LP1.efficiency)
    annotation (Placement(transformation(extent={{2452,-490},{2462,-470}})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y       join_LP1(
    p_nom=INIT.Turbine_LP1.p_out,
    h_nom=INIT.Turbine_LP1.h_out,
    h_start=INIT.Turbine_LP1.h_out,
    p_start=INIT.Turbine_LP1.p_out,
    volume=0.1,
    initOption=0,
    m_flow_out_nom={NOM.Turbine_LP1.summary.outlet.m_flow,NOM.preheater_LP2.summary.inlet_tap.m_flow})
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2476,-490})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple       Pump_preheater_LP1(eta_mech=0.9, inlet(m_flow(start=NOM.pump_preheater_LP1.summary.inlet.m_flow)))
                                                                                        annotation (Placement(transformation(extent={{2376,-690},{
            2356,-710}})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_IP3(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_IP2.m_flow,
        Delta_p_nom=NOM.valve_IP2.Delta_p,
        rho_in_nom=2.4)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={2406,-560})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y       join_HP(
    volume=0.1,
    p_start=INIT.Turbine_HP.p_out,
    p_nom=NOM.Turbine_HP.p_out,
    h_nom=NOM.Turbine_HP.h_out,
    h_start=INIT.Turbine_HP.h_out,
    showExpertSummary=true,
    m_flow_out_nom={NOM.join_HP.m_flow_2,NOM.join_HP.m_flow_3},
    initOption=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2118,-512})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_HP(
    openingInputIsActive=false,
    showExpertSummary=true,
    checkValve=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_HP.m_flow,
        Delta_p_nom=NOM.valve_HP.Delta_p_nom,
        rho_in_nom=25)) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=90,
        origin={2118,-560})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valveControl_preheater_HP(openingInputIsActive=true, redeclare model
      PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=NOM.valve2_HP.m_flow,
        Delta_p_nom=NOM.valve2_HP.Delta_p*0.01,
        rho_in_nom=800)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={2160,-750})));
  Visualisation.StatePoint_phTs       statePoint annotation (Placement(transformation(extent={{2046,-710},{2064,-690}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheater_HP(y=0.5) annotation (Placement(transformation(extent={{2118,-802},{2130,-790}})));
  Components.Utilities.Blocks.LimPID PI_valveControl_preheater_HP(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=1,
    y_min=0.01,
    k=2,
    Tau_i=10,
    y_start=0.2,
    initOption=796) annotation (Placement(transformation(extent={{2134,-790},{2154,-770}})));
  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=1)
    annotation (Placement(transformation(extent={{2790,-804},{2782,-796}})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valvePreFeedWaterTank(Tau=1e-3, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=NOM.valvePreFeedWaterTank.Delta_p_nom, m_flow_nom=NOM.valvePreFeedWaterTank.m_flow))
                                                                                                                                                                                                            annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={2366,-652})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y       join_LP_main(
    volume=0.2,
    m_flow_in_nom={NOM.join_LP_main.m_flow_1,NOM.join_LP_main.m_flow_2},
    p_nom=NOM.join_LP_main.p,
    h_nom=NOM.join_LP_main.h3,
    h_start=INIT.join_LP_main.h3,
    p_start=INIT.join_LP_main.p,
    initOption=0,
    redeclare model PressureLossOut = Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420))
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={2336,-652})));
  Components.Utilities.Blocks.LimPID       PID_preheaterLP1(
    sign=-1,
    Tau_d=30,
    y_max=NOM.pump_preheater_LP1.P_pump*1.5,
    y_min=NOM.pump_preheater_LP1.P_pump/100,
    y_ref=1e5,
    y_start=INIT.pump_preheater_LP1.P_pump,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=200,
    Tau_i=200,
    initOption=796) annotation (Placement(transformation(extent={{2424,-770},{2404,-790}})));
  Visualisation.Quadruple       quadruple8
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2332,-580})));
  Visualisation.Quadruple       quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2440,-580})));
  Visualisation.Quadruple       quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2366,-620})));
  Visualisation.Quadruple       quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2154,-580})));
  Visualisation.Quadruple       quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2180,-734})));
  Visualisation.Quadruple       quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2718,-620})));
  Visualisation.Quadruple       quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={2366,-678})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump1(k=NOM.m_flow_nom*0.98)
    annotation (Placement(transformation(extent={{2172,-860},{2180,-852}})));
  Visualisation.DynDisplay       valveControl_preheater_HP_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_HP",
    x1=valveControl_preheater_HP.summary.outline.opening_) annotation (Placement(transformation(extent={{2168,-780},{2200,-768}})));
  Visualisation.DynDisplay       electricalPower(
    decimalSpaces=2,
    varname="electrical Power",
    x1=simpleGenerator.summary.P_el/1e6,
    unit="MW") annotation (Placement(transformation(extent={{2738,-466},{2778,-454}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency;
            1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP3.p_in,
    m_flow_nom=NOM.Turbine_IP3.m_flow,
    Pi=NOM.Turbine_IP3.p_out/NOM.Turbine_IP3.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP3.p_in,
        NOM.Turbine_IP3.h_in),
    eta_mech=NOM.Turbine_IP3.efficiency)
                            annotation (Placement(transformation(extent={{2312,-490},{2322,-470}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency;
            1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP2.p_in,
    m_flow_nom=NOM.Turbine_IP2.m_flow,
    Pi=NOM.Turbine_IP2.p_out/NOM.Turbine_IP2.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP2.p_in,
        NOM.Turbine_IP2.h_in),
    eta_mech=NOM.Turbine_IP2.efficiency)
                            annotation (Placement(transformation(extent={{2272,-490},{2282,-470}})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_IP2(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP2.p_out,
    h_nom=NOM.Turbine_IP2.h_out,
    m_flow_out_nom={NOM.Turbine_IP2.summary.outlet.m_flow,NOM.feedwatertank.m_flow_tap2},
    h_start=INIT.Turbine_IP2.h_out,
    p_start=INIT.Turbine_IP2.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2296,-490})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_IP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP3.p_out,
    h_nom=NOM.Turbine_IP3.h_out,
    m_flow_out_nom={NOM.Turbine_IP3.summary.outlet.m_flow,NOM.preheater_LP1.summary.inlet_tap.m_flow},
    h_start=INIT.Turbine_IP3.h_out,
    p_start=INIT.Turbine_IP3.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2406,-490})));
  Visualisation.Quadruple       quadruple15
    annotation (Placement(transformation(extent={{2286,-450},{2346,-430}})));
  Visualisation.Quadruple       quadruple16
    annotation (Placement(transformation(extent={{2326,-470},{2386,-450}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency;
            1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP3.p_in,
    m_flow_nom=NOM.Turbine_LP3.m_flow,
    Pi=NOM.Turbine_LP3.p_out/NOM.Turbine_LP3.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP3.p_in,
        NOM.Turbine_LP3.h_in),
    eta_mech=NOM.Turbine_LP3.efficiency)
    annotation (Placement(transformation(extent={{2532,-490},{2542,-470}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency;
            1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP2.p_in,
    m_flow_nom=NOM.Turbine_LP2.m_flow,
    Pi=NOM.Turbine_LP2.p_out/NOM.Turbine_LP2.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP2.p_in,
        NOM.Turbine_LP2.h_in),
    eta_mech=NOM.Turbine_LP2.efficiency)
    annotation (Placement(transformation(extent={{2492,-490},{2502,-470}})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y       join_LP2(
    volume=0.1,
    initOption=0,
    p_nom=INIT.Turbine_LP2.p_out,
    h_nom=INIT.Turbine_LP2.h_out,
    m_flow_out_nom={NOM.Turbine_LP2.summary.outlet.m_flow,NOM.preheater_LP3.summary.inlet_tap.m_flow},
    h_start=INIT.Turbine_LP2.h_out,
    p_start=INIT.Turbine_LP2.p_out)
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2516,-490})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y       join_LP3(
    volume=0.1,
    initOption=0,
    p_nom=INIT.Turbine_LP3.p_out,
    h_nom=INIT.Turbine_LP3.h_out,
    h_start=INIT.Turbine_LP3.h_out,
    p_start=INIT.Turbine_LP3.p_out,
    m_flow_out_nom={NOM.Turbine_LP2.summary.outlet.m_flow,NOM.preheater_LP4.summary.inlet_tap.m_flow})
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2556,-490})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_LP2(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=NOM.valve_LP1.Delta_p, m_flow_nom=NOM.valve_LP1.m_flow))
                                                                                                                                                                                                            annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={2476,-560})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple       preheater_LP2(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    N_passes=1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,
            0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),

    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP2.length,
    m_flow_nom_shell=NOM.preheater_LP2.m_flow_tap,
    p_nom_shell=NOM.preheater_LP2.p_tap,
    h_nom_shell=NOM.preheater_LP2.h_tap_out,
    p_start_shell=INIT.preheater_LP2.p_tap,
    diameter_i=0.05,
    diameter_o=0.052,
    z_in_tubes=preheater_LP2.diameter/2,
    z_out_tubes=preheater_LP2.diameter/2,
    m_flow_nom_tubes=NOM.preheater_LP2.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP2.p_cond,
    h_nom_tubes=NOM.preheater_LP2.h_cond_out,
    h_start_tubes=INIT.preheater_LP2.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP2.p_cond,
    level_rel_start=0.2,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),

    T_w_start={320,340,360},
    N_tubes=1000,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2476,-654})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple       preheater_LP3(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,
            0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),

    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP3.length,
    m_flow_nom_shell=NOM.preheater_LP3.m_flow_tap,
    p_nom_shell=NOM.preheater_LP3.p_tap,
    h_nom_shell=NOM.preheater_LP3.h_tap_out,
    p_start_shell=INIT.preheater_LP3.p_tap,
    diameter_i=0.05,
    diameter_o=0.052,
    m_flow_nom_tubes=NOM.preheater_LP3.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP3.p_cond,
    h_nom_tubes=NOM.preheater_LP3.h_cond_out,
    h_start_tubes=INIT.preheater_LP3.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP3.p_cond,
    level_rel_start=0.2,
    N_passes=2,
    N_tubes=500,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),

    T_w_start={300,320,340},
    z_in_aux1=0.1,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2546,-654})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP3(
    showExpertSummary=true,
    eta_mech=0.9,
    outlet(p(start=NOM.pump_preheater_LP3.summary.outlet.p)))                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={2526,-700})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_afterPumpLP3(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=30, Delta_p_nom=1000))                                                                                                                    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={2510,-680})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valveControl_preheater_LP2(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        m_flow_nom=25,
        Delta_p_nom=0.2e5)) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={2476,-680})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_preheater_LP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.join_preheater_LP3.summary.outlet.p,
    h_nom=NOM.join_preheater_LP3.summary.outlet.h,
    h_start=INIT.join_preheater_LP3.summary.outlet.h,
    p_start=INIT.join_preheater_LP3.summary.outlet.p,
    redeclare model PressureLossIn1 = Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420),
    redeclare model PressureLossOut = Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420))
                                                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={2510,-650})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valveControl_preheater_LP4(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        m_flow_nom=8,
        CL_valve=[0,0; 1,1],
        Delta_p_nom=0.06e5)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={2656,-700})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_LP3(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=NOM.valve_LP2.Delta_p, m_flow_nom=NOM.valve_LP2.m_flow))
                                                                                                                                                                                                            annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={2546,-560})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valve_LP4(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=NOM.valve_LP3.m_flow, Delta_p_nom=NOM.valve_LP3.Delta_p),
      checkValve=true)                                                                                                                                                                                                         annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={2616,-560})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(T_const=273.15 + 15, m_flow_const=25000) annotation (Placement(transformation(extent={{2826,
            -610},{2806,-590}})));
  Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=2e5) annotation (Placement(transformation(extent={{2826,-570},{2806,-550}})));
  Components.Utilities.Blocks.LimPID PID_preheaterLP4(
    sign=-1,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_start=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=15,
    t_activation=5,
    k=0.2,
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={2624,-780})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP4(y=0.1) annotation (Placement(transformation(extent={{2578,-776},{2592,-764}})));
  Components.Utilities.Blocks.LimPID PID_preheaterLP3(
    u_ref=0.2,
    sign=-1,
    t_activation=2,
    use_activateInput=false,
    y_ref=150000,
    y_inactive=150000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    y_min=2000,
    y_max=10e6,
    y_start=INIT.pump_preheater_LP3.P_pump,
    Tau_i=30,
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={2554,-780})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP3(y=0.1) annotation (Placement(transformation(extent={{2592,-786},{2578,-774}})));
  Components.Utilities.Blocks.LimPID       PID_preheaterLP2(
    sign=-1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_min=0,
    k=0.5,
    Tau_i=20,
    y_start=1,
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={2484,-780})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP2(y=0.1) annotation (Placement(transformation(extent={{2520,-786},{2506,-774}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP1(y=0.1) annotation (Placement(transformation(extent={{2450,-786},{2436,-774}})));
  Modelica.Blocks.Sources.RealExpression setPoint_condenser(y=0.5/6) annotation (Placement(transformation(extent={{2792,-786},{2778,-774}})));
  Visualisation.Quadruple       quadruple17
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2596,-420})));
  Visualisation.Quadruple       quadruple18
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2616,-440})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=2000, phi(start=0))
                                                                   annotation (Placement(transformation(extent={{2718,-490},{2738,-470}})));
  Components.Electrical.SimpleGenerator simpleGenerator(contributeToCycleSummary=true, hasInertia=true)
                                                                         annotation (Placement(transformation(extent={{2748,-490},{2768,-470}})));
  Components.BoundaryConditions.BoundaryElectricFrequency boundaryElectricFrequency annotation (Placement(transformation(extent={{2808,-490},{2788,
            -470}})));
  Visualisation.Quadruple       quadruple19
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2510,-580})));
  Visualisation.Quadruple       quadruple20
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2580,-580})));
  Visualisation.Quadruple       quadruple21(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2652,-580})));
  Visualisation.DynamicBar fillingLevel_preheater_LP1(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{2414,-664},{2424,-644}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP2(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{2484,-664},{2494,-644}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP3(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{2554,-664},{2564,-644}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP4(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{2624,-664},{2634,-644}})));
  Visualisation.DynamicBar fillingLevel_condenser(
    u_set=0.5/6,
    u_high=0.5/3,
    u_low=0.5/12,
    provideInputConnectors=true)
                  annotation (Placement(transformation(extent={{2754,-590},{2764,-570}})));
  Visualisation.DynamicBar fillingLevel_preheater_HP(
    provideInputConnectors=true,
    u_set=0.5,
    u_high=0.6,
    u_low=0.4)  annotation (Placement(transformation(extent={{2126,-722},{2136,-702}})));
  Visualisation.DynDisplay valveControl_preheater_LP4_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP4",
    x1=valveControl_preheater_LP4.summary.outline.opening_) annotation (Placement(transformation(extent={{2640,-690},{2672,-678}})));
  Visualisation.DynDisplay valveControl_preheater_LP2_display2(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP2",
    x1=valveControl_preheater_LP2.summary.outline.opening_) annotation (Placement(transformation(extent={{2428,-686},{2460,-674}})));
  Visualisation.Quadruple       quadruple22
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2440,-620})));
  Visualisation.Quadruple       quadruple23
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2580,-620})));
  Visualisation.Quadruple       quadruple24
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2652,-620})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple downComer_feedWaterTank(
    m_flow_nom=NOM.downComer_feedWaterTank.summary.outlet.m_flow,
    p_nom=ones(downComer_feedWaterTank.geo.N_cv)*NOM.downComer_feedWaterTank.summary.outlet.p,
    h_nom=ones(downComer_feedWaterTank.geo.N_cv)*NOM.downComer_feedWaterTank.summary.outlet.h,
    length=downComer_feedWaterTank.z_in - downComer_feedWaterTank.z_out,
    diameter_i=0.2,
    h_start=ones(downComer_feedWaterTank.geo.N_cv)*INIT.downComer_feedWaterTank.summary.inlet.h,
    z_in=NOM.downComer_z_in,
    z_out=NOM.downComer_z_out,
    p_start=linspace(
        INIT.downComer_feedWaterTank.summary.inlet.p,
        INIT.downComer_feedWaterTank.summary.outlet.p,
        downComer_feedWaterTank.geo.N_cv),
    frictionAtInlet=true,
    frictionAtOutlet=false)
                          annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={2254,-689})));
  Visualisation.Quadruple       quadruple25
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2066,-722})));
  Components.Utilities.Blocks.LimPID PI_Pump_cond(
    Tau_d=500,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=1,
    sign=-1,
    y_max=50,
    y_min=5,
    y_start=50,
    y_ref=1000,
    k=0.5,
    Tau_i=40,
    initOption=796) annotation (Placement(transformation(extent={{2766,-790},{2746,-770}})));
  Modelica.Blocks.Sources.RealExpression fixedVoltage(y=10e3) annotation (Placement(transformation(extent={{2688,-726},{2702,-714}})));
  Components.Electrical.AsynchronousMotor_L2       motor(
    N_pp=1,
    rpm_nom=2950,
    cosphi=0.9,
    eta_stator=0.95,
    tau_bd_nom=50e3,
    activateHeatPort=false,
    initOption="fixed slip",
    J=800,
    useCharLine=true,
    charLine_tau_rpm_=[0,2; 0.7,1.8; 0.95,2.8; 1,0],
    P_nom=NOM.Pump_cond.P_pump,
    I_rotor_nom=50,
    U_term_nom=10e3,
    contributeToCycleSummary=true,
    shaft(phi(start=0)))                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={2716,-690})));
  Visualisation.DynDisplay electricalPowerPump_Cond(
    decimalSpaces=2,
    varname="electrical Power",
    unit="MW",
    x1=motor.summary.P_term/1e6) annotation (Placement(transformation(extent={{2730,-702},{2770,-690}})));
  Visualisation.DynDisplay rpm_Pump(
    varname="rpm Pump",
    x1=Pump_cond.summary.outline.rpm,
    unit="1/min",
    decimalSpaces=0) annotation (Placement(transformation(extent={{2730,-690},{2770,-678}})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valveControl_preheater_LP1(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        Delta_p_nom=1000,
        m_flow_nom=25000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={2792,-560})));
  Visualisation.Quadruple       quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={2654,-382})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple       eco_riser(
    N_cv=5,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    length=eco_riser.z_out - eco_riser.z_in,
    diameter_i=0.2,
    z_in=0,
    z_out=eco.z_in,
    N_tubes=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.eco_riser.p_in,
        NOM.eco_riser.p_out,
        eco_riser.N_cv),
    h_nom=ones(eco_riser.N_cv)*NOM.eco_riser.h_in,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_start=linspace(
        INIT.eco_riser.p_in,
        INIT.eco_riser.p_out,
        eco_riser.N_cv),
    h_start=ones(eco_riser.N_cv)*INIT.eco_riser.h_in,
    Delta_p_nom=NOM.eco_riser.Delta_p_nom,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={1429,-796})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_flex       splitVLE_L2_flex(
    p_nom=NOM.eco_riser.p_in,
    h_nom=NOM.eco_riser.h_in,
    N_ports_out=4,
    m_flow_out_nom={NOM.eco.m_flow_vle_wall_in,35,35,35},
    volume=0.5,
    h_start=INIT.preheater_HP.h_cond_out,
    p_start=INIT.preheater_HP.p_cond)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={1960,-710})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1       valveVLE_L1_1(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=0.1e5, m_flow_nom=420))                                                                                                               annotation (Placement(transformation(extent={{1996,
            -716},{2016,-704}})));
  Visualisation.Quadruple       quadruple26
    annotation (Placement(transformation(extent={{1686,-530},{1746,-510}})));
  Visualisation.Quadruple       quadruple27
    annotation (Placement(transformation(extent={{1682,-432},{1742,-412}})));
  Visualisation.Quadruple       quadruple28
    annotation (Placement(transformation(extent={{1684,-332},{1744,-312}})));
  Visualisation.Quadruple       quadruple29
    annotation (Placement(transformation(extent={{1538,-410},{1598,-390}})));
  Visualisation.Quadruple       quadruple30
    annotation (Placement(transformation(extent={{1438,-312},{1498,-292}})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple       preheater_HP(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_HP.m_flow_tap,
    p_nom_shell=NOM.preheater_HP.p_tap,
    h_nom_shell=NOM.preheater_HP.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_HP.m_flow_cond,
    h_nom_tubes=NOM.preheater_HP.h_cond_out,
    h_start_tubes=INIT.preheater_HP.h_cond_out,
    N_passes=1,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    length=15,
    z_in_shell=preheater_HP.length,
    p_start_shell=INIT.preheater_HP.p_tap,
    diameter=2.6,
    showExpertSummary=true,
    Tau_cond=0.3,
    Tau_evap=0.03,
    alpha_ph=50000,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=3500),
    p_nom_tubes=NOM.preheater_HP.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_HP.p_cond,
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,
            1000}),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=10),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    T_w_start=ones(3)*(273.15 + 200),
    diameter_i=0.02,
    diameter_o=0.028,
    N_tubes=2000,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1650,10000}),

    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2116,-712})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple       preheater_LP4(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    T_w_start={300,320,340},
    Tau_cond=0.3,
    Tau_evap=0.03,
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP4.length,
    m_flow_nom_shell=NOM.preheater_LP4.m_flow_tap,
    p_nom_shell=NOM.preheater_LP4.p_tap,
    h_nom_shell=NOM.preheater_LP4.h_tap_out,
    diameter_i=0.05,
    diameter_o=0.052,
    m_flow_nom_tubes=NOM.preheater_LP4.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP4.p_cond,
    h_nom_tubes=NOM.preheater_LP4.h_cond_out,
    h_start_tubes=INIT.preheater_LP4.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP4.p_cond,
    level_rel_start=0.1,
    N_passes=2,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    N_tubes=600,
    p_start_shell=INIT.preheater_LP4.p_tap,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),

    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,
            0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2614,-652})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple       preheater_LP1(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_LP1.m_flow_tap,
    p_nom_shell=NOM.preheater_LP1.p_tap,
    h_nom_shell=NOM.preheater_LP1.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_LP1.m_flow_cond,
    h_nom_tubes=NOM.preheater_LP1.h_cond_out,
    h_start_tubes=INIT.preheater_LP1.h_cond_out,
    p_start_shell=INIT.preheater_LP1.p_tap,
    N_passes=1,
    Q_flow_nom=2e8,
    z_in_shell=preheater_LP1.length,
    z_in_tubes=preheater_LP1.diameter/2,
    z_out_tubes=preheater_LP1.diameter/2,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,
            0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),

    p_nom_tubes=NOM.preheater_LP1.p_cond,
    p_start_tubes=INIT.preheater_LP1.p_cond,
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=3,
    diameter_i=0.05,
    diameter_o=0.052,
    level_rel_start=0.1,
    T_w_start={350,400,440},
    N_tubes=1000,
    initOptionWall=1,
    useHomotopy=false)
                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2406,-654})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_BU_simple       condenser(
    initOptionTubes=0,
    height=5,
    width=5,
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),

    z_in_shell=4.9,
    z_out_shell=0.1,
    level_rel_start=0.5/6,
    m_flow_nom_shell=NOM.condenser.m_flow_in,
    p_nom_shell=NOM.condenser.p_condenser,
    p_start_shell=INIT.condenser.p_condenser,
    initOptionShell=204,
    initOptionWall=1,
    levelOutput=true,
    z_in_aux1=4.9,
    z_in_aux2=4.9,
    height_hotwell=2,
    width_hotwell=1,
    length_hotwell=10,
    diameter_i=0.008,
    diameter_o=0.01,
    m_flow_nom_tubes=10000,
    p_nom_tubes=2e5,
    h_start_tubes=85e3,
    p_start_tubes=2e5,
    length=12,
    N_tubes=15000,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={3000,12000}),

    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2)       annotation (Placement(transformation(extent={{2736,
            -590},{2756,-570}})));
  Visualisation.Quadruple       quadruple31
    annotation (Placement(transformation(extent={{1838,-390},{1898,-370}})));
  Visualisation.Quadruple       quadruple32
    annotation (Placement(transformation(extent={{1840,-444},{1900,-424}})));
  Visualisation.Quadruple       quadruple33
    annotation (Placement(transformation(extent={{1606,-494},{1666,-474}})));
  Visualisation.Quadruple       quadruple34
    annotation (Placement(transformation(extent={{1608,-296},{1668,-276}})));
  Visualisation.Quadruple       quadruple35
    annotation (Placement(transformation(extent={{1438,-486},{1498,-466}})));
  Visualisation.Quadruple       quadruple36
    annotation (Placement(transformation(extent={{1438,-408},{1498,-388}})));
  Visualisation.Quadruple       quadruple37
    annotation (Placement(transformation(extent={{1452,-566},{1512,-546}})));
  Visualisation.Quadruple       quadruple38
    annotation (Placement(transformation(extent={{1446,-636},{1506,-616}})));
  Visualisation.Quadruple       quadruple39
    annotation (Placement(transformation(extent={{1446,-754},{1506,-734}})));
  Components.Utilities.Blocks.LimPID       PI_feedwaterPump(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0.01,
    y_ref=NOM.Pump_FW.P_pump,
    y_max=NOM.Pump_FW.P_pump*2,
    k=1,
    Tau_i=2,
    u_ref=NOM.m_flow_nom,
    initOption=503,
    y_start=INIT.Pump_FW.P_pump)
                          annotation (Placement(transformation(extent={{2198,-846},{2218,-866}})));
  Components.Sensors.SensorVLE_L1_m_flow sensorFWflow annotation (Placement(transformation(extent={{2202,-710},{2182,-690}})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh2(m_flow_const=28) "Contrlled spray injection mass flow between sh1 and sh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={1788,-591})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh2(
    volume=0.5,
    p_nom=NOM.sh1.p_vle_bundle_out,
    h_nom=NOM.sh1.h_vle_bundle_out,
    h_start=INIT.sh1.h_vle_bundle_out,
    p_start=INIT.sh1.p_vle_bundle_out,
    initOption=0,
    m_flow_in_nom={380,28}) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={1676,-498})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh4(
    volume=0.5,
    initOption=0,
    m_flow_in_nom={305,15},
    p_nom=NOM.sh3.p_vle_bundle_out,
    h_nom=NOM.sh3.h_vle_bundle_out,
    h_start=INIT.sh3.h_vle_bundle_out,
    p_start=INIT.sh3.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={1676,-300})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh4(m_flow_const=15) "Contrlled spray injection mass flow between sh3 and sh4" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={1824,-591})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_rh2(m_flow_const=1) "Contrlled spray injection mass flow between rh1 and rh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={1926,-591})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh1(
    volume=0.5,
    initOption=0,
    m_flow_in_nom={200,1.5},
    p_nom=NOM.rh1.p_vle_bundle_out,
    h_nom=NOM.rh1.h_vle_bundle_out,
    h_start=INIT.rh1.h_vle_bundle_out,
    p_start=INIT.rh1.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={1902,-390})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=540.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1296,-780})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T=545.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1298,-698})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T=643.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1276,-658})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature4(T=661.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1276,-628})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature6(T=683.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1276,-594})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature7(T=693.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1276,-562})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature8(T=702.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1274,-528})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature9(T=717.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1576,-542})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature10(T=697.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1304,-484})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature11(T=655.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1762,-460})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature12(T=845.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1770,-328})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature13(T=723.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1568,-438})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature14(T=734.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1578,-354})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature15(T=804.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1564,-262})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature16(T=673.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1366,-320})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature17(T=673.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1366,-290})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature18(T=671.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1366,-256})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature19(T=676.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1358,-430})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature20(T=675.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1358,-400})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature21(T=674.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1358,-366})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature22(T=677.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1354,-460})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature23(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1476,-388})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature24(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1476,-358})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature25(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1476,-324})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature26(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1468,-498})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature27(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1468,-468})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature28(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1468,-434})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature29(T=670.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1464,-528})));
equation
  totalHeat =burner1.Q_flow_wall + burner2.Q_flow_wall + burner3.Q_flow_wall + burner4.Q_flow_wall + flameRoom_evap_1.Q_flow_wall + flameRoom_evap_2.Q_flow_wall + flameRoom_sh_1.Q_flow_wall + flameRoom_sh_2.Q_flow_wall + flameRoom_sh_4.Q_flow_wall + flameRoom_rh_2.Q_flow_wall;

  connect(burner1.inlet, hopper.outlet)        annotation (Line(
      points={{-134,-164},{-134,-168},{-136,-168}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_bottom, hopper.heat_top)        annotation (Line(
      points={{-116,-164},{-116,-168},{-118,-168}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.fuelSlagFlueGas_outlet, hopper.inlet)
    annotation (Line(
      points={{-134,-196},{-134,-188},{-136,-188}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_wall, evap_1_wall.outerPhase[1]) annotation (Line(
      points={{-88,-154},{0,-154},{0,-120},{102.4,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_wall, evap_1_wall.outerPhase[2]) annotation (Line(
      points={{-88,-128},{0,-128},{0,-120},{102.2,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(burner3.heat_wall, evap_1_wall.outerPhase[3]) annotation (Line(
      points={{-88,-102},{0,-102},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_evap_1.heat_wall, evap_1_wall.outerPhase[5]) annotation (Line(
      points={{-88,-50},{0,-50},{0,-120},{101.6,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_evap_2.heat_wall, scalar2VectorHeatPort.heatScalar)
    annotation (Line(
      points={{-88,-24},{52,-24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, evap_2_wall.outerPhase) annotation (
     Line(
      points={{72,-24},{100,-24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flameRoom_rh_2.heat_wall, evap_3_wall.outerPhase[4]) annotation (Line(
      points={{-88,86},{0,86},{0,40},{101.625,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flameRoom_rh_1.heat_wall, evap_4_wall.outerPhase[2]) annotation (Line(
      points={{-88,142},{8,142},{8,142},{104,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(scalar2VectorHeatPort13.heatVector, eco_wall.outerPhase) annotation (
      Line(
      points={{74,-298},{89.9998,-298}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort12.heatVector, rh_2_wall.outerPhase) annotation (
     Line(
      points={{544,124},{570,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_1.heat_TubeBundle, scalar2VectorHeatPort11.heatScalar)
    annotation (Line(
      points={{-98,132},{84,132},{84,-2},{534,-2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle, scalar2VectorHeatPort13.heatScalar)
    annotation (Line(
      points={{-98,160},{-40,160},{-40,-298},{54,-298}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_wall, evap_4_wall.outerPhase[3]) annotation (Line(
      points={{-88,170},{0,170},{0,142},{103.667,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_2.heat_TubeBundle, scalar2VectorHeatPort12.heatScalar)
    annotation (Line(
      points={{-98,76},{60,76},{60,124},{524,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(burner4.heat_wall, evap_1_wall.outerPhase[4]) annotation (Line(
      points={{-88,-76},{0,-76},{0,-120},{101.8,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector, evap_0_wall.outerPhase)
    annotation (Line(
      points={{68,-182},{80,-182},{80,-180},{92.0004,-180}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(hopper.heat_wall, scalar2VectorHeatPort2.heatScalar) annotation (Line(
      points={{-90,-178},{-22,-178},{-22,-182},{48,-182}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_1.heat_TubeBundle, scalar2VectorHeatPort1.heatScalar)
    annotation (Line(
      points={{-98,-8},{20,-8},{20,-82},{304,-82}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_1.heat_wall, evap_3_wall.outerPhase[1]) annotation (Line(
      points={{-88,2},{0,2},{0,40},{102.375,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_TubeBundle, scalar2VectorHeatPort9.heatScalar)
    annotation (Line(
      points={{-98,104},{306,104}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_wall, evap_4_wall.outerPhase[1]) annotation (Line(
      points={{-88,114},{0,114},{0,142},{104.333,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_TubeBundle, scalar2VectorHeatPort10.heatScalar)
    annotation (Line(
      points={{-98,48},{40,48},{40,216},{302,216}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_wall, evap_3_wall.outerPhase[3]) annotation (Line(
      points={{-88,58},{0,58},{0,40},{101.875,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_TubeBundle, scalar2VectorHeatPort8.heatScalar)
    annotation (Line(
      points={{-98,20},{308,20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_wall, evap_3_wall.outerPhase[2]) annotation (Line(
      points={{-88,30},{0,30},{0,40},{102.125,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes, ct_1_wall.outerPhase[1]) annotation (
     Line(
      points={{-98,180},{20,180},{20,78},{204.429,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_1.heat_CarrierTubes, ct_1_wall.outerPhase[2])
    annotation (Line(
      points={{-98,152},{20,152},{20,78},{204.286,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_CarrierTubes, ct_1_wall.outerPhase[3])
    annotation (Line(
      points={{-98,124},{20,124},{20,78},{204.143,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_2.heat_CarrierTubes, ct_1_wall.outerPhase[4])
    annotation (Line(
      points={{-98,96},{20,96},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_CarrierTubes, ct_1_wall.outerPhase[5])
    annotation (Line(
      points={{-98,68},{20,68},{20,78},{203.857,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_CarrierTubes, ct_1_wall.outerPhase[6])
    annotation (Line(
      points={{-98,40},{20,40},{20,78},{203.714,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(coalGas_join_burner4.fuelFlueGas_outlet, mill4.inlet) annotation (Line(
      points={{-184,-76},{-178,-76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill4.outlet, burner4.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-76},{-148,-76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner3.fuelFlueGas_outlet, mill3.inlet) annotation (Line(
      points={{-184,-102},{-178,-102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill3.outlet, burner3.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-102},{-148,-102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, mill2.inlet) annotation (Line(
      points={{-184,-128},{-178,-128}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill2.outlet, burner2.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-128},{-154,-128},{-154,-128},{-148,-128}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.fuelFlueGas_outlet, mill1.inlet) annotation (Line(
      points={{-184,-154},{-178,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill1.outlet, burner1.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-154},{-148,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, mill4.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-58},{-168,-58},{-168,-65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill3.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-88},{-168,-88},{-168,-91.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill2.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-116},{-168,-116},{-168,-117.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill1.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-140},{-168,-140},{-168,-143.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(hopper.heat_bottom, boilerLosses.port) annotation (Line(
      points={{-118,-188},{-118,-200},{-100,-200}},
      color={167,25,48},
      thickness=0.5));
  connect(coalFlowSource_bottom.fuel_a, coalSlagFlueGas_join.fuel_inlet) annotation (Line(
      points={{-158,-234},{-158,-222},{-140,-222},{-140,-216}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(slaglSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet) annotation (Line(
      points={{-133.8,-234},{-134,-234},{-134,-216}},
      color={234,171,0},
      thickness=0.5));
  connect(fluelGasFlowSource_bottom.gas_a, coalSlagFlueGas_join.flueGas_inlet) annotation (Line(
      points={{-108,-234},{-108,-222},{-128,-222},{-128,-216}},
      color={118,106,98},
      thickness=0.5));
  connect(coalFlowSource_burner4.fuel_a, coalGas_join_burner4.fuel_inlet) annotation (Line(
      points={{-224,-70},{-204,-70}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner3.fuel_a, coalGas_join_burner3.fuel_inlet) annotation (Line(
      points={{-224,-96},{-204,-96}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner2.fuel_a, coalGas_join_burner2.fuel_inlet) annotation (Line(
      points={{-224,-122},{-204,-122}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner1.fuel_a, coalGas_join_burner1.fuel_inlet) annotation (Line(
      points={{-224,-148},{-204,-148}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalSlagFlueGas_split_top.fuelSlagFlueGas_inlet, flameRoom_eco.outlet) annotation (Line(
      points={{-134,212},{-134,180}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_eco.inlet, flameRoom_rh_1.outlet) annotation (Line(
      points={{-134,160},{-134,152}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_eco.heat_bottom, flameRoom_rh_1.heat_top) annotation (Line(
      points={{-116,160},{-116,152}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_1.outlet, flameRoom_evap_2.inlet) annotation (Line(
      points={{-134,-40},{-134,-34}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_evap_1.heat_top, flameRoom_evap_2.heat_bottom) annotation (Line(
      points={{-116,-40},{-116,-34}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_2.outlet, flameRoom_sh_1.inlet) annotation (Line(
      points={{-134,-14},{-134,-12},{-134,-8},{-134,-8}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_evap_2.heat_top, flameRoom_sh_1.heat_bottom) annotation (Line(
      points={{-116,-14},{-116,-8}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.heat_top, flameRoom_sh_2.heat_bottom) annotation (Line(
      points={{-116,12},{-116,20}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.outlet, flameRoom_sh_2.inlet) annotation (Line(
      points={{-134,12},{-134,16},{-134,16},{-134,20}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_2.outlet, flameRoom_sh_4.inlet) annotation (Line(
      points={{-134,40},{-134,48}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_2.heat_top, flameRoom_sh_4.heat_bottom) annotation (Line(
      points={{-116,40},{-116,48}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_4.outlet, flameRoom_rh_2.inlet) annotation (Line(
      points={{-134,68},{-134,76}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_4.heat_top, flameRoom_rh_2.heat_bottom) annotation (Line(
      points={{-116,68},{-116,76}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_rh_2.heat_top, flameRoom_sh_3.heat_bottom) annotation (Line(
      points={{-116,96},{-116,104}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_rh_2.outlet, flameRoom_sh_3.inlet) annotation (Line(
      points={{-134,96},{-134,104}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_3.outlet, flameRoom_rh_1.inlet) annotation (Line(
      points={{-134,124},{-134,132}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_3.heat_top, flameRoom_rh_1.heat_bottom) annotation (Line(
      points={{-116,124},{-116,132}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_eco.heat_top, fixedTemperature5.port) annotation (Line(
      points={{-116,180},{-116,206},{-94,206}},
      color={167,25,48},
      thickness=0.5));
  connect(burner1.outlet, burner2.inlet) annotation (Line(
      points={{-134,-144},{-134,-138}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.heat_top, burner2.heat_bottom) annotation (Line(
      points={{-116,-144},{-116,-138}},
      color={167,25,48},
      thickness=0.5));
  connect(burner2.outlet, burner3.inlet) annotation (Line(
      points={{-134,-118},{-134,-112}},
      color={118,106,98},
      thickness=0.5));
  connect(burner2.heat_top, burner3.heat_bottom) annotation (Line(
      points={{-116,-118},{-116,-112}},
      color={167,25,48},
      thickness=0.5));
  connect(burner3.outlet, burner4.inlet) annotation (Line(
      points={{-134,-92},{-134,-86}},
      color={118,106,98},
      thickness=0.5));
  connect(burner3.heat_top, burner4.heat_bottom) annotation (Line(
      points={{-116,-92},{-116,-86}},
      color={167,25,48},
      thickness=0.5));
  connect(burner4.outlet, flameRoom_evap_1.inlet) annotation (Line(
      points={{-134,-66},{-134,-60}},
      color={118,106,98},
      thickness=0.5));
  connect(burner4.heat_top, flameRoom_evap_1.heat_bottom) annotation (Line(
      points={{-116,-66},{-116,-60}},
      color={167,25,48},
      thickness=0.5));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_inlet) annotation (Line(
      points={{-182,248},{-134,248},{-134,232}},
      color={234,171,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalSink_top.fuel_a, coalSlagFlueGas_split_top.fuel_outlet) annotation (Line(
      points={{-156,236},{-140,236},{-140,232}},
      color={27,36,42},
      thickness=0.5));
  connect(flameRoom_sh_1.heat_CarrierTubes, ct_1_wall.outerPhase[7]) annotation (Line(
      points={{-98,12},{20,12},{20,78},{203.571,78}},
      color={167,25,48},
      thickness=0.5));
  connect(regenerativeAirPreheater.freshAirOutlet, splitGas_L2_flex.inlet) annotation (Line(
      points={{-392,18},{-406,18},{-406,-106},{-400,-106}},
      color={118,106,98},
      thickness=0.5));
  connect(fluelGasFlowSource_burner1.gas_a, regenerativeAirPreheater.freshAirInlet) annotation (Line(
      points={{-420,30},{-392,30}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasOutlet, flueGasPressureSink_top.gas_a) annotation (Line(
      points={{-372,30},{-328,30},{-328,48}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_outlet) annotation (Line(
      points={{-372,18},{-290,18},{-290,276},{-128,276},{-128,232}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.u_m,actual_lambda. y) annotation (Line(
      points={{-503.9,48},{-503.9,66},{-545,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda.y,PID_lambda. u_s) annotation (Line(
      points={{-545,36},{-516,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, coalFlowSource_burner2.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-116},{-244,-116}}, color={0,0,127}));
  connect(gain.y, coalFlowSource_burner1.m_flow) annotation (Line(points={{-379,-142},{-244,-142}},                         color={0,0,127}));
  connect(gain.y, coalFlowSource_burner3.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-90},{-244,-90}}, color={0,0,127}));
  connect(gain.y, coalFlowSource_burner4.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-64},{-244,-64}}, color={0,0,127}));
  connect(splitGas_L2_flex.outlet[1], coalGas_join_burner4.flueGas_inlet) annotation (Line(
      points={{-380,-106.375},{-376,-106.375},{-376,-82},{-204,-82}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[2], coalGas_join_burner3.flueGas_inlet) annotation (Line(
      points={{-380,-106.125},{-376,-106.125},{-376,-108},{-204,-108}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[3], coalGas_join_burner2.flueGas_inlet) annotation (Line(
      points={{-380,-105.875},{-376,-105.875},{-376,-134},{-204,-134}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[4], coalGas_join_burner1.flueGas_inlet) annotation (Line(
      points={{-380,-105.625},{-376,-105.625},{-376,-160},{-204,-160}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.y, firstOrder.u) annotation (Line(points={{-493,36},{-480,36}}, color={0,0,127}));
  connect(firstOrder.y, fluelGasFlowSource_burner1.m_flow) annotation (Line(points={{-457,36},{-440,36}}, color={0,0,127}));
  connect(scalar2VectorHeatPort11.heatVector, rh_1_wall.outerPhase) annotation (Line(
      points={{554,-2},{572,-2}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort1.heatVector, sh_1_wall.outerPhase) annotation (Line(
      points={{324,-82},{344,-82}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort8.heatVector, sh_2_wall.outerPhase) annotation (Line(
      points={{328,20},{348,20}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort9.heatVector, sh_3_wall.outerPhase) annotation (Line(
      points={{326,104},{348,104}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort10.heatVector, sh_4_wall.outerPhase) annotation (Line(
      points={{322,216},{341,216}},
      color={167,25,48},
      thickness=0.5));
  connect(burner1.eyeOut, quadrupleGas.eye) annotation (Line(points={{-148,-146},{-152,-146},{-152,-141},{-82,-141}}, color={190,190,190}));
  connect(quadrupleGas6.eye, flameRoom_sh_1.eyeOut) annotation (Line(points={{-176,10},{-148,10}},                     color={190,190,190}));
  connect(quadrupleGas5.eye, flameRoom_evap_2.eyeOut) annotation (Line(points={{-174,-16},{-148,-16}},                       color={190,190,190}));
  connect(quadrupleGas4.eye, flameRoom_evap_1.eyeOut) annotation (Line(points={{-72,-42},{-148,-42}},                       color={190,190,190}));
  connect(quadrupleGas3.eye, burner4.eyeOut) annotation (Line(points={{-72,-68},{-148,-68}},                       color={190,190,190}));
  connect(quadrupleGas2.eye, burner3.eyeOut) annotation (Line(points={{-74,-94},{-148,-94}},                       color={190,190,190}));
  connect(quadrupleGas1.eye, burner2.eyeOut) annotation (Line(points={{-80,-120},{-148,-120}},                         color={190,190,190}));
  connect(quadrupleGas12.eye, flameRoom_eco.eyeOut) annotation (Line(points={{-182,198},{-182,198},{-182,178},{-166,178},{-166,178},{-148,178}},
                                                                                                                           color={190,190,190}));
  connect(quadrupleGas11.eye, flameRoom_rh_1.eyeOut) annotation (Line(points={{-178,150},{-148,150}},                       color={190,190,190}));
  connect(quadrupleGas10.eye, flameRoom_sh_3.eyeOut) annotation (Line(points={{-178,122},{-148,122}},                       color={190,190,190}));
  connect(quadrupleGas9.eye, flameRoom_rh_2.eyeOut) annotation (Line(points={{-176,94},{-148,94}},                     color={190,190,190}));
  connect(quadrupleGas8.eye, flameRoom_sh_4.eyeOut) annotation (Line(points={{-178,66},{-148,66}},                     color={190,190,190}));
  connect(quadrupleGas7.eye, flameRoom_sh_2.eyeOut) annotation (Line(points={{-178,38},{-148,38}},                     color={190,190,190}));
  connect(quadrupleGas13.eye, regenerativeAirPreheater.eye_freshAir) annotation (Line(points={{-390,-3},{-392,-3},{-392,8},{-392.2,8},{-392.2,15.4}}, color={190,190,190}));
  connect(regenerativeAirPreheater.eye_flueGas, quadrupleGas14.eye) annotation (Line(points={{-371.8,32.6},{-371.8,37.3},{-366,37.3},{-366,41}}, color={190,190,190}));
  connect(PTarget.y, feedForwardBlock_3508_1.P_G_target_) annotation (Line(points={{-455,-396},{-444,-396}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_max_, P_max_.y) annotation (Line(points={{-440,-380},{-440,-364},{-457,-364}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_min_, P_min_.y) annotation (Line(points={{-436,-380},{-436,-346},{-457,-346}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_max_) annotation (Line(points={{-457,-328},{-432,-328},{-432,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_StG_) annotation (Line(points={{-457,-328},{-428,-328},{-428,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_T_) annotation (Line(points={{-457,-328},{-424,-328},{-424,-380}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.QF_FF_, firstOrder1.u) annotation (Line(points={{-421,-396},{-416.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, rollerBowlMill_L1_1.rawCoal) annotation (Line(points={{-407.6,-396},{-390.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, gain.u) annotation (Line(points={{-407.6,-396},{-406,-396},{-406,-142},{-402,-142}}, color={0,0,127}));
  connect(scalar2VectorHeatPort3.heatVector, evap_2_wall1.outerPhase)
    annotation (Line(
      points={{1378,-484},{1406,-484}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_1.outlet,evap_2. inlet) annotation (Line(
      points={{1429,-566},{1429,-498}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_2.outlet,evap_3. inlet) annotation (Line(
      points={{1429,-470},{1429,-434}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_3.outlet,evap_4. inlet) annotation (Line(
      points={{1429,-406},{1429,-332}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_wall1.innerPhase, eco.heat)
    annotation (Line(
      points={{1406,-758},{1425,-758}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort14.heatVector, eco_wall1.outerPhase)
    annotation (Line(
      points={{1380,-758},{1396,-758}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rh_2_wall1.innerPhase, rh_2.heat)
    annotation (Line(
      points={{1886,-336},{1898,-336}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort16.heatVector, rh_2_wall1.outerPhase)
    annotation (Line(
      points={{1850,-336},{1876,-336}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sh_4_out_T.port,sh_4. outlet) annotation (Line(
      points={{1692,-230},{1676,-230}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort17.heatVector, evap_0_wall1.outerPhase)
    annotation (Line(
      points={{1374,-640},{1398,-640}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_0_wall1.innerPhase, evap_0.heat)
    annotation (Line(
      points={{1408,-640},{1425,-640}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_down_wall.innerPhase,eco_down. heat) annotation (Line(
      points={{1418,-704},{1425,-704}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(separator_wall.innerPhase,separator. heat) annotation (Line(
      points={{1479.8,-265.68},{1480,-265.68},{1480,-272}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(separator.inlet,evap_4. outlet) annotation (Line(
      points={{1470,-282},{1429,-282},{1429,-304}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_1.inlet,separator. outlet) annotation (Line(
      points={{1535,-368},{1535,-282},{1490,-282}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rh_pipe_wall.innerPhase,rh_pipe. heat) annotation (Line(
      points={{1886,-288},{1898,-288}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sh_pipe_wall.innerPhase,sh_pipe. heat) annotation (Line(
      points={{1658,-198},{1672,-198}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_1.outlet,sh_1. inlet) annotation (Line(
      points={{1535,-396},{1535,-580},{1676,-580},{1676,-556}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_2.outlet,sh_3. inlet) annotation (Line(
      points={{1678,-426},{1678,-398},{1676,-398},{1676,-370}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_4.outlet,sh_pipe. inlet) annotation (Line(
      points={{1676,-230},{1676,-212}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_2.outlet,rh_pipe. inlet) annotation (Line(
      points={{1902,-322},{1902,-302}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(PI_valveControl_preheater_HP.y,valveControl_preheater_HP. opening_in) annotation (Line(
      points={{2155,-780},{2160,-780},{2160,-759}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet,Turbine_LP1. outlet) annotation (Line(
      points={{2466,-490},{2462,-490}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet,Turbine_HP1. outlet) annotation (Line(
      points={{2128,-512},{2158,-512},{2158,-490}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2,valve_HP. inlet) annotation (Line(
      points={{2118,-522},{2118,-550}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.outlet,join_LP_main. inlet1) annotation (Line(
      points={{2356,-652},{2346,-652}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_preheaterLP1.y,Pump_preheater_LP1. P_drive) annotation (Line(
      points={{2403,-780},{2366,-780},{2366,-712}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Turbine_HP1.eye,quadruple4. eye) annotation (Line(
      points={{2159,-486},{2166,-486},{2166,-420}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP1.eye,quadruple3. eye) annotation (Line(
      points={{2243,-486},{2246,-486},{2246,-420},{2266,-420}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye,quadruple7. eye) annotation (Line(
      points={{2463,-486},{2476,-486},{2476,-382},{2624,-382}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP4.eye,quadruple. eye) annotation (Line(
      points={{2583,-486},{2588,-486},{2588,-460},{2596,-460}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye,feedWaterTank. eye) annotation (Line(
      points={{2258,-680},{2258,-669}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye,valve_IP1. eye) annotation (Line(
      points={{2302,-580},{2292,-580},{2292,-570}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye,valve_IP3. eye) annotation (Line(
      points={{2410,-580},{2402,-580},{2402,-570}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve_HP.eye,quadruple11. eye) annotation (Line(
      points={{2114,-570},{2114,-579.7},{2124,-579.7},{2124,-580}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye,valveControl_preheater_HP. eye) annotation (Line(
      points={{2150,-734},{2180,-734},{2180,-746},{2170,-746}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye,Pump_cond. eye) annotation (Line(
      points={{2688,-620},{2688,-652},{2705,-652}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye,Pump_preheater_LP1. eye) annotation (Line(
      points={{2340,-678},{2340,-694},{2355,-694}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet,join_LP_main. inlet2) annotation (Line(
      points={{2356,-700},{2336,-700},{2336,-662}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet,feedWaterTank. condensate) annotation (Line(
      points={{2326,-652},{2300,-652}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP2.outlet,split_IP2. inlet) annotation (Line(
      points={{2282,-490},{2286,-490}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_IP2.outlet1,Turbine_IP3. inlet) annotation (Line(
      points={{2306,-490},{2306,-474},{2312,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP3.outlet,join_IP3. inlet) annotation (Line(
      points={{2322,-490},{2396,-490}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP2.eye,quadruple15. eye) annotation (Line(points={{2283,-486},{2286,-486},{2286,-440}},
                                                                                               color={190,190,190}));
  connect(Turbine_IP3.eye,quadruple16. eye) annotation (Line(points={{2323,-486},{2326,-486},{2326,-460}},
                                                                                                  color={190,190,190}));
  connect(split_IP2.outlet2,valve_IP1. inlet) annotation (Line(
      points={{2296,-500},{2296,-550}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet1,Turbine_LP1. inlet) annotation (Line(
      points={{2416,-490},{2446,-490},{2446,-474},{2452,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP2.outlet,join_LP2. inlet) annotation (Line(
      points={{2502,-490},{2506,-490}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet1,Turbine_LP3. inlet) annotation (Line(
      points={{2526,-490},{2526,-474},{2532,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet1,Turbine_LP4. inlet) annotation (Line(
      points={{2566,-490},{2566,-474},{2572,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP3.outlet,join_LP3. inlet) annotation (Line(
      points={{2542,-490},{2546,-490}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.In1,valve_LP2. outlet) annotation (Line(
      points={{2476,-644.2},{2476,-570}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out1,valveControl_preheater_LP2. inlet) annotation (Line(
      points={{2476,-664},{2476,-670}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP2.outlet,preheater_LP3. aux1) annotation (Line(
      points={{2476,-690},{2476,-700},{2498,-700},{2498,-646},{2536,-646}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.outlet,preheater_LP2. In2) annotation (Line(
      points={{2500,-650},{2494,-650},{2494,-652},{2486,-652}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.inlet1,preheater_LP3. Out2) annotation (Line(
      points={{2520,-650},{2526,-650},{2526,-636},{2574,-636},{2574,-648},{2556,-648}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP3.Out1,Pump_preheater_LP3. inlet) annotation (Line(
      points={{2546,-664},{2546,-700},{2536,-700}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_preheater_LP3.outlet,valve_afterPumpLP3. inlet) annotation (Line(
      points={{2516,-700},{2510,-700},{2510,-690}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_afterPumpLP3.outlet,join_preheater_LP3. inlet2) annotation (Line(
      points={{2510,-670},{2510,-660}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet2,valve_IP3. inlet) annotation (Line(
      points={{2406,-500},{2406,-550}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet2,valve_LP2. inlet) annotation (Line(
      points={{2476,-500},{2476,-550}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet2,valve_LP3. inlet) annotation (Line(
      points={{2516,-500},{2516,-540},{2546,-540},{2546,-550}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet2,valve_LP4. inlet) annotation (Line(
      points={{2556,-500},{2556,-530},{2616,-530},{2616,-550}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_LP3.outlet,preheater_LP3. In1) annotation (Line(
      points={{2546,-570},{2546,-644}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_preheaterLP4.y,PID_preheaterLP4. u_s) annotation (Line(points={{2592.7,-770},{2602,-770},{2602,-780},{2612,-780}},
                                                                                                                                  color={0,0,127}));
  connect(PID_preheaterLP4.y,valveControl_preheater_LP4. opening_in) annotation (Line(points={{2635,-780},{2656,-780},{2656,-709}},
                                                                                                                                 color={0,0,127}));
  connect(preheater_LP3.level,PID_preheaterLP3. u_m) annotation (Line(points={{2554,-665},{2553.9,-665},{2553.9,-768}},
                                                                                                                     color={0,0,127}));
  connect(PID_preheaterLP3.y,Pump_preheater_LP3. P_drive) annotation (Line(points={{2543,-780},{2526,-780},{2526,-712}},
                                                                                                                      color={0,0,127}));
  connect(setPoint_preheaterLP3.y,PID_preheaterLP3. u_s) annotation (Line(points={{2577.3,-780},{2566,-780}},
                                                                                                            color={0,0,127}));
  connect(PID_preheaterLP2.y,valveControl_preheater_LP2. opening_in) annotation (Line(points={{2473,-780},{2462,-780},{2462,-680},{2467,-680}}, color={0,0,127}));
  connect(preheater_LP2.level,PID_preheaterLP2. u_m) annotation (Line(points={{2484,-665},{2484,-768},{2483.9,-768}}, color={0,0,127}));
  connect(setPoint_preheaterLP2.y,PID_preheaterLP2. u_s) annotation (Line(points={{2505.3,-780},{2496,-780}}, color={0,0,127}));
  connect(setPoint_preheaterLP1.y,PID_preheaterLP1. u_s) annotation (Line(points={{2435.3,-780},{2426,-780}}, color={0,0,127}));
  connect(Turbine_LP3.eye,quadruple18. eye) annotation (Line(points={{2543,-486},{2546,-486},{2546,-440},{2586,-440}},
                                                                                                           color={190,190,190}));
  connect(Turbine_LP2.eye,quadruple17. eye) annotation (Line(points={{2503,-486},{2506,-486},{2506,-420},{2566,-420}},
                                                                                                             color={190,190,190}));
  connect(Turbine_HP1.shaft_b,Turbine_IP1. shaft_a) annotation (Line(points={{2162,-480},{2228,-480}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP1.shaft_b,Turbine_IP2. shaft_a) annotation (Line(points={{2246,-480},{2268,-480}},
                                                                                               color={0,0,0}));
  connect(Turbine_IP2.shaft_b,Turbine_IP3. shaft_a) annotation (Line(points={{2286,-480},{2308,-480}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP3.shaft_b,Turbine_LP1. shaft_a) annotation (Line(points={{2326,-480},{2448,-480}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP1.shaft_b,Turbine_LP2. shaft_a) annotation (Line(points={{2466,-480},{2488,-480}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP2.shaft_b,Turbine_LP3. shaft_a) annotation (Line(points={{2506,-480},{2528,-480}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP3.shaft_b,Turbine_LP4. shaft_a) annotation (Line(points={{2546,-480},{2568,-480}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP4.shaft_b,inertia. flange_a) annotation (Line(points={{2586,-480},{2718,-480}},
                                                                                              color={0,0,0}));
  connect(inertia.flange_b,simpleGenerator. shaft) annotation (Line(points={{2738,-480},{2738,-480.1},{2748,-480.1}}, color={0,0,0}));
  connect(simpleGenerator.powerConnection,boundaryElectricFrequency. electricPortIn) annotation (Line(
      points={{2768,-480},{2788,-480}},
      color={115,150,0},
      thickness=0.5));
  connect(valve_LP2.eye,quadruple19. eye) annotation (Line(points={{2472,-570},{2472,-580},{2480,-580}},
                                                                                                   color={190,190,190}));
  connect(valve_LP3.eye,quadruple20. eye) annotation (Line(points={{2542,-570},{2542,-580},{2550,-580}},
                                                                                                   color={190,190,190}));
  connect(valve_LP4.eye,quadruple21. eye) annotation (Line(points={{2612,-570},{2612,-580},{2622,-580}},
                                                                                                   color={190,190,190}));
  connect(setPoint_preheater_HP.y,PI_valveControl_preheater_HP. u_m) annotation (Line(points={{2130.6,-796},{2144.1,-796},{2144.1,-792}},
                                                                                                                                   color={0,0,127}));
  connect(preheater_LP2.level,fillingLevel_preheater_LP2. u_in) annotation (Line(points={{2484,-665},{2482,-665},{2482,-664},{2483,-664}},
                                                                                                                                       color={0,0,127}));
  connect(preheater_LP3.level,fillingLevel_preheater_LP3. u_in) annotation (Line(points={{2554,-665},{2554,-664},{2553,-664}},
                                                                                                                            color={0,0,127}));
  connect(Turbine_IP1.outlet,Turbine_IP2. inlet) annotation (Line(
      points={{2242,-490},{2266,-490},{2266,-474},{2272,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet1,Turbine_LP2. inlet) annotation (Line(
      points={{2486,-490},{2486,-474},{2492,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.eye2,quadruple22. eye) annotation (Line(points={{2465,-654},{2440,-654},{2440,-620},{2410,-620}},
                                                                                                                      color={190,190,190}));
  connect(preheater_LP3.eye2,quadruple23. eye) annotation (Line(points={{2557,-646},{2576,-646},{2576,-630},{2550,-630},{2550,-620}},       color={190,190,190}));
  connect(downComer_feedWaterTank.outlet,Pump_FW. inlet) annotation (Line(
      points={{2254,-703},{2254,-710},{2236,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedWaterTank.feedwater,downComer_feedWaterTank. inlet) annotation (Line(
      points={{2254,-668},{2254,-675}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_IP1.outlet,feedWaterTank. heatingSteam) annotation (Line(
      points={{2296,-570},{2296,-642},{2260,-642},{2260,-650}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_HP.outlet,feedWaterTank. aux) annotation (Line(
      points={{2170,-750},{2318,-750},{2318,-648},{2296,-648},{2296,-652}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_condenser.y,PI_Pump_cond. u_s) annotation (Line(points={{2777.3,-780},{2768,-780}},
                                                                                                     color={0,0,127}));
  connect(motor.shaft,Pump_cond. shaft) annotation (Line(points={{2716,-680},{2716,-667.9}},
                                                                                           color={0,0,0}));
  connect(measurement.y,PI_Pump_cond. u_m) annotation (Line(points={{2781.6,-800},{2755.9,-800},{2755.9,-792}},
                                                                                                             color={0,0,127}));
  connect(fixedVoltage.y,motor. U_term) annotation (Line(points={{2702.7,-720},{2716,-720},{2716,-702}},
                                                                                                      color={0,0,127}));
  connect(PI_Pump_cond.y,motor. f_term) annotation (Line(points={{2745,-780},{2720,-780},{2720,-702}},
                                                                                                    color={0,0,127}));
  connect(valveControl_preheater_LP1.outlet,boundaryVLE_phxi. steam_a) annotation (Line(
      points={{2802,-560},{2806,-560}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.outlet,Turbine_HP1. inlet) annotation (Line(
      points={{1676,-184},{1676,-158},{2148,-158},{2148,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_1.inlet,join_HP. outlet1) annotation (Line(
      points={{1902,-476},{1902,-512},{2108,-512}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_pipe.outlet,Turbine_IP1. inlet) annotation (Line(
      points={{1902,-274},{1902,-242},{2232,-242},{2232,-474}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.eye,quadruple2. eye) annotation (Line(points={{1679.4,-183.4},{1679.4,-172},{1712,-172}},
                                                                                                          color={190,190,190}));
  connect(rh_pipe.eye,quadruple1. eye) annotation (Line(points={{1905.4,-273.4},{1905.4,-258},{1938,-258}},  color={190,190,190}));
  connect(eco_riser.outlet,eco. inlet) annotation (Line(
      points={{1429,-782},{1429,-772}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(eco_riser_wall.innerPhase,eco_riser. heat) annotation (Line(
      points={{1414,-796},{1425,-796}},
      color={167,25,48},
      thickness=0.5));
  connect(splitVLE_L2_flex.outlet[1],eco_riser. inlet) annotation (Line(
      points={{1950,-709.625},{1950,-710},{1788,-710},{1788,-816},{1429,-816},{1429,-810}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitVLE_L2_flex.inlet,valveVLE_L1_1. inlet) annotation (Line(
      points={{1970,-710},{1996,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_1.eye,quadruple26. eye) annotation (Line(points={{1679.4,-527.4},{1679.4,-526},{1680,-526},{1680,-520},{1686,-520}},
                                                                                                                             color={190,190,190}));
  connect(sh_2.eye,quadruple27. eye) annotation (Line(points={{1681.4,-425.4},{1681.4,-422},{1682,-422}},
                                                                                                      color={190,190,190}));
  connect(sh_3.eye,quadruple28. eye) annotation (Line(points={{1679.4,-341.4},{1679.4,-322},{1684,-322}},                   color={190,190,190}));
  connect(quadruple30.eye,evap_4. eye) annotation (Line(points={{1438,-302},{1432.4,-302},{1432.4,-303.4}},                   color={190,190,190}));
  connect(ct_1.eye,quadruple29. eye) annotation (Line(points={{1538.4,-396.6},{1538,-396.6},{1538,-400}},color={190,190,190}));
  connect(preheater_HP.level,fillingLevel_preheater_HP. u_in) annotation (Line(points={{2124,-723},{2124,-724},{2126,-724},{2126,-722},{2125,-722}},
                                                                                                                                     color={0,0,127}));
  connect(preheater_HP.level,PI_valveControl_preheater_HP. u_s) annotation (Line(points={{2124,-723},{2124,-780},{2132,-780}},
                                                                                                                            color={0,0,127}));
  connect(valveVLE_L1_1.outlet,preheater_HP. Out2) annotation (Line(
      points={{2016,-710},{2106,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(statePoint.port,preheater_HP. Out2) annotation (Line(
      points={{2046,-710},{2106,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_HP.eye2,quadruple25. eye) annotation (Line(points={{2105,-712},{2034,-712},{2034,-722},{2036,-722}},                   color={190,190,190}));
  connect(preheater_HP.Out1,valveControl_preheater_HP. inlet) annotation (Line(
      points={{2116,-722},{2116,-750},{2150,-750}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_HP.outlet,preheater_HP. In1) annotation (Line(
      points={{2118,-570},{2118,-702.2},{2116,-702.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out2,preheater_LP3. In2) annotation (Line(
      points={{2624,-646},{2636,-646},{2636,-636},{2590,-636},{2590,-658},{2556,-658}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.outlet,preheater_LP4. In2) annotation (Line(
      points={{2706,-658},{2666,-658},{2666,-656},{2624,-656}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out1,valveControl_preheater_LP4. inlet) annotation (Line(
      points={{2614,-662},{2614,-700},{2646,-700}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.level,fillingLevel_preheater_LP4. u_in) annotation (Line(points={{2622,-663},{2622,-666},{2624,-666},{2624,-664},{2623,-664}},
                                                                                                                                           color={0,0,127}));
  connect(preheater_LP4.level,PID_preheaterLP4. u_m) annotation (Line(points={{2622,-663},{2622,-768},{2624.1,-768}}, color={0,0,127}));
  connect(quadruple24.eye,preheater_LP4. eye2) annotation (Line(points={{2622,-620},{2620,-620},{2620,-642},{2625,-642},{2625,-644}}, color={190,190,190}));
  connect(preheater_LP1.In1,valve_IP3. outlet) annotation (Line(
      points={{2406,-644.2},{2406,-644.2},{2406,-570},{2406,-570}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.Out1,Pump_preheater_LP1. inlet) annotation (Line(
      points={{2406,-664},{2406,-664},{2406,-700},{2376,-700}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out2,preheater_LP1. In2) annotation (Line(
      points={{2466,-652},{2416,-652}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valvePreFeedWaterTank.inlet,preheater_LP1. Out2) annotation (Line(
      points={{2376,-652},{2396,-652}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.level,fillingLevel_preheater_LP1. u_in) annotation (Line(points={{2414,-665},{2414,-666},{2414,-666},{2414,-666},{2414,-664},
          {2413,-664}},                                                                                                                    color={0,0,127}));
  connect(preheater_LP1.level,PID_preheaterLP1. u_m) annotation (Line(points={{2414,-665},{2414,-716},{2413.9,-716},{2413.9,-768}}, color={0,0,127}));
  connect(preheater_LP4.In1,valve_LP4. outlet) annotation (Line(
      points={{2614,-642},{2614,-606},{2616,-606},{2616,-570}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP1.inlet,condenser. Out2) annotation (Line(
      points={{2782,-560},{2782,-560},{2774,-560},{2774,-574},{2756,-574}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a,condenser. In2) annotation (Line(
      points={{2806,-600},{2774,-600},{2774,-584},{2756,-584},{2756,-584}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP4.outlet,condenser. In1) annotation (Line(
      points={{2582,-490},{2582,-512},{2746,-512},{2746,-570.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.aux1,valveControl_preheater_LP4. outlet) annotation (Line(
      points={{2736,-572},{2686,-572},{2686,-700},{2666,-700}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.inlet,condenser. Out1) annotation (Line(
      points={{2726,-658},{2746,-658},{2746,-614},{2746,-614},{2746,-590}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fillingLevel_condenser.u_in,condenser. level) annotation (Line(points={{2753,-590},{2754,-590},{2754,-594},{2754,-592},{2754,-592},{2754,
          -591}},                                                                                                                                          color={0,0,127}));
  connect(condenser.level,measurement. u) annotation (Line(points={{2754,-591},{2754,-666},{2808,-666},{2808,-800},{2790.8,-800}}, color={0,0,127}));
  connect(condenser.eye1,quadruple5. eye) annotation (Line(points={{2750,-591},{2750,-618},{2756,-618},{2756,-620}}, color={190,190,190}));
  connect(quadruple10.eye,preheater_LP1. eye2) annotation (Line(points={{2336,-620},{2354,-620},{2354,-620},{2396,-620},{2396,-654},{2395,-654}}, color={190,190,190}));
  connect(scalar2VectorHeatPort15.heatVector, rh_1_wall1.outerPhase)
    annotation (Line(
      points={{1860,-462},{1878,-462}},
      color={167,25,48},
      thickness=0.5));
  connect(rh_1_wall1.innerPhase, rh_1.heat) annotation (Line(
      points={{1888,-462},{1898,-462}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort4.heatVector, sh_1_wall1.outerPhase)
    annotation (Line(
      points={{1630,-542},{1650,-542}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_1_wall1.innerPhase, sh_1.heat) annotation (Line(
      points={{1660,-542},{1672,-542}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort5.heatVector, sh_2_wall1.outerPhase)
    annotation (Line(
      points={{1634,-440},{1654,-440}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_2_wall1.innerPhase, sh_2.heat) annotation (Line(
      points={{1664,-440},{1674,-440}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort6.heatVector, sh_3_wall1.outerPhase)
    annotation (Line(
      points={{1632,-356},{1654,-356}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_3_wall1.innerPhase, sh_3.heat) annotation (Line(
      points={{1664,-356},{1672,-356}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort7.heatVector, sh_4_wall1.outerPhase)
    annotation (Line(
      points={{1628,-244},{1647,-244}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_4_wall1.innerPhase, sh_4.heat) annotation (Line(
      points={{1657,-244},{1672,-244}},
      color={167,25,48},
      thickness=0.5));
  connect(ct_1_wall1.innerPhase, ct_1.heat) annotation (Line(
      points={{1520,-382},{1531,-382}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_4_wall1.innerPhase, evap_4.heat)
    annotation (Line(
      points={{1420,-318},{1422,-318},{1422,-318},{1425,-318}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_3_wall1.innerPhase, evap_3.heat) annotation (Line(
      points={{1418,-420},{1425,-420}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_2_wall1.innerPhase, evap_2.heat) annotation (Line(
      points={{1416,-484},{1425,-484}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_1_wall1.innerPhase, evap_1.heat)
    annotation (Line(
      points={{1418,-580},{1422,-580},{1422,-580},{1425,-580}},
      color={167,25,48},
      thickness=0.5));
  connect(quadruple32.eye,rh_1. eye) annotation (Line(points={{1840,-434},{1905.4,-434},{1905.4,-447.4}},
                                                                                                      color={190,190,190}));
  connect(evap_3.eye,quadruple36. eye) annotation (Line(points={{1432.4,-405.4},{1432.4,-398},{1438,-398}},
                                                                                                        color={190,190,190}));
  connect(evap_2.eye,quadruple35. eye) annotation (Line(points={{1432.4,-469.4},{1438,-469.4},{1438,-476}},            color={190,190,190}));
  connect(evap_1.eye,quadruple37. eye) annotation (Line(points={{1432.4,-565.4},{1432.4,-556},{1452,-556}},color={190,190,190}));
  connect(evap_0.eye,quadruple38. eye) annotation (Line(points={{1432.4,-625.4},{1432.4,-626},{1446,-626}},  color={190,190,190}));
  connect(eco.eye,quadruple39. eye) annotation (Line(points={{1432.4,-743.4},{1432.4,-744},{1446,-744}},  color={190,190,190}));
  connect(rollerBowlMill_L1_1.coalDust,Nominal_PowerFeedwaterPump1. u) annotation (Line(points={{-369,-396},{902,-396},{902,-856},{2171.2,-856}},
                                                                                                                           color={0,0,127}));
  connect(Nominal_PowerFeedwaterPump1.y,PI_feedwaterPump. u_s) annotation (Line(points={{2180.4,-856},{2196,-856}},
                                                                                                                  color={0,0,127}));
  connect(sensorFWflow.m_flow,PI_feedwaterPump. u_m) annotation (Line(points={{2181,-700},{2208.1,-700},{2208.1,-844}},
                                                                                                                     color={0,0,127}));
  connect(PI_feedwaterPump.y,Pump_FW. P_drive) annotation (Line(points={{2219,-856},{2226,-856},{2226,-722}},
                                                                                                           color={0,0,127}));
  connect(preheater_HP.In2,sensorFWflow. outlet) annotation (Line(
      points={{2126,-710},{2182,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorFWflow.inlet,Pump_FW. outlet) annotation (Line(
      points={{2202,-710},{2216,-710}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_1.outlet,sprayInjector_sh2. inlet1) annotation (Line(
      points={{1676,-528},{1676,-508}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.outlet,sh_2. inlet) annotation (Line(
      points={{1676,-488},{1676,-454},{1678,-454}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.inlet2,injectionControl_sh2. outlet) annotation (Line(
      points={{1686,-498},{1788,-498},{1788,-581}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh2.inlet,splitVLE_L2_flex. outlet[3]) annotation (Line(
      points={{1788,-601},{1788,-710.125},{1950,-710.125}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_3.outlet,sprayInjector_sh4. inlet1) annotation (Line(
      points={{1676,-342},{1676,-310}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh4.outlet,sh_4. inlet) annotation (Line(
      points={{1676,-290},{1676,-258}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.inlet,splitVLE_L2_flex. outlet[4]) annotation (Line(
      points={{1824,-601},{1824,-710.375},{1950,-710.375}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.outlet,sprayInjector_sh4. inlet2) annotation (Line(
      points={{1824,-581},{1824,-300},{1686,-300}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_1.outlet,sprayInjector_sh1. inlet1) annotation (Line(
      points={{1902,-448},{1902,-400}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh1.outlet,rh_2. inlet) annotation (Line(
      points={{1902,-380},{1902,-350}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.outlet,sprayInjector_sh1. inlet2) annotation (Line(
      points={{1926,-581},{1926,-390},{1912,-390}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.inlet,splitVLE_L2_flex. outlet[2]) annotation (Line(
      points={{1926,-601},{1926,-709.875},{1950,-709.875}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple33.eye,sprayInjector_sh2. eye) annotation (Line(points={{1606,-484},{1668,-484},{1668,-488}},
                                                                                                         color={190,190,190}));
  connect(quadruple34.eye,sprayInjector_sh4. eye) annotation (Line(points={{1608,-286},{1668,-286},{1668,-290}},
                                                                                                           color={190,190,190}));
  connect(quadruple31.eye,sprayInjector_sh1. eye) annotation (Line(points={{1838,-380},{1894,-380}},    color={190,190,190}));
  connect(eco.outlet,eco_down. inlet) annotation (Line(
      points={{1429,-744},{1429,-744},{1429,-718}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(eco_down.outlet,evap_0. inlet) annotation (Line(
      points={{1429,-690},{1429,-673},{1429,-673},{1429,-654}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(evap_0.outlet,evap_1. inlet) annotation (Line(
      points={{1429,-626},{1429,-610},{1429,-610},{1429,-594}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fixedTemperature1.port,scalar2VectorHeatPort14. heatScalar)
    annotation (Line(points={{1306,-780},{1338,-780},{1338,-758},{1360,-758}},
                                                                      color={191,0,0}));
  connect(scalar2VectorHeatPort17.heatScalar, fixedTemperature2.port)
    annotation (Line(
      points={{1354,-640},{1354,-644},{1330,-644},{1330,-698},{1308,-698}},
      color={167,25,48},
      thickness=0.5));
  connect(fixedTemperature3.port, evap_1_wall1.outerPhase[1])
    annotation (Line(points={{1286,-658},{1322,-658},{1322,-580},{1408,-580}}, color={191,0,0}));
  connect(fixedTemperature4.port, evap_1_wall1.outerPhase[2])
    annotation (Line(points={{1286,-628},{1322,-628},{1322,-580},{1408,-580}}, color={191,0,0}));
  connect(fixedTemperature6.port, evap_1_wall1.outerPhase[3])
    annotation (Line(points={{1286,-594},{1322,-594},{1322,-580},{1408,-580}}, color={191,0,0}));
  connect(fixedTemperature7.port, evap_1_wall1.outerPhase[4])
    annotation (Line(points={{1286,-562},{1370,-562},{1370,-580},{1408,-580}}, color={191,0,0}));
  connect(fixedTemperature8.port, evap_1_wall1.outerPhase[5])
    annotation (Line(points={{1284,-528},{1284,-532},{1322,-532},{1322,-564},{1370,-564},{1370,-580},{1408,-580}}, color={191,0,0}));
  connect(fixedTemperature9.port,scalar2VectorHeatPort4. heatScalar) annotation (Line(points={{1586,-542},{1610,-542}},
                                                                                                                    color={191,0,0}));
  connect(fixedTemperature10.port, scalar2VectorHeatPort3.heatScalar) annotation (Line(points={{1314,-484},{1358,-484}}, color={191,0,0}));
  connect(fixedTemperature11.port,scalar2VectorHeatPort15. heatScalar) annotation (Line(points={{1772,-460},{1778,-462},{1840,-462}},
                                                                                                                            color={191,0,0}));
  connect(fixedTemperature12.port,scalar2VectorHeatPort16. heatScalar) annotation (Line(points={{1780,-328},{1780,-336},{1830,-336}},
                                                                                                                                color={191,0,0}));
  connect(fixedTemperature13.port,scalar2VectorHeatPort5. heatScalar) annotation (Line(points={{1578,-438},{1578,-440},{1614,-440}},
                                                                                                                            color={191,0,0}));
  connect(fixedTemperature14.port,scalar2VectorHeatPort6. heatScalar) annotation (Line(points={{1588,-354},{1586,-356},{1612,-356}},
                                                                                                                               color={191,0,0}));
  connect(fixedTemperature15.port, scalar2VectorHeatPort7.heatScalar)
    annotation (Line(points={{1574,-262},{1586,-262},{1586,-244},{1608,-244}}, color={191,0,0}));
  connect(fixedTemperature18.port, evap_4_wall1.outerPhase[3])
    annotation (Line(points={{1376,-256},{1402,-256},{1402,-292},{1394,-292},{1394,-318},{1410,-318}}, color={191,0,0}));
  connect(fixedTemperature17.port, evap_4_wall1.outerPhase[2])
    annotation (Line(points={{1376,-290},{1378,-290},{1378,-318},{1410,-318}}, color={191,0,0}));
  connect(fixedTemperature16.port, evap_4_wall1.outerPhase[1]) annotation (Line(points={{1376,-320},{1376,-318},{1410,-318}}, color={191,0,0}));
  connect(fixedTemperature21.port, evap_3_wall1.outerPhase[4])
    annotation (Line(points={{1368,-366},{1386,-366},{1386,-420},{1408,-420}}, color={191,0,0}));
  connect(fixedTemperature20.port, evap_3_wall1.outerPhase[3])
    annotation (Line(points={{1368,-400},{1368,-396},{1386,-396},{1386,-420},{1408,-420}}, color={191,0,0}));
  connect(fixedTemperature19.port, evap_3_wall1.outerPhase[2])
    annotation (Line(points={{1368,-430},{1394,-430},{1394,-420},{1408,-420}}, color={191,0,0}));
  connect(fixedTemperature22.port, evap_3_wall1.outerPhase[1])
    annotation (Line(points={{1364,-460},{1394,-460},{1394,-420},{1408,-420}}, color={191,0,0}));
  connect(fixedTemperature25.port, ct_1_wall1.outerPhase[1]) annotation (Line(points={{1486,-324},{1510,-324},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature24.port, ct_1_wall1.outerPhase[2])
    annotation (Line(points={{1486,-358},{1490,-358},{1490,-382},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature23.port, ct_1_wall1.outerPhase[3]) annotation (Line(points={{1486,-388},{1490,-382},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature28.port, ct_1_wall1.outerPhase[4]) annotation (Line(points={{1478,-434},{1510,-434},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature27.port, ct_1_wall1.outerPhase[5]) annotation (Line(points={{1478,-468},{1510,-468},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature26.port, ct_1_wall1.outerPhase[6]) annotation (Line(points={{1478,-498},{1510,-498},{1510,-382}}, color={191,0,0}));
  connect(fixedTemperature29.port, ct_1_wall1.outerPhase[7])
    annotation (Line(points={{1474,-528},{1488,-528},{1488,-526},{1510,-526},{1510,-382}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-580,-480},{1540,460}}),
                      graphics={
        Rectangle(
          extent={{1478,440},{1520,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{1438,440},{1478,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{1442,442},{1470,422}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{1436,402},{1476,382}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{1480,422},{1514,404}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties"),                     Text(
          extent={{-578,436},{-382,372}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="______________________________________________________________________________________________
PURPOSE:
Example of a steam cycle of a 580 MW hard coal power plant. It has a single reheat, one HP preheater and four LP preheaters.
This model uses the same steam cycle as in example SteamCycle_01 but a more complex boiler model which features gas and particle radiation.
Initial and nominal values are computed with help of the static cycle package. 
Levels of preheaters and condenser are controlled by simple PI-controllers, the heating power and feedwater pump power is set by a feed forward block.
Models provide information for automatic efficiency calculation within SimCenter-model.
______________________________________________________________________________________________
"),                   Text(
          extent={{-578,342},{-378,324}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="______________________________________________________________________________________________
Scenario:  
Two successive load reductions to 70 percent load at t=2500s and t=6100s with a length of 30 minutes each.
______________________________________________________________________________________________
")}),
    experiment(
      StopTime=600,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, initialScale=0.1)),
__Dymola_experimentFlags(
    Hidden(SmallerDAEIncidence=false)));
end SteamPowerPlant_01_OM_furnaceSteam;
