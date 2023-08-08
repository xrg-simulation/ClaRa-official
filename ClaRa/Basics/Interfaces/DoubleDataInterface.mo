within ClaRa.Basics.Interfaces;
model DoubleDataInterface "Two data connectors named dat1 and dat2"
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

  input Real p_int_1;
  input Real p_int_2         annotation(HideResult=true);
  input Real h_int_1;
  input Real h_int_2         annotation(HideResult=true);
  input Real m_flow_int_1;
  input Real m_flow_int_2              annotation(HideResult=true);
  input Real T_int_1;
  input Real T_int_2          annotation(HideResult=true);
  input Real s_int_1;
  input Real s_int_2          annotation(HideResult=true);
  ClaRa.Basics.Interfaces.EyeOut dat1
    annotation (Placement(transformation(extent={{-70,96},{-50,116}})));

  ClaRa.Basics.Interfaces.EyeOut dat2
    annotation (Placement(transformation(extent={{70,96},{90,116}})));
equation
    dat1.p=p_int_1;
    dat1.h=h_int_1;
    dat1.m_flow=m_flow_int_1;
    dat1.T=T_int_1;
    dat1.s=s_int_1;
    dat2.p=p_int_2;
    dat2.h=h_int_2;
    dat2.m_flow=m_flow_int_2;
    dat2.T=T_int_2;
    dat2.s=s_int_2;

  annotation (Diagram(graphics));
end DoubleDataInterface;
