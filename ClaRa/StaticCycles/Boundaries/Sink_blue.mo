within ClaRa.StaticCycles.Boundaries;
model Sink_blue "Blue sink"
  // Blue input:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.MassFlowRate  m_flow(fixed = false) "Mass flowing into the sink";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed = false) "Spec.enthalpy flowing into the sink";
  parameter ClaRa.Basics.Units.Pressure p(fixed = true) "Pressure at the boundary";
  outer ClaRa.SimCenter simCenter;
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}})));
initial equation
    m_flow= inlet.m_flow;
    h=inlet.h;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(m_flow)),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(h)),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p"),
        Line(points={{-100,100},{-60,0},{-100,-100}}, color={0,131,169})}),
                                            Diagram(graphics,
                                                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Sink_blue;
