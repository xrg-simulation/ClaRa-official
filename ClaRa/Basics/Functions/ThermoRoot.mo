within ClaRa.Basics.Functions;
function ThermoRoot "Numerical square root function"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.0                            //
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
  input Real x "Input for square root calculation";
  input Real deltax "Interpolation region";
  output Real y;
protected
  Real C3;
  Real C1;
  Real deltax2;
  Real adeltax;
  Real sqrtdeltax;

algorithm
  adeltax := abs(deltax);
  if (x > adeltax) then
    y := sqrt(x);
  elseif (x < -adeltax) then
    y := -sqrt(-x);
  elseif (abs(x) <= 0.0) then
    y := 0.0;
    // Important case.
  else
    deltax2 := adeltax*adeltax;
    sqrtdeltax := sqrt(adeltax);
    C3 := -0.25/(sqrtdeltax*deltax2);
    C1 := 0.5/sqrtdeltax - 3.0*C3*deltax2;
    y := (C1 + C3*x*x)*x;
  end if;
  annotation (derivative=ThermoRoot_der);
end ThermoRoot;
