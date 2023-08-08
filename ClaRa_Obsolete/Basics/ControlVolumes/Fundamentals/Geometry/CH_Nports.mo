within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.Geometry;
model CH_Nports "Cylindric shape || Shell with tubes || Vertical flow || Perpendicular tubes"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinderWithTubes(
    orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
    final parallelTubes=true,
    final N_baffle=0);
    extends Icons.Obsolete_v1_1;
end CH_Nports;
