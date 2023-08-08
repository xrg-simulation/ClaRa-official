within ClaRa.Visualisation;
model Hexdisplay_3 "Area-temperature diagram for HEX with three zones"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  input ClaRa.Basics.Units.Temperature T_o[6]=zeros(6) "Hot side temperatures (if showInterface=false)" annotation (Dialog(group="Input", enable=not showInterface));
  input ClaRa.Basics.Units.Temperature T_i[6]=zeros(6) "Hot side temperatures (if showInterface=false)" annotation (Dialog(group="Input", enable=not showInterface));
  input Real z_o[6] "Position of zone limits at outer side" annotation(Dialog(group="Input", enable=not showInterface));
  input Real z_i[6] "Position of zone limits at inner side" annotation(Dialog(group="Input", enable=not showInterface));
  parameter Real y_min=0 "Choose or guess the minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real y_max(min=y_min+Modelica.Constants.eps)=1 "Choose or guess the maximal value of the y-axis"
                                                      annotation(Dialog(group="Layout"));
  parameter String Unit="[-]" "Unit for plot variable" annotation(Dialog(group="Layout"));
  parameter Boolean outerPhaseChange= true "True if phase change at outer side";
public
  constant ClaRa.Basics.Types.Color colorh={167,25,48} "Line color"         annotation (Hide=false, Dialog(group="Layout"));
  constant ClaRa.Basics.Types.Color colorc={0,131,169} "Line color"         annotation (Hide=false, Dialog(group="Layout"));

protected
  Real y_o[ size(z_o, 1)];
  Real y_i[ size(z_i, 1)];

public
  Real yps[6] = if outerPhaseChange then z_o else z_i;
  final Real[size(z_o, 1), 2] point_o=transpose({z_o*100,y_o})  annotation(Hide=false);
  final Real[size(z_i, 1), 2] point_i=transpose({z_i*100,y_i})  annotation(Hide=false);

equation
  for i in 1:6 loop
     y_o[i] = if T_o[i] < y_min then (1-(y_max -y_min)/(y_max - y_min))*100 else
           if  T_o[i] > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
               (1-(y_max -T_o[i])/(y_max - y_min))*100;

  end for;
  for i in 1:size(y_i, 1) loop
    y_i[i] = if T_i[i] < y_min then     (1-(y_max -y_min)/(y_max - y_min))*100 else
          if  T_i[i] > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
              (1-(y_max -T_i[i])/(y_max - y_min))*100;

  end for;

annotation (    Icon(coordinateSystem(preserveAspectRatio=true, extent={{0,0},{
            100,100}}),   graphics={
        Rectangle(
          extent=DynamicSelect({{50,100},{100,0}}, {{yps[5]*100,100},{yps[6]*100,0}}),
          lineColor={27,36,42},
          fillColor={164,167,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{10,100},{50,0}}, {{yps[3]*100,100},{yps[4]*100,0}}),
          lineColor={27,36,42},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{0,100},{10,0}}, {{0,100},{yps[2]*100,0}}),
          lineColor={27,36,42},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid),
        Text(
            extent={{2,94},{-18,100}},
            lineColor={27,36,42},
            textString="%y_max"),
        Text(
          extent={{-16,6},{2,0}},
          lineColor={27,36,42},
          textString="%y_min"),
          Text(
            extent={{66,-4},{36,-12}},
            lineColor={27,36,42},
          textString="Area"),
        Text(
          extent={{-20,114},{120,104}},
          lineColor={27,36,42},
          textString="%Unit"),
        Line(
          points=DynamicSelect({{0,20},{50,57},{70,42},{100,100}}, point_o),
          color=DynamicSelect({167,25,48},colorh),
          pattern=LinePattern.Solid,
          thickness=0.5),
        Line(
          points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, point_i),
          color=DynamicSelect({0,131,169},colorc),
          pattern=LinePattern.Solid,
          thickness=0.5),
        Line(
          points={{50,0},{50,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{10,0},{10,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{20,0},{20,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{30,0},{30,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{40,0},{40,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{100,0},{100,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{90,0},{90,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{80,0},{80,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{70,0},{70,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{60,0},{60,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Text(
          extent={{96,-3},{104,-5}},
          lineColor={27,36,42},
          textString="1"),
        Text(
          extent={{44,-3},{56,-5}},
          lineColor={27,36,42},
          textString="0.5"),
        Text(
          extent={{-4,-3},{4,-6}},
          lineColor={27,36,42},
          textString="0")},
          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1), graphics)), Diagram(coordinateSystem(extent={{0,0},{
            100,100}})));
end Hexdisplay_3;
