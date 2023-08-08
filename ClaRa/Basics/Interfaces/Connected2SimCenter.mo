within ClaRa.Basics.Interfaces;
model Connected2SimCenter
  input Modelica.SIunits.Power powerIn=1e-3;
  input Modelica.SIunits.Power powerOut=0;
  input Modelica.SIunits.Power powerAux=0;
  outer SimCenter simCenter;

   ClaRa.Basics.Interfaces.CycleSumModel cycleSumModel;

equation
  cycleSumModel.cycleSumPort.power_in = powerIn;
  cycleSumModel.cycleSumPort.power_out = powerOut;
    cycleSumModel.cycleSumPort.power_aux = powerAux;
  connect(simCenter.cycleSumPort, cycleSumModel.cycleSumPort);

end Connected2SimCenter;
