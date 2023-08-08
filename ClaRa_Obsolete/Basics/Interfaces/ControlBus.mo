within ClaRa_Obsolete.Basics.Interfaces;
expandable connector ControlBus "A bus"
  extends Modelica.Icons.SignalBus;
  extends Icons.ObsoleteConnector_v1_1;

  ClaRa.Basics.Interfaces.SteamSignal steamSignal;
annotation (defaultComponentPrefixes="protected",
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(graphics));
end ControlBus;
