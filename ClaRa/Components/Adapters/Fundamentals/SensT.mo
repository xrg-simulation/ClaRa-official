within ClaRa.Components.Adapters.Fundamentals;
model SensT "ThermoPower's temperature sensor"

//_____________________________________________________________________________________
//  This definition was taken from Francesco Casella's library ThermoPower
//  http://sourceforge.net/projects/thermopower/
//_____________________________________________________________________________________

  replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
  Medium.BaseProperties fluid;
  FlangeA inlet(redeclare package Medium = Medium)
                                  annotation (Placement(transformation(extent={{-80,-60},{-40,-20}}, rotation=0)));
  FlangeB outlet(redeclare package Medium = Medium)
                                   annotation (Placement(transformation(extent={{40,-60},{80,-20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput T
    annotation (Placement(transformation(extent={{60,40},{100,80}}, rotation=0)));
equation
  inlet.w + outlet.w = 0 "Mass balance";
  inlet.p = outlet.p "No pressure drop";
  // Set fluid properties
  fluid.p=inlet.p;
  fluid.h = if inlet.w >= 0 then inlet.hBA else inlet.hAB;
  T = fluid.T;

  // Boundary conditions
  inlet.hAB = outlet.hAB;
  inlet.hBA = outlet.hBA;

  annotation (
    Diagram(graphics),
    Icon(            graphics={
        Ellipse(
          extent={{-28,90},{30,32}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Text(
          extent={{-40,84},{38,34}},
          lineColor={0,0,0},
          textString=
               "T"),
        Line(points={{-60,-40},{62,-40}}, color={0,0,255}),
        Line(points={{0,-40},{0,32}}, color={0,0,255})}),
    Documentation(info="<HTML>
<p>This component can be inserted in a hydraulic circuit to measure the temperature of the fluid flowing through it.
<p>Flow reversal is supported.
</HTML>",
      revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Standard medium definition added.</li>
<li><i>1 Jul 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted to Modelica.Media.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
end SensT;
