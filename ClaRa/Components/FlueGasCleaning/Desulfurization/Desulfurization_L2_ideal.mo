within ClaRa.Components.FlueGasCleaning.Desulfurization;
model Desulfurization_L2_ideal "Model for an idealised desulfurization with chalk washing"
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

  extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_chem(redeclare model ChemicalReactions=SeparationModel, redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder(diameter=4,length=10,z_in={0},z_out={10},orientation = ClaRa.Basics.Choices.GeometryOrientation.vertical,flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical));
  extends ClaRa.Basics.Icons.Separator;

  replaceable model SeparationModel =
       ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Desulfurization_L2
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DesulfurizationBase "1st: choose e-filter reaction model | 2nd: edit corresponding record"
     annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter SI.Length diameter=1 "Diameter of the component";
  parameter SI.Length height=1 "Height of the component";

end Desulfurization_L2_ideal;
