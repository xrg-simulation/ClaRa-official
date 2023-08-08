within ClaRa.Components.MechanicalSeparation.Check;
model TestBottle
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  SteamSeparatorVLE_L1 cyclone(showData=false) annotation (Placement(transformation(extent={{-30,2},{-10,22}})));
  Bottle_L3 bottle_L3_1(               initOption=204,
    z_ins={28,15,15,1},
    z_outs={29.9,16,16,0.1},
    p_start=102e5,
    equalPressures=false,
    absorbInflow=0.9,
    includeInsulation=true,
    redeclare model insulationMaterial = TILMedia.SolidTypes.InsulationOrstechLSP_H_const,
    enableAmbientLosses=true,
    alpha_prescribed=20,
    Tau_evap=0.01)                                     annotation (Placement(transformation(extent={{0,-20},{20,40}})));
  BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(m_flow_const=100,
    h_const=2500e3,
    variable_m_flow=true,
    variable_h=true)                                                                               annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
  BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=100e5) annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(p_const=100e5) annotation (Placement(transformation(extent={{80,40},{60,60}})));
  inner SimCenter simCenter(showExpertSummary=true)
                            annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534 (
        paraOption=2,
        m_flow_nominal=50,
        Kvs=1,
        rho_in_nom=100))                                                                                                                                                                 annotation (Placement(transformation(extent={{30,44},{50,56}})));
  VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (paraOption=2, m_flow_nominal=8.45))
                                                                                                                                                                                          annotation (Placement(transformation(extent={{30,-46},{50,-34}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0.0,100; 999,100; 1000,120; 2500,120; 2501,50; 3000,50]) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0.0,2500e3; 1999,2500e3; 2000,2300e3; 3000,2300e3]) annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(cyclone.outlet2, bottle_L3_1.inlet_1) annotation (Line(
      points={{-20,22},{-20,22},{0,22}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(cyclone.outlet1, bottle_L3_1.inlet_4) annotation (Line(
      points={{-20,2},{-20,-2},{0,-2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.steam_a, cyclone.inlet) annotation (Line(
      points={{-44,12},{-30,12}},
      color={0,131,169},
      thickness=0.5));
  connect(bottle_L3_1.outlet_1, valveVLE_L1_1.inlet) annotation (Line(
      points={{10,40},{10,50},{30,50}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_1.outlet, boundaryVLE_phxi1.steam_a) annotation (Line(
      points={{50,50},{60,50}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(bottle_L3_1.outlet_4, valveVLE_L1_2.inlet) annotation (Line(
      points={{10,-20},{10,-40},{30,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{50,-40},{60,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(timeTable.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-79,30},{-74,30},{-74,18},{-66,18}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_hxim_flow.h) annotation (Line(points={{-79,-10},{-72,-10},{-72,12},{-66,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-100,100},{100,60}},
          lineColor={115,150,0},
          textString="PURPOSE:
Evaluate bottle behaviour under a numer of boundary steps (ilet enthalpy and mass flow)

SCENARIO:
Wet steam is separated into (nearly) dry steam and boiling liquid. The steam isentered into the upper part of the bottle while the liquid is entered at the bottom of the bottle.

RESULTS:
Note that the filling level is not controlled, it is sliding freely according to the valve sizing, the entering mass flows and the inlet condition (steam fraction of wet steam)",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(
      StopTime=3000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Sdirk34hw"));
end TestBottle;
