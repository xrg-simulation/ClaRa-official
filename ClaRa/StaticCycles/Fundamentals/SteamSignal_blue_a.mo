within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_blue_a "Signal-based steam connector"

  //extends ClaRa.StaticCycles.Fundamentals.SteamSignal_base;
  output ClaRa.Basics.Units.Pressure p;
  input ClaRa.Basics.Units.EnthalpyMassSpecific h;
  input ClaRa.Basics.Units.MassFlowRate m_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={0,131,169},
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_blue_a;
