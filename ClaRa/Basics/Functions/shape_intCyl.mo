within ClaRa.Basics.Functions;
function shape_intCyl "Horizontal area of a cylinder vertically intersecting a horizontal cylinder of large diameter discretised output"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
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
  extends ClaRa.Basics.Icons.Function;
  input Real H_fill "Total filling height";
  input Real D1 "Diameter of vertical cylinder";
  input Real D2 "Diameter of horizontal cylinder";
  input Real h1 "Length of vertical cylinder";
  input Real L "Length of horizontal cylinder";
  input Integer N12 "Number of values between h1 and h2";
  input Integer N2 "Number of values between  h2 and H_fill";
  output Real shape_intCyl[N12+N2+2,2] "Shape table";

protected
  Real h2;
  Real dz12;
  Real dz2;

algorithm
  assert(D2>=D1 and L>=D1,"Diameter and length of horizontal cylinder need to be larger than diameter of hotwell!");

  h2:=D2/2*(1-cos(asin(D1/D2)))+h1;

  dz12:=(h2 - h1)/N12;
  dz2:=(H_fill - h2)/N2;

  shape_intCyl[1,1]:=0;
  shape_intCyl[1,2]:=Modelica.Constants.pi/4*D1^2;
  shape_intCyl[2,1]:=h1/H_fill;
  shape_intCyl[2,2]:=Modelica.Constants.pi/4*D1^2;

  for i in 1:N12 loop
    shape_intCyl[2+i,1]:=(h1 + i*dz12)/H_fill;
    shape_intCyl[2+i,2]:=ClaRa.Basics.Functions.A_hor_intCyl(
      h1 + i*dz12,
      D1,
      D2,
      h1,
      L);
  end for;
  for i in 1:N2 loop
    shape_intCyl[2+N12+i,1]:=(h2 + i*dz2)/H_fill;
    shape_intCyl[2+N12+i,2]:=ClaRa.Basics.Functions.A_hor_intCyl(
      h2 + i*dz2,
      D1,
      D2,
      h1,
      L);
  end for;

  shape_intCyl[:,2]:=shape_intCyl[:, 2]/(Modelica.Constants.pi/4*D1^2);

end shape_intCyl;
