within ClaRa.StaticCycles.Boundaries;
model Source_blue "Blue boundary"
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.

  parameter ClaRa.Basics.Units.MassFlowRate  m_flow "Mass flow from the source";
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy of the source flow";
  final parameter ClaRa.Basics.Units.Pressure p(fixed = false) "Pressure at the source";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet(h=h, m_flow=m_flow) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
initial equation
    p=outlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(p)),
        Line(points={{60,100},{100,0},{60,-100}}, color={0,131,169})}),
                                            Diagram(graphics,
                                                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Source_blue;
