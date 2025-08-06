within ClaRa_Obsolete.StaticCycles;
model Boundary_red "Red boundary"

  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component" annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(group="Fundamental Definitions"));
  parameter Boolean source = true "True if boundary is source else sink";
  parameter ClaRa.Basics.Units.MassFlowRate  m_flow(fixed= not source) annotation(Dialog(enable = not source));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed=source) annotation(Dialog(enable = source));
  parameter ClaRa.Basics.Units.Pressure p(fixed= not source) annotation(Dialog(enable = not source));

  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_a inlet(m_flow=m_flow, p=p, Medium=medium)  annotation (Placement(transformation(extent={{-104,-10},{-96,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_b outlet(h=h, Medium=medium)  annotation (Placement(transformation(extent={{96,-10},{104,10}})));
initial equation
  if source then
    m_flow= outlet.m_flow;
    p=outlet.p;
  else

    h=inlet.h;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-60,0},{-96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= not source),
          Line(
          points={{60,0},{96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= source),
        Polygon(
          points={{-60,60},{60,60},{60,-60},{-60,-60},{-60,60}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,60},{60,20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p",
          visible=not source),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow",
          visible=not source),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={150,25,48},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h",
          visible=source),                Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.3.0")}),
                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Boundary_red;
