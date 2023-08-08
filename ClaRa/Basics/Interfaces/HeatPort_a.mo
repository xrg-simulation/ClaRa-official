within ClaRa.Basics.Interfaces;
connector HeatPort_a
  extends Modelica.Thermal.HeatTransfer.Interfaces.HeatPort;
   annotation(defaultComponentName = "heatPort",
    Documentation(info="<HTML>
<p>This connector extends the Modelica HeatPort Interface and is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p></HTML>
"), Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={167,25,48},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={167,25,48})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={167,25,48},
          lineThickness=0.5,
          fillColor={167,25,48},
          fillPattern=FillPattern.Solid), Text(
          extent={{-120,120},{100,60}},
          lineColor={167,25,48},
          textString="%name")}));
end HeatPort_a;
