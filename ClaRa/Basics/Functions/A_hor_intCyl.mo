within ClaRa.Basics.Functions;
function A_hor_intCyl "Horizontal area of a cylinder vertically intersecting a horizontal cylinder of large diameter"
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
  input Real z "Vertical position";
  input Real D1 "Diameter of vertical cylinder";
  input Real D2 "Diameter of horizontal cylinder";
  input Real h1 "Length of vertical cylinder";
  input Real L "Length of horizontal cylinder";
  output Real A_intersectingCylinder "Intersecting area";

protected
  Real beta;
  Real x;
  Real h2;
  Real r1;
  Real r2;

algorithm
  r1:=D1/2;
  r2:=D2/2;

  x:=2*r2*sin(acos((r2-z+h1)/r2));
  beta:=2*acos(min(x/r1/2,1-Modelica.Constants.eps));

  h2:=r2*(1-cos(asin(r1/r2)))+h1;

  if z>=0 and z<= h1 then
    A_intersectingCylinder:=Modelica.Constants.pi *r1^2;
  elseif z>h1 and z<h2 then
    A_intersectingCylinder:=x*L+r1^2*(beta-sin(beta));
  else
    A_intersectingCylinder:= x*L;
  end if;

end A_hor_intCyl;
