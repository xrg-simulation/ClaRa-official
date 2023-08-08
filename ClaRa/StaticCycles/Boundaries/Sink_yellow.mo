within ClaRa.StaticCycles.Boundaries;
model Sink_yellow "Yellow boundary"
  // Yellow input: Values of m_flow is known in component and provided FOR neighbor component, value of p and h are unknown and provided BY beighbor component.
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.MassFlowRate  m_flow "Mass flowing into the sink";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed = false) "Spec.enthalpy flowing into the sink";
  final parameter ClaRa.Basics.Units.Pressure p(fixed =  false) "Pressure at the boundary";
  outer ClaRa.SimCenter simCenter;

  ClaRa.StaticCycles.Fundamentals.SteamSignal_yellow_a inlet(m_flow=m_flow, Medium=vleMedium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
initial equation
    h=inlet.h;
    p=inlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(h)),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(p)),
        Line(points={{-100,100},{-60,0},{-100,-100}}, color={235,183,0})}),
                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Sink_yellow;
