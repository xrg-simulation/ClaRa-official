within ClaRa.StaticCycles.Boundaries;
model Sink_green "Green boundary"
  // Green input:  Values of m_flow and h are unknown in component and provided BY neighbor component.

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flowing into the sink";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed=false) "Spec.enthalpy flowing into the sink";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Pressure at the boundary";
  outer ClaRa.SimCenter simCenter;

  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_a inlet(Medium=vleMedium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
initial equation
    m_flow= inlet.m_flow;
    h=inlet.h;
    p=inlet.p;

  annotation (Icon(graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(m_flow)),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(h)),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={115,150,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(p)),
        Line(points={{-100,100},{-60,0},{-100,-100}}, color={115,150,0})}));
end Sink_green;
