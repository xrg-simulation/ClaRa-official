within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_green_b "Signal-based steam connector"

  TILMedia.VLEFluidTypes.BaseVLEFluid  Medium "Medium model";
  output ClaRa.Basics.Units.Pressure p;
  output ClaRa.Basics.Units.EnthalpyMassSpecific h;
  output ClaRa.Basics.Units.MassFlowRate m_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Polygon(
          points={{-40,100},{40,100},{40,-100},{-40,-100},{-40,100}},
          lineColor={0,131,169},
          fillColor={143,170,56},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_green_b;
