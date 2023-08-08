within ClaRa.Components.FlueGasCleaning.Denitrification;
model Denitrification_L2 "Model for a simple ammonia denitrification with fixed separation ratio"
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

   extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_chem(redeclare model ChemicalReactions=SeparationModel, redeclare model Geometry=ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(height=height, length=length, width=width));
 extends ClaRa.Basics.Icons.Separator;

  replaceable model SeparationModel =
       ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Denitrification_L2
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DenitrificationBase "1st: choose e-filter reaction model | 2nd: edit corresponding record"
     annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter SI.Length height=1 "Height of the component";
  parameter SI.Length width=1 "Width of the component";
  parameter SI.Length length=1 "Length of the component";
end Denitrification_L2;
