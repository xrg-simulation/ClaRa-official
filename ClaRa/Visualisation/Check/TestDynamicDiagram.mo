within ClaRa.Visualisation.Check;
model TestDynamicDiagram
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  Modelica.Blocks.Sources.Sine sine(          amplitude=1, freqHz=0.1,
    offset=10)
    annotation (Placement(transformation(extent={{-82,-12},{-62,8}})));
  Scope scope(
    inputVar=sine.y,
    Unit="Sine",
    t_sample=2,
    t_end=100,
    t_start=50,
    hideInterface=false,
    y_min=9,
    y_max=11,
    Tau_stab=1)  annotation (Placement(transformation(extent={{-36,-66},{56,20}})));
equation
  connect(sine.y, scope.u) annotation (Line(
      points={{-61,-2},{-50,-2},{-50,-3.81538},{-39.9429,-3.81538}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics), experiment(StopTime=200));
end TestDynamicDiagram;
