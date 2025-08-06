within ClaRa_Obsolete.StaticCycles;
model StaCyFlangeFuel "A summary record for fuel flanges"
    extends ClaRa.Basics.Icons.RecordIcon;
  replaceable parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelModel "Used medium model" annotation (Dialog(tab="System"));

    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value" annotation (Dialog);

    input ClaRa.Basics.Units.MassFraction xi[fuelModel.nc - 1] "Medium composition"  annotation(Dialog);
  annotation (Icon(graphics={            Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.4.0")}));
end StaCyFlangeFuel;
