within ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals;
model NoFriction
  extends Fundamentals.BaseDp(final hasPressureLoss=false);
  SI.Pressure dp;
  SI.MassFlowRate m_flow;
equation
  dp=0;
end NoFriction;
