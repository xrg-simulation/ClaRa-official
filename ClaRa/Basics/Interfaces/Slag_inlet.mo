within ClaRa.Basics.Interfaces;
connector Slag_inlet
  parameter ClaRa.Basics.Media.Slag.PartialSlag slagType;
    //"Medium model";

  //constant String mediumName= Medium.materialName annotation(Dialog(enable=false));

  flow ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
   ClaRa.Basics.Units.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream ClaRa.Basics.Units.Temperature T_outflow "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";

  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={234,171,0},
          lineThickness=0.5,
          fillColor={234,171,0},
          fillPattern=FillPattern.Solid)}));
end Slag_inlet;
