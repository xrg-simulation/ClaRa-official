within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp;
model ConstantheatCapacity "Use a fixed value"
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

  extends GeneralMean;
  parameter Units.HeatCapacityMassSpecific cp_i_const[3]=fill(4190, 3);
  parameter Units.HeatCapacityMassSpecific cp_o_const[3]=fill(2000, 3);

equation
  cp_i = cp_i_const;
  cp_o = cp_o_const;
end ConstantheatCapacity;
