within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model ConstantHTC_AMTD "Obsolete HT Model || All Geo || HTC || Constant || AMTD"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
  extends Icons.Obsolete_v1_1;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.HeatTransfer
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
  outer ClaRa.Basics.Records.IComBase_L2 iCom;

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer kc_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));

  Modelica.Units.SI.CoefficientOfHeatTransfer kc;
equation

  heat.Q_flow = kc*iCom.A_heat*ClaRa.Basics.Functions.Stepsmoother(
    100,
    -100,
    (DT_wi)*(DT_wo))*(DT_wi + DT_wo)/2;
  kc = kc_nom;

end ConstantHTC_AMTD;
