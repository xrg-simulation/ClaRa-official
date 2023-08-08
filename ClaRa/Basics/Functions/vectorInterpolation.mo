within ClaRa.Basics.Functions;
function vectorInterpolation "Linear inter-/extrapolation of function values (x_i | f_i) between (x_1 | f_1) and (x_n | f_n)"
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
   extends ClaRa.Basics.Icons.Function;

   input Real[:] x_i "Grid points to calculate function values for";
   input Real x_1 "First grid point";
   input Real f_1 "Function value for first grid point";
   input Real x_n "Last grid point";
   input Real f_n "Function value for last grid point";

   output Real[size(x_i,1)] f_i "Returned function values";

protected
   Integer N_cv = size(x_i,1) "Number of grid points";
   Real dfdx = (f_n-f_1)/max(x_n-x_1,Modelica.Constants.eps) "Function slope";

   Real[N_cv] dx_i = x_i-ones(N_cv)*x_1 "Relative grid points";
   Real[N_cv,N_cv] identity_dfdx = identity(N_cv)*dfdx "Identity matrix of slope";

algorithm
   f_i := identity_dfdx*dx_i+ones(N_cv)*f_1;

end vectorInterpolation;
