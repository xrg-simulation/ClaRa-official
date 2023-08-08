within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
partial model GenericPressureLoss

  extends ClaRa.Basics.Icons.Delta_p;
  import SI = ClaRa.Basics.Units;



  outer Boolean checkValve;
  outer Boolean useHomotopy;

  Basics.Units.MassFlowRate m_flow;


  Real flowIsChoked "1 if flow is choked, 0 if not";
  Real PR_choked "Pressure ratio at which choking occurs";
equation


  annotation (Icon(graphics));
end GenericPressureLoss;
