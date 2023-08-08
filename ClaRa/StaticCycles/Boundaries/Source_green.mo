within ClaRa.StaticCycles.Boundaries;
model Source_green "Green source"
  // Green output:  Values of m_flow and h are known in component and provided FOR neighbor component.

  parameter ClaRa.Basics.Units.MassFlowRate  m_flow "Mass flow from the source";
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy of the source flow";
  parameter ClaRa.Basics.Units.Pressure p "Pressure at the source";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outlet(
    h=h,
    m_flow=m_flow,
    p=p) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p"),
        Line(points={{60,100},{100,0},{60,-100}}, color={115,150,0})}),
                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));

end Source_green;
