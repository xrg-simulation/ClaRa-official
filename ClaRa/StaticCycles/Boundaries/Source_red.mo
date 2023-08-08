within ClaRa.StaticCycles.Boundaries;
model Source_red "Red boundary"
 // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.

  final parameter ClaRa.Basics.Units.MassFlowRate  m_flow(fixed= false) "Mass flow from the source";
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy of the source flow";
  final parameter ClaRa.Basics.Units.Pressure p(fixed= false) "Pressure at the boundary";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_b outlet(h=h) annotation (Placement(transformation(extent={{100,-10},{110,10}})));
initial equation

    m_flow= outlet.m_flow;
    p=outlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(m_flow)),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(p)),
        Line(points={{60,100},{100,0},{60,-100}}, color={150,25,48})}),
                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Source_red;
