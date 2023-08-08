within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
partial model HeatTransfer_L4 "VLE || HT Base Class"
  extends ClaRa.Basics.Icons.Alpha;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4;
  outer ClaRa.Basics.Records.IComVLE_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  parameter ClaRa.Basics.Units.Area[iCom.N_cv] A_heat "Area of heat transfer" annotation (Dialog(enable=false));
  ClaRa.Basics.Units.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";
  ClaRa.Basics.Units.Temperature T_mean[iCom.N_cv];
  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  annotation (Icon(graphics));
end HeatTransfer_L4;
