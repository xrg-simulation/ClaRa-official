within ClaRa.Basics.Choices;
type HeatTransfer = enumeration(
    pipeBoilingHor "A straight pipe | turbulent | laminar | horizontal boiling",
    pipeBoilingVer "A straight pipe | turbulent | laminar | vertical boiling",
    pipeCondensationHor "A straight pipe | turbulent | laminar | horizontal condensation") annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-80,100},{100,-80}}, color={255,0,0}),
      Line(points={{80,100},{-100,-80}}, color={255,0,0}),
      Line(points={{-100,80},{80,-100}}, color={255,0,0}),
      Line(points={{100,80},{-80,-100}}, color={255,0,0})}));
