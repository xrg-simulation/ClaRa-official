within ClaRa_Obsolete.Components.MechanicalSeparation.Check;
model TestFeedWaterTank_1Separator "test case to compare FeedWaterTank_1 and FeedWaterTank_3"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

 extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;


  inner ClaRa.SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1, showExpertSummary=true) annotation (Placement(transformation(extent={{-100,-240},{-60,-220}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1000,
    height=-5,
    startTime=20500,
    offset=-(262.441 + 43 + 14))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={118,-20})));
  Modelica.Blocks.Sources.TimeTable
                               ramp1(
    offset=0,
    startTime=0,
    table=[0,262.441; 10000,262.441; 11000,132.441; 12000,262.441; 15901,262.441])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={116,8})));

  Modelica.Blocks.Sources.Ramp ramp2(
    startTime=20000,
    offset=43,
    height=5,
    duration=1)
    annotation (Placement(transformation(extent={{-98,-4},{-78,16}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG4(m_flow_const=-10, variable_m_flow=true) annotation (Placement(transformation(extent={{62,-116},{42,-96}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG5(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=624.63e3) annotation (Placement(transformation(extent={{60,-100},{40,-80}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG7(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=814e3) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-58})));

  ClaRa_Obsolete.Components.MechanicalSeparation.FeedWaterTank_L3 tank_L3(
    diameter=4,
    m_flow_cond_nom=400,
    m_flow_heat_nom=23,
    h_nom=742e3,
    length=21,
    level_rel_start=2.5/4,
    z_in=4,
    z_out=0.1,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    showExpertSummary=true,
    Tau_cond=0.001,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    levelOutput=true,
    showLevel=true,
    p_nom=900000,
    p_start=900000,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3,
    initOption=204,
    Tau_evap=0.001) annotation (Placement(transformation(extent={{-34,-86},{26,-66}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG12(m_flow_const=-10, variable_m_flow=true) annotation (Placement(transformation(extent={{60,-38},{40,-18}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG13(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=624.63e3) annotation (Placement(transformation(extent={{62,-8},{42,12}})));
  ClaRa.Components.MechanicalSeparation.FeedWaterTank_L2 tank_L2(
    diameter=4,
    m_flow_cond_nom=400,
    m_flow_heat_nom=23,
    h_nom=742e3,
    length=21,
    level_rel_start=2.5/4,
    z_in=4,
    z_out=0.1,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    showLevel=true,
    levelOutput=true,
    initOption=205,
    p_nom=900000,
    p_start=900000) annotation (Placement(transformation(extent={{-36,-14},{24,6}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG14(
    variable_m_flow=false,
    h_const=3152.9e3,
    m_flow_const=14) annotation (Placement(transformation(extent={{60,22},{40,42}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG15(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=814e3) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,32})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG1(m_flow_const=-10, variable_m_flow=true) annotation (Placement(transformation(extent={{60,-242},{40,-222}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG2(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=624.63e3) annotation (Placement(transformation(extent={{60,-196},{40,-176}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG3(h_const=3152.9e3, p_const=12e5) annotation (Placement(transformation(extent={{62,-170},{42,-150}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG8(
    m_flow_const=400,
    variable_m_flow=true,
    h_const=814e3) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-132})));
  ClaRa.Components.MechanicalSeparation.FeedWaterTank_L3 tank_L3_adv(
    diameter=4,
    m_flow_cond_nom=400,
    m_flow_heat_nom=23,
    h_nom=742e3,
    length=21,
    level_rel_start=2.5/4,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    showExpertSummary=true,
    Tau_evap=0.001,
    z_condensate=4,
    z_aux=4,
    z_vent=0.1,
    Tau_cond=0.001,
    z_tapping=0.2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={2e5*423/14,1000*400/423,1000*23/423}),
    levelOutput=true,
    showLevel=true,
    p_nom=900000,
    p_start=900000,
    initOption=204,
    z_feedwater=0.1) annotation (Placement(transformation(extent={{-30,-202},{30,-182}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG9(h_const=3152.9e3, p_const=12e5) annotation (Placement(transformation(extent={{62,-68},{42,-48}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=2e5*423/14, m_flow_nom=423)) annotation (Placement(transformation(extent={{20,-56},{0,-44}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{-16,-26},{4,-16}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{-14,-100},{6,-90}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG6(
    h_const=814e3,
    variable_m_flow=false,
    m_flow_const=-0.5)
                   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-156})));
  ClaRa.Visualisation.Quadruple quadruple2 annotation (Placement(transformation(extent={{-10,-216},{22,-206}})));
  ClaRa.Visualisation.Quadruple quadruple3 annotation (Placement(transformation(extent={{-36,-180},{-4,-170}})));

equation
  connect(ramp2.y, massFlowSource_XRG7.m_flow) annotation (Line(
      points={{-77,6},{-70,6},{-70,-64},{-62,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG5.steam_a, tank_L3.condensate) annotation (Line(
      points={{40,-90},{40,-70},{16,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG4.steam_a, tank_L3.outlet) annotation (Line(
      points={{42,-106},{-30,-106},{-30,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tank_L2.feedwater, massFlowSource_XRG12.steam_a) annotation (Line(
      points={{-32,-14},{-32,-28},{40,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG15.m_flow) annotation (Line(
      points={{-77,6},{-70,6},{-70,26},{-62,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG15.steam_a, tank_L2.heatingSteam) annotation (Line(
      points={{-40,32},{-26,32},{-26,4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG14.steam_a, tank_L2.heatingSteam) annotation (Line(
      points={{40,32},{-26,32},{-26,4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG13.steam_a, tank_L2.condensate) annotation (Line(
      points={{42,2},{14,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG2.steam_a, tank_L3_adv.condensate) annotation (Line(
      points={{40,-186},{20,-186}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG1.steam_a, tank_L3_adv.feedwater) annotation (Line(
      points={{40,-232},{-26,-232},{-26,-202}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG8.m_flow) annotation (Line(
      points={{-77,6},{-70,6},{-70,-138},{-62,-138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG13.m_flow) annotation (Line(
      points={{105,8},{64,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG5.m_flow) annotation (Line(
      points={{105,8},{96,8},{96,-84},{62,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG2.m_flow) annotation (Line(
      points={{105,8},{96,8},{96,-180},{62,-180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_XRG4.m_flow) annotation (Line(
      points={{107,-20},{84,-20},{84,-100},{64,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_XRG12.m_flow) annotation (Line(
      points={{107,-20},{84,-20},{84,-22},{62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_XRG1.m_flow) annotation (Line(
      points={{107,-20},{84,-20},{84,-226},{62,-226}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG8.steam_a, tank_L3_adv.aux) annotation (Line(
      points={{-40,-132},{16,-132},{16,-186}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG3.steam_a, tank_L3_adv.heatingSteam) annotation (Line(
      points={{42,-160},{-20,-160},{-20,-184}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveVLE_L1_1.inlet, massFlowSource_XRG9.steam_a) annotation (Line(
      points={{20,-50},{32,-50},{32,-58},{42,-58}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_1.outlet, tank_L3.heatingSteam) annotation (Line(
      points={{0,-50},{0,-56},{-24,-56},{-24,-68}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(massFlowSource_XRG7.steam_a, tank_L3.heatingSteam) annotation (Line(
      points={{-40,-58},{-24,-58},{-24,-68}},
      color={0,131,169},
      thickness=0.5));
  connect(tank_L2.eye, quadruple.eye) annotation (Line(points={{-28,-15},{-28,-21},{-16,-21}}, color={190,190,190}));
  connect(tank_L3.eye, quadruple1.eye) annotation (Line(points={{-26,-87},{-24,-87},{-24,-95},{-14,-95}}, color={190,190,190}));
  connect(tank_L3_adv.vent, massFlowSource_XRG6.steam_a) annotation (Line(
      points={{0,-182.2},{0,-182.2},{0,-174},{0,-156},{-40,-156}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple2.eye, tank_L3_adv.eye) annotation (Line(points={{-10,-211},{-16,-211},{-22,-211},{-22,-203}}, color={190,190,190}));
  connect(quadruple3.eye, tank_L3_adv.eye_sat) annotation (Line(points={{-36,-175},{-36,-175},{-4,-175},{-4,-181}}, color={190,190,190}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-240},{100,140}}),
                         graphics={Text(
          extent={{-98,108},{102,56}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="_____________________________________________________
PURPOSE:
compare the filling behaviour of different tank models currently available.
_____________________________________________________
HAVE A LOOK AT:
Compare the different filling levels and pressures that can be found in the
summaries.
_____________________________________________________
NOTE:
The extra valve wired to tank_L3 is neccessary to introduce different 
pressure losses to the tapping inlet and the aux inlet.
_____________________________________________________
SUMMARY: The tank_L3_adv is the most comprehensive tank model 
thery a bit more difficult to initialize than tank_L1 but also more realistic than tank_L3")}),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)),
    experiment(StopTime=30000),
    __Dymola_experimentSetupOutput);
end TestFeedWaterTank_1Separator;
