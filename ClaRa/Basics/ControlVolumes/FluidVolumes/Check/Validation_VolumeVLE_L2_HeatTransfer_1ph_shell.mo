within ClaRa.Basics.ControlVolumes.FluidVolumes.Check;
model Validation_VolumeVLE_L2_HeatTransfer_1ph_shell "Evaluation and validation scenario from VDI Wrmeatlas 9. Auflage 2002 Chapter Gg3"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.3.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  Modelica.Blocks.Sources.Constant FluidMassFlowRate(k=100)
    annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Modelica.Blocks.Sources.Constant FluidTemperature(k=20 + 273.15)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.Constant FluidPressure(k=
        TILMedia.VLEFluidFunctions.dewPressure_Txi(
        TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), 373.15))
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 Volume(
    p_nom(displayUnit="Pa") = 1e5,
    p_start(displayUnit="Pa") = 1e5,
    h_nom=2740e3,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    h_start=400e3,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltShell1ph_L2,
    m_flow_nom=100,
    redeclare model Geometry = Fundamentals.Geometry.HollowBlockWithTubes (
        length=2,
        diameter_t=20/1000,
        parallelTubes=false,
        staggeredAlignment=false,
        height=30/1000*10,
        Delta_z_par=26/1000,
        Delta_z_ort=30/1000,
        N_rows=6,
        z_in={30/1000*10/2},
        z_out={30/1000*10/2},
        width=2,
        N_tubes=10,
        N_passes=6),
    initOption=1,
    redeclare model PressureLoss = Fundamentals.PressureLoss.Generic_PL.NoFriction_L2)
                  "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))" annotation (Placement(transformation(extent={{20,40},{0,60}})));

  Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource(
    variable_m_flow=true,
    variable_T=true,
    p_nom=100000) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Components.BoundaryConditions.BoundaryVLE_phxi pressureSink(
    variable_p=true,
    h_const=2700e3,
    p_const=100000) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1
    valveLinear_1_XRG1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((100) > 0) then (100) else 10, Delta_p_nom=if ((0.1)
             <> 0) then (0.1) else 1000))                  annotation (
      Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={-30,50})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    useHomotopy=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid2) annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Constant WallTemp(k=100 + 273.15)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation

  connect(Volume.inlet, massFlowSource.steam_a) annotation (Line(
      points={{20,50},{20,50},{40,50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(valveLinear_1_XRG1.inlet, Volume.outlet) annotation (Line(
      points={{-20,50},{0,50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink.steam_a, valveLinear_1_XRG1.outlet) annotation (Line(
      points={{-60,50},{-40,50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(FluidPressure.y, pressureSink.p) annotation (Line(
      points={{-99,50},{-88,50},{-88,56},{-80,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluidMassFlowRate.y, massFlowSource.m_flow) annotation (Line(
      points={{79,70},{72,70},{72,56},{62,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluidTemperature.y, massFlowSource.T) annotation (Line(
      points={{79,30},{74,30},{74,50},{62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, Volume.heat) annotation (Line(
      points={{-20,90},{10,90},{10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(WallTemp.y, prescribedTemperature.T) annotation (Line(
      points={{-59,90},{-42,90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-140,0},{120,160}}, preserveAspectRatio=
            true), graphics={Text(
          extent={{-140,140},{120,120}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="Compared with VDI Waermeatlas, Gg3
NOTE:
Model is using outlet temperature for determination of fluid media properties. 
When the media properties from literature are applied to the relevant fluidDissipation function the outlet temperature agrees very well.
Literature values: kc= 7013.3 W/(mK) ; T_out= 29.5 C ")}),
    experiment(
      StopTime=3000,
      NumberOfIntervals=5000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Validation_VolumeVLE_L2_HeatTransfer_1ph_shell;
