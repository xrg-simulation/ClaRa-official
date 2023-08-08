within ClaRa.Visualisation;
model XYplot

record DecimalSpaces
  extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer x=1 "Accuracy to be displayed for abscissa";
    parameter Integer y=1 "Accuracy to be displayed for ordinate";
end DecimalSpaces;

  parameter String title = "" "Plot title" annotation(Dialog(group="Layout"));
  parameter String x_label = "" "Unit for abscissa" annotation(Dialog(group="Layout"));
  parameter String y_label = "" "Unit for ordinate" annotation(Dialog(group="Layout"));
  parameter Real x_min=0 "Minimal value of the x-axis" annotation(Dialog(group="Layout"));
  parameter Real x_max=1 "Maximal value of the x-axis" annotation(Dialog(group="Layout"));
  parameter Real y_min=0 "Minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real y_max=1 "Maximal value of the y-axis" annotation(Dialog(group="Layout"));
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog(group="Layout"));



  parameter Integer N_nodes1= 3 "Number of nodes in set 1" annotation (Hide=false, Dialog(group="Set 1"));
  parameter ClaRa.Basics.Types.Color color1={0,131,169} "Line color in set 1"         annotation (Hide=false, Dialog(group="Set 1"));

  parameter Boolean activateSecondSet= false "True, to activate the 2nd set of xy" annotation (Hide=false, Dialog(group="Set 2"));
  parameter Integer N_nodes2= 3 "Number of nodes in set 2" annotation (Hide=false, Dialog(enable = activateSecondSet, group="Set 2"));
  parameter ClaRa.Basics.Types.Color color2={167,25,48} "Line color in set 2"         annotation (Hide=false, Dialog(enable = activateSecondSet, group="Set 2"));
  final parameter Real h_grid[3] = {0.25,0.5,0.75}*200;
  final parameter Real v_grid[3] = {0.25,0.5,0.75}*200;

  Modelica.Blocks.Interfaces.RealInput y1[N_nodes1] "First ordinate set" annotation (Placement(transformation(extent={{-100,110},{-60,150}}),iconTransformation(extent={{-80,130},{-60,150}})));
   Modelica.Blocks.Interfaces.RealInput y2[N_nodes2] if activateSecondSet "Second ordinate set" annotation (Placement(transformation(extent={{-100,20},{-60,60}}),iconTransformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Interfaces.RealInput x1[N_nodes1]   "First abscissa set"  annotation (Placement(transformation(extent={{74,-42},{114,-2}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-70})));
   Modelica.Blocks.Interfaces.RealInput x2[N_nodes2] if activateSecondSet "Second abscissa set"  annotation (Placement(transformation(extent={{74,-84},{114,-44}}), iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={120,-70})));

protected
  Real xy1[:,:] = [(x1.-x_min)./(x_max-x_min)*200, (y1.-y_min)./(y_max-y_min)*200] annotation(Hide=false);
  Real xy2[:,:](value=[(x2.-x_min)./(x_max-x_min)*200, (y2.-y_min)./(y_max-y_min)*200]) if activateSecondSet annotation(Hide=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,240},{220,-60}}), graphics={Rectangle(
          extent={{-60,240},{220,-60}},
          lineColor={27,36,42},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{0,200},{200,0}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Line(points={{0,h_grid[1]},{200,h_grid[1]}}, color={221,222,223}),
        Line(points={{0,h_grid[2]},{200,h_grid[2]}}, color={221,222,223}),
        Line(points={{0,h_grid[3]},{200,h_grid[3]}}, color={221,222,223}),
        Line(points={{v_grid[1], 0},{v_grid[1], 200}}, color={221,222,223}),
        Line(points={{v_grid[2], 0},{v_grid[2], 200}}, color={221,222,223}),
        Line(points={{v_grid[3], 0},{v_grid[3], 200}}, color={221,222,223}),
        Line(points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, xy1), color=color1),
        Line(points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, xy2), color=color2, visible= activateSecondSet),
        Text(
          extent={{-20,240},{220,200}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString="%title"),
        Text(
          extent={{-60,210},{0,190}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("y_max", String(y_max, format = "1."+String(decimalSpaces.y)+"f"))),
        Text(
          extent={{-60,140},{2,160}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max-y_min)*0.75, format = "1."+String(decimalSpaces.y)+"f"))),
        Text(
          extent={{-60,90},{2,110}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max-y_min)*0.5, format = "1."+String(decimalSpaces.y)+"f"))),
        Text(
          extent={{-60,40},{2,60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max-y_min)*0.25, format = "1."+String(decimalSpaces.y)+"f"))),
        Text(
          extent={{-60,14},{2,-6}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("y_min", String(y_min, format = "1."+String(decimalSpaces.y)+"f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={0,-30},
          rotation=90,
          textString=DynamicSelect("x_min", String(x_min, format = "1."+String(decimalSpaces.x)+"f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={50,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max-x_min)*0.25, format = "1."+String(decimalSpaces.x)+"f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={100,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max-x_min)*0.5, format = "1."+String(decimalSpaces.x)+"f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={150,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max-x_min)*0.75, format = "1."+String(decimalSpaces.x)+"f"))),
        Text(
          extent={{-31,10},{31,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={201,-30},
          rotation=90,
          textString=DynamicSelect("x_max", String(x_max, format = "1."+String(decimalSpaces.x)+"f"))),
        Text(
          extent={{0,-60},{206,-40}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString="%x_label"),
        Text(
          extent={{-101,-10},{101,10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={-50,99},
          rotation=90,
          textString="%y_label")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{0,0},{200,200}})));
end XYplot;
