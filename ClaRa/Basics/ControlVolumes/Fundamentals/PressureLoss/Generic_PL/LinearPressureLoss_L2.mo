within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model LinearPressureLoss_L2 "All geo || Linear pressure loss || Nominal pressure difference"
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
  outer ClaRa.Basics.Records.IComBase_L2 iCom;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2;

  parameter SI.Pressure Delta_p_nom=1000 "Nominal pressure loss";

equation
  Delta_p = Delta_p_nom/iCom.m_flow_nom*iCom.m_flow_in;

end LinearPressureLoss_L2;
