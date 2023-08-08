within ClaRa.Basics.Interfaces;
connector CycleSumPort
//    flow SI.Mass mass_fluid "Accumulated fluid mass";
    flow SI.Power power_in;
    flow SI.Power power_out;
    flow SI.Power power_aux;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={149,45,152},
          lineThickness=0.5,
          fillColor={149,45,152},
          fillPattern=FillPattern.Solid)}));
end CycleSumPort;
