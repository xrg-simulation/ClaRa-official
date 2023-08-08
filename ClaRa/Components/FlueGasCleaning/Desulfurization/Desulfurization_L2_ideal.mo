within ClaRa.Components.FlueGasCleaning.Desulfurization;
model Desulfurization_L2_ideal "Model for an idealised desulfurization with chalk washing"
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

  Basics.Interfaces.EyeOutGas
                           eyeOut(each medium=medium) annotation (Placement(transformation(extent={{100,-78},{106,-72}}),
                                  iconTransformation(extent={{94,-86},{106,-74}})));
protected
  Basics.Interfaces.EyeInGas
                          eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{76,-76},{74,-74}}),
                                  iconTransformation(extent={{90,-84},{84,-78}})));
equation
  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = flueGasOutlet.T-273.15;
  eye_int[1].s = flueGasOutlet.T/1e3;
  eye_int[1].p = flueGasOutlet.p/1e5;
  eye_int[1].h = flueGasOutlet.h/1e3;
  eye_int[1].xi= flueGasOutlet.xi;

  connect(eye_int[1],eyeOut)  annotation (Line(
      points={{75,-75},{103,-75}},
      color={190,190,190},
      smooth=Smooth.None));
end Desulfurization_L2_ideal;
