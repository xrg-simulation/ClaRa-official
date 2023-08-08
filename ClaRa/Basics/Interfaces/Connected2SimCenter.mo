within ClaRa.Basics.Interfaces;
model Connected2SimCenter
  input Modelica.SIunits.Power powerIn=1e-3;
  input Modelica.SIunits.Power powerOut_elMech=0;
  input Modelica.SIunits.Power powerOut_th=0;
  input Modelica.SIunits.Power powerAux=0;
  outer SimCenter simCenter;

   ClaRa.Basics.Interfaces.CycleSumModel cycleSumModel;

equation
  cycleSumModel.cycleSumPort.power_in = powerIn;
  cycleSumModel.cycleSumPort.power_out_elMech = powerOut_elMech;
  cycleSumModel.cycleSumPort.power_out_th = powerOut_th;
  cycleSumModel.cycleSumPort.power_aux = powerAux;
  connect(simCenter.cycleSumPort, cycleSumModel.cycleSumPort);

end Connected2SimCenter;
