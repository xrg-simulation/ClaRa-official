within ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals;
model Linear
  extends Fundamentals.BaseDp(final hasPressureLoss=true);
  Basics.Units.Pressure dp;
  Basics.Units.MassFlowRate m_flow;
  parameter Basics.Units.MassFlowRate m_flow_nom=10;
  parameter Basics.Units.Pressure dp_nom=1000 "Nominal pressure loss";
equation
  m_flow=m_flow_nom*dp/dp_nom;
end Linear;
