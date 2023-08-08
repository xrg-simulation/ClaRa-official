within ClaRa.Visualisation;
model DynDisplay "Dynamic Display of one variable"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  parameter String varname = "Name of the variable";
  parameter Boolean provideConnector= false "If true a real output connector is provided";
  input Real x1=1 "Variable value" annotation (Dialog(enable= not provideConnector));
  parameter String unit="C" "Variable unit";
  parameter Integer decimalSpaces=1 "Accuracy to be displayed";
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as posible";

  outer ClaRa.SimCenter simCenter;


  Modelica.Blocks.Interfaces.RealOutput y(value=u_aux) if provideConnector annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u(value=u_aux) if provideConnector annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
                                                                                                                                             iconTransformation(extent={{-120,-10},{-100,10}})));
protected
  Real u_aux  annotation(Hide=false);
equation

  if not provideConnector then
    u_aux = x1;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,0},{100,-100}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={118,124,127}),
        Rectangle(
          extent={{-100,100},{100,0}},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={27,36,42}),
        Text(
          extent=DynamicSelect({{-100,0},{100,-100}}, if largeFonts then {{-100,0},{100,-100}} else {{-94,2},{106,-98}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if u_aux > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" x ", String(u_aux,format = "1."+String(decimalSpaces)+"f") + " %unit")),
        Text(
          extent={{-100,100},{100,0}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, {73,80,85}),
          textString="%varname")}),         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end DynDisplay;
