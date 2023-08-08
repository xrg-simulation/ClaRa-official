within ClaRa.Basics.Interfaces;
model DataInterfaceVectorGas
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

parameter Integer N_sets= 0 "Number of data sets to be provided (if showData=true)" annotation(Dialog(tab="Summary and Visualisation"));

//    input Real p_int[N_sets] annotation(HideResult=true);
//    input Real h_int[N_sets] annotation(HideResult=true);
//    input Real m_flow_int[N_sets] annotation(HideResult=true);
//    input Real T_int[N_sets] annotation(HideResult=true);
//    input Real s_int[N_sets] annotation(HideResult=true);
  ClaRa.Basics.Interfaces.EyeOutGas     eye[N_sets]
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

// equation
//   for i in 1: N_sets loop
//      dat[i].p=p_int[i];
//      dat[i].h=h_int[i];
//      dat[i].m_flow=m_flow_int[i];
//      dat[i].T=T_int[i];
//      dat[i].s=s_int[i];
//   end for;

  annotation (Diagram(graphics));
end DataInterfaceVectorGas;
