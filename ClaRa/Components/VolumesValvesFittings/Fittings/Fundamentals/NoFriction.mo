within ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals;
model NoFriction
  extends Fundamentals.BaseDp(final hasPressureLoss=false);
  Basics.Units.Pressure dp;
  Basics.Units.MassFlowRate m_flow;
equation
  dp=0;
end NoFriction;
