within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model TestFuelSplit
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  SplitFuel_L1_flex splitFuel_L1_flex(N_ports_out=3, K_split={0.5,0.2}) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi(p_const=3e5) annotation (Placement(transformation(extent={{92,6},{72,26}})));
  BoundaryConditions.BoundaryFuel_Txim_flow                      boundaryFuel_Txim_flow(m_flow_const=10) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi1(p_const=2e5) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  inner SimCenter simCenter(redeclare Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel1)
                                                                            annotation (Placement(transformation(extent={{-90,-86},{-50,-66}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi2 annotation (Placement(transformation(extent={{72,-92},{52,-72}})));
equation
  connect(boundaryFuel_Txim_flow.fuel_a, splitFuel_L1_flex.inlet) annotation (Line(
      points={{-46,0},{-12,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[1], boundaryFuel_pTxi1.fuel_a) annotation (Line(
      points={{8,-0.666667},{18,-0.666667},{18,50},{40,50}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[2], boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{8,0},{20,0},{20,16},{72,16}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[3], boundaryFuel_pTxi2.fuel_a) annotation (Line(
      points={{8,0.666667},{14,0.666667},{14,-2},{18,-2},{18,-82},{52,-82}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestFuelSplit;
