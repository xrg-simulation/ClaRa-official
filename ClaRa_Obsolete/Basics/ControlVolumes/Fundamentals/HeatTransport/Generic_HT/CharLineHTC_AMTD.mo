within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model CharLineHTC_AMTD "Obsolete HT Model || All Geo || HTC || Characteristic Line || AMTD"
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
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
  outer ClaRa.Basics.Records.IComBase_L2 iCom;

  parameter Modelica.SIunits.CoefficientOfHeatTransfer kc_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));
  parameter Real PL_kc[:, 2]={{0,0.2},{0.5,0.6},{0.7,0.72},{1,1}} "Correction factor for heat transfer in part load" annotation (Dialog(group="Heat Transfer"));

  Modelica.SIunits.CoefficientOfHeatTransfer kc;
protected
  Modelica.Blocks.Tables.CombiTable1Ds kc_corr(table=PL_kc) annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
equation

  //heat.Q_flow = kc*iCom.A_heat* (2*ClaRa.Basics.Functions.Stepsmoother(1e-3, -1e-3, heat.T-T_mean)-1)*DT_mean;
  heat.Q_flow = kc*iCom.A_heat*ClaRa.Basics.Functions.Stepsmoother(
    100,
    -100,
    (DT_wi)*(DT_wo))*(DT_wi + DT_wo)/2;

  kc_corr.u = noEvent(max(1e-3, abs(iCom.m_flow_in))/iCom.m_flow_nom);
  kc = kc_corr.y[1]*kc_nom;

end CharLineHTC_AMTD;
