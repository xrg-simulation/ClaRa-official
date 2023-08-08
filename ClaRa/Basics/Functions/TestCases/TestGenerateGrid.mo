within ClaRa.Basics.Functions.TestCases;
model TestGenerateGrid "simple test for the GenerateGrid function"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  parameter Integer N=3;
  parameter Real L=8;
  Real dx[N];
  //Real Test;
//   Real Test2;
//   Real index3;
//   Real Test3;
//   Integer nextIndex;
equation

  dx = ClaRa.Basics.Functions.GenerateGrid(
    {2},
    L,
    N);
  annotation (experiment(StopTime=1));
end TestGenerateGrid;
