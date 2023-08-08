within ClaRa.Basics.Interfaces;
connector EyeInGas
"Signal bus featuring pressure, specific enthalpy, temperature, specific entropy and mass flow rate"
  import SI = ClaRa.Basics.Units;
   parameter TILMedia.GasTypes.BaseGas medium annotation(HideResult=false);
   input Real p "Pressure in bar" annotation(HideResult=false);
   input Real h "Specific enthalpy in kJ/kg" annotation(HideResult=false);
   input Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
   input Real T "Temperature in degC" annotation(HideResult=false);
   input Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);
  input Real xi[medium.nc-1] "Mass concentrations" annotation(HideResult=false);

  annotation (defaultComponentName="eyeIn",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2), graphics={
                 Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={190,190,190},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{-100,99},{100,0},{-100,-100},{-100,99}},
          lineColor={153,205,221},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={118,106,98},
          textString="%name")}));


end EyeInGas;
