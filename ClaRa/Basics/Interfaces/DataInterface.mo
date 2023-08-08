within ClaRa.Basics.Interfaces;
model DataInterface
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

  input Real p_int annotation(HideResult=true);
  input Real h_int annotation(HideResult=true);
  input Real m_flow_int annotation(HideResult=true);
  input Real T_int annotation(HideResult=true);
  input Real s_int annotation(HideResult=true);
  ClaRa.Basics.Interfaces.EyeOut dat
    annotation (Placement(transformation(extent={{58,-74},{78,-54}}),
        iconTransformation(extent={{92,-70},{112,-50}})));

equation
    dat.p=p_int;
    dat.h=h_int;
    dat.m_flow=m_flow_int;
    dat.T=T_int;
    dat.s=s_int;

  annotation (Diagram(graphics), Icon(graphics));
end DataInterface;
