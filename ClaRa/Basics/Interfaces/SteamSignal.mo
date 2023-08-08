within ClaRa.Basics.Interfaces;
expandable connector SteamSignal "Signal bus featuring pressure, specific enthalpy and mass flow rate"


   Real p_ "Pressure in p.u." annotation(HideResult=false);
   Real h_ "Specific enthalpy in p.u." annotation(HideResult=false);
   Real m_flow_ "Mass flow rate in p.u." annotation(HideResult=false);

annotation (defaultComponentPrefixes="protected",
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={102,181,203},
          lineThickness=0.5),
          Polygon(
            fillColor={153,205,221},
            fillPattern=FillPattern.Solid,
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
            smooth=Smooth.Bezier,
          lineColor={102,181,203}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65.0,15.0},{-55.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5.0,15.0},{5.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55.0,15.0},{65.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25.0,-25.0},{35.0,-15.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35.0,-25.0},{-25.0,-15.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Diagram(graphics));
end SteamSignal;
