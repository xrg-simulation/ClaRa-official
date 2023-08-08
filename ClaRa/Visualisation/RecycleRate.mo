within ClaRa.Visualisation;
model RecycleRate "Diplays fraction of input mass flows"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

//   input Real m=1 "Variable value" annotation (Dialog);
//   input Real p=1 "Variable value" annotation (Dialog);
//   input Real h=1 "Variable value" annotation (Dialog);
//   input Real T=1 "Variable value" annotation (Dialog);

//  parameter String unit="C" "Variable unit";
  parameter Integer decimalSpaces=1 "Accuracy to be displayed";
  parameter Integer identifier= 0 "Identifier of the quadruple";
Real rate "recyle rate";
  ClaRa.Basics.Interfaces.EyeIn denominator "denominator of fraction"
                                                annotation (Placement(
        transformation(extent={{-210,-110},{-190,-90}}), iconTransformation(
          extent={{-210,-110},{-190,-90}})));

  Basics.Interfaces.EyeIn      numerator "numerator of fraction"
    annotation (Placement(transformation(extent={{188,-110},{208,-90}})));

equation
  rate = denominator.m_flow/numerator.m_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,0}},
        initialScale=0.05),    graphics={
        Rectangle(
          extent={{-200,0},{200,-200}},
          fillColor={234,234,234},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid),
        Text(
          extent={{-198,-2},{198,-198}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({0, 0, 0}, if rate > 0 then {0,0,0} else {255,0,0}),
          textString=DynamicSelect(" rate ", String(rate,format="1."+ String(decimalSpaces)+"f")))}),
                                            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -200},{200,0}},
        initialScale=0.05),  graphics));
end RecycleRate;
