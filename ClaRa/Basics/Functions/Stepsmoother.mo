within ClaRa.Basics.Functions;
function Stepsmoother "Continouus interpolation for x "
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
  extends ClaRa.Basics.Icons.Function;
  input Real func "input for that result = 1";
  input Real nofunc "input for that result = 0";
  input Real x "input for interpolation";
  output Real result;

protected
  Real m = Modelica.Constants.pi/(func - nofunc);
  Real b = -Modelica.Constants.pi/2 - m*nofunc;
  Real r_1 = tan(m*x + b);

algorithm
  result := if x >= 0.999*(func - nofunc) + nofunc and func>nofunc or x
<= 0.999*(func - nofunc) + nofunc and nofunc>func then  1 else if x <=
0.001*(func - nofunc) + nofunc and func>nofunc or x >= 0.001*(func -
nofunc) + nofunc and nofunc>func then 0 else ((0.5*(exp(
    r_1) - exp(-r_1))/(0.5*(exp(r_1) + exp(-r_1))) + 1)/2);
  annotation (derivative=Stepsmoother_der,
    Window(
      x=0.01,
      y=0.09,
      width=0.66,
      height=0.6));
end Stepsmoother;
