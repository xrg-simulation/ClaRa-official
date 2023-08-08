within ClaRa.Components.FlueGasCleaning.Desulfurization;
model Desulfurization_L2_ideal "Model for an idealised desulfurization with chalk washing"
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

  extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_chem(redeclare model ChemicalReactions=SeparationModel, redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder(diameter=4,length=10,z_in={0},z_out={10},orientation = ClaRa.Basics.Choices.GeometryOrientation.vertical,flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical));
  extends ClaRa.Basics.Icons.Separator;
parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
   ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=0,
    powerOut_elMech=0,
    powerAux=chemicalReactions.P_el) if  contributeToCycleSummary;

  replaceable model SeparationModel =
       ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Desulfurization_L2
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DesulfurizationBase "1st: choose e-filter reaction model | 2nd: edit corresponding record"
     annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter Basics.Units.Length diameter=1 "Diameter of the component";
  parameter Basics.Units.Length height=1 "Height of the component";

end Desulfurization_L2_ideal;
