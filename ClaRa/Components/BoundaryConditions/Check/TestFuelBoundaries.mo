within ClaRa.Components.BoundaryConditions.Check;
model TestFuelBoundaries
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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

  BoundaryFuel_Txim_flow                                         boundaryFuel_Txim_flow(variable_m_flow=true)                                                  annotation (Placement(transformation(extent={{-64,14},{-44,34}})));
  BoundaryFuel_pTxi                                         boundaryFuel_pTxi(T_const=263)                                                           annotation (Placement(transformation(extent={{52,14},{32,34}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Sensors.SensorFuel_L1_xi sensorFuel_L1_xi   annotation (Placement(transformation(extent={{-20,24},{0,44}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    duration=0.2,
    offset=10,
    startTime=0.4) annotation (Placement(transformation(extent={{-96,22},{-76,42}})));
equation
  connect(ramp.y, boundaryFuel_Txim_flow.m_flow) annotation (Line(points={{-75,32},{-70,32},{-70,30},{-64,30}}, color={0,0,127}));
  connect(boundaryFuel_Txim_flow.fuel_a, sensorFuel_L1_xi.port) annotation (Line(
      points={{-44,24},{-28,24},{-28,23.8},{-10,23.8}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorFuel_L1_xi.port, boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{-10,23.8},{12,23.8},{12,24},{32,24}},
      color={27,36,42},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestFuelBoundaries;
