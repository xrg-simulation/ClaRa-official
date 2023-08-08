within ClaRa.Basics.Interfaces;
expandable connector EyeOut "Signal bus featuring pressure, specific enthalpy,temperature, specific entropy andmass flow rate"
  import SI = ClaRa.Basics.Units;
  output Real p "Pressure in bar";
  output Real h "Specific enthalpy in kJ/kg" annotation(HideResult=false);
  output Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
  output SI.Temperature_DegC T "Tempearture in degC" annotation(HideResult=false);
  output Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);

annotation ( Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}},
        initialScale=0.05),    graphics={
                 Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={190,190,190},
          fillColor={102,181,203},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,60},{60,0},{-80,-60},{-80,60}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Diagram(graphics={         Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={153,205,221},
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={153,205,221},
          textString="%name"),
        Polygon(
          points={{-92,88},{85,0},{-92,-88},{-92,88}},
          smooth=Smooth.None,
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid)}));
end EyeOut;
