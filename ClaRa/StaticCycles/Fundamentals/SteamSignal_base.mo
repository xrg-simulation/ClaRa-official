within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_base "Signal-based steam connector || basic||"

  TILMedia.VLEFluidTypes.BaseVLEFluid  Medium "Medium model";
  ClaRa.Basics.Units.Pressure p;
  ClaRa.Basics.Units.EnthalpyMassSpecific h;
  ClaRa.Basics.Units.MassFlowRate m_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={0,131,169},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_base;
