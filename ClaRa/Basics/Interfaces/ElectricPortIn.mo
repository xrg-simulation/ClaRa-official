within ClaRa.Basics.Interfaces;
connector ElectricPortIn
  flow SI.Power P "Active power";
  SI.Frequency f "Frequency";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={115,150,0},
          lineThickness=0.5,
          fillColor={115,150,0},
          fillPattern=FillPattern.Solid)}));
end ElectricPortIn;
