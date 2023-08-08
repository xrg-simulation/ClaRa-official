within ClaRa.StaticCycles.Furnace;
model TripleFlueGas "Visualise static cycle results of flue gas connectors"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
    outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
record DecimalSpaces
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer p=1 "Accuracy to be displayed for enthalpy";
parameter Integer T=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_base gasSignal(flueGas=flueGas) annotation (Placement(transformation(extent={{-108,-20},{-100,0}}), iconTransformation(extent={{-120,-20},{-100,40}})));

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1),     graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.T > 273.15 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("T", String(gasSignal.T-273.15,format="1." + String(decimalSpaces.T) + "f") + " °C")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.p > 0 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("p", String(gasSignal.p/1e5,format="1." + String(decimalSpaces.p) + "f") + " bar")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.m_flow > 0 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("m", String(gasSignal.m_flow,format="1." + String(decimalSpaces.m_flow) + "f") + " kg/s")),
        Line(
          points={{-100,180},{-100,-100}},
          color=DynamicSelect({164,167,170},{118,106,98}),
          smooth=Smooth.None,thickness=0.5)}), Diagram(graphics,
                                                       coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1)));

end TripleFlueGas;
