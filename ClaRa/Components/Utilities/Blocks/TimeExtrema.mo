within ClaRa.Components.Utilities.Blocks;
model TimeExtrema "Calculates the minimum and maximum value in a given period of time"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  parameter Basics.Units.Time startTime=0 "Start time for min/max evaluation";
  parameter Integer initOption= 0 "Init option |initial u| y_min/max_start" annotation(Dialog(group="Initialisation"), choices(choice=0 "initial u", choice=1 "initial y_min/y_max"));
  parameter Real y_start[2]= {10,-10} "Y_min_start | y_max_start"  annotation(Dialog(group="Initialisation", enable=initOption==1));
  parameter Basics.Units.Time samplingTime=1 "Sampling time for evaluating extremas";
protected
  Real ymax;
  Real ymin;

public
  Modelica.Blocks.Interfaces.RealOutput y_max
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput y_min
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  der(ymax)= if  time >= startTime then noEvent(if ymax<u then (u-ymax)/samplingTime else 0) else 0;
  der(ymin)= if  time >= startTime then noEvent(if ymin>u then (u-ymin)/samplingTime else 0) else 0;
  y_max=ymax;
  y_min=ymin;
initial equation
  if initOption==0 then
    ymax=u;
    ymin=u;
  elseif initOption ==1 then
    ymin=y_start[1];
    ymax=y_start[2];
  else
    assert(false, "Unknown initi option in component " + getInstanceName());
  end if;
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(graphics={
        Rectangle(
          extent={{-100,102},{100,-98}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,80},{-80,-78},{76,-78}},
          color={221,222,223},
          smooth=Smooth.None),
        Line(
          points={{-80,-16},{-56,34},{-30,64},{-26,-36},{-6,-38},{-2,-28},{16,20},{43.9805,-7.98047},{76,2}},
          color={221,222,223},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-18},{-58,-18},{-28,-18},{-28,-18},{-22,-40},{4,-40},{4,-40},{76,-40}},
          color={27,36,42},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-14},{-56,36},{-38,58},{-4,58},{76,58}},
          color={167,25,48},
          smooth=Smooth.Bezier)}),
                                 Diagram(graphics));
end TimeExtrema;
