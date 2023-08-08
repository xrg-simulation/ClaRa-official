within ClaRa.Components.FlueGasCleaning.E_Filter;
model E_Filter_L2 "Model for an e-filter with different separation models"
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

 extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_chem(redeclare model ChemicalReactions=SeparationModel, redeclare model Geometry=ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(height=height, length=length, width=width));
 extends ClaRa.Basics.Icons.E_Filter;
parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
   ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=0,
    powerOut_elMech=0,
    powerAux=chemicalReactions.powerConsumption) if  contributeToCycleSummary;

  replaceable model SeparationModel =
       ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Simple
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_FilterBase "1st: choose e-filter reaction model | 2nd: edit corresponding record"
     annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter Basics.Units.Length height=1 "Height of the component";
  parameter Basics.Units.Length width=1 "Width of the component";
  parameter Basics.Units.Length length=1 "Length of the component";

end E_Filter_L2;
