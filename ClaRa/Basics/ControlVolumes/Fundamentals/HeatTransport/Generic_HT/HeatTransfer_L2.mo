within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
partial model HeatTransfer_L2 " L2 || HT-BaseClass"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
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
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE;

  extends ClaRa.Basics.Icons.Alpha;
  //  SI.Temperature T_mean "Mean temperature of Fluid";
  outer parameter Boolean useHomotopy;


  ClaRa.Basics.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));



equation



end HeatTransfer_L2;
