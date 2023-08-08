within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_green_a "Signal-based steam connector"

  //extends ClaRa.StaticCycles.Fundamentals.SteamSignal_base;
  input ClaRa.Basics.Units.Pressure p;
  input ClaRa.Basics.Units.EnthalpyMassSpecific h;
  input ClaRa.Basics.Units.MassFlowRate m_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Polygon(
          points={{-40,100},{40,100},{40,-100},{-40,-100},{-40,100}},
          lineColor={0,131,169},
          fillColor={143,170,56},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_green_a;
