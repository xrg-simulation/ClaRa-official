within ClaRa.Basics.Interfaces;
connector EyeOutGas
  import SI = ClaRa.Basics.Units;
   parameter TILMedia.GasTypes.BaseGas medium annotation(HideResult=false);
   output Real p "Pressure in bar" annotation(HideResult=false);
   output Real h "Specific enthalpy in kJ/kg" annotation(HideResult=false);
   output Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
   output Real T "Temperature in degC" annotation(HideResult=false);
   output Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);
  output Real xi[medium.nc-1] "Mass concentrations" annotation(HideResult=false);

  annotation (defaultComponentName="eyeIn",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2), graphics={
                 Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={190,190,190},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,60},{60,0},{-80,-60},{-80,60}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{-100,99},{100,0},{-100,-100},{-100,99}},
          lineColor={118,106,98},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={118,106,98},
          textString="%name"),
        Polygon(
          points={{-80,60},{60,0},{-80,-60},{-80,60}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));

end EyeOutGas;
