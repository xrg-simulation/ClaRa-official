within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
partial model HeatTransfer_L4 "Medium independent || HT Base Class"
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

  extends ClaRa.Basics.Icons.Alpha;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4;
  outer ClaRa.Basics.Records.IComBase_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;

  outer parameter Boolean useHomotopy;

  parameter Modelica.SIunits.Area[iCom.N_cv] A_heat=ones(iCom.N_cv) "Area of heat transfer" annotation (Dialog(enable=false, tab = "Internals"));
  Modelica.SIunits.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";
  Modelica.SIunits.Temperature T_mean[iCom.N_cv];
  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  annotation (Icon(graphics));
end HeatTransfer_L4;
