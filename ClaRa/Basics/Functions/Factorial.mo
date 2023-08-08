within ClaRa.Basics.Functions;
function Factorial "Calculate the factorial"
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
  extends ClaRa.Basics.Icons.Function;
input Integer Num "Integer Input";
output Integer factorial_Num "Factorial of Num" annotation (Dialog(group="Output"));
protected
  Integer Rv;

algorithm
  if Num <=1 then
    factorial_Num:=1;
  else
    factorial_Num:=1;
    for Rv in 1:Num loop
      factorial_Num:=factorial_Num*Rv;
    end for;
  end if;

end Factorial;
