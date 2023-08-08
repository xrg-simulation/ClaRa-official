within ClaRa.Components.Adapters.Fundamentals;
model SourceP "Pressure source for water/steam flows"

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.7.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
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

  import Modelica.Units.SI.*;

  type HydraulicResistance = Real (final quantity="HydraulicResistance", final unit=
             "Pa/(kg/s)");
  replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";

  parameter Pressure p0=1.01325e5 "Nominal pressure";
  parameter HydraulicResistance R=0 "Hydraulic resistance";
  parameter SpecificEnthalpy h=1e5 "Nominal specific enthalpy";
  Pressure p "Actual pressure";
  FlangeB flange(redeclare package Medium=Medium)
                 annotation (Placement(transformation(extent={{80,-20},{120,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput in_p0
    annotation (Placement(transformation(
        origin={-40,92},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Modelica.Blocks.Interfaces.RealInput in_h
    annotation (Placement(transformation(
        origin={40,90},
        extent={{-20,-20},{20,20}},
        rotation=270)));
equation
  if R == 0 then
    flange.p = p;
  else
    flange.p = p + flange.w*R;
  end if;

  p = in_p0;
  if cardinality(in_p0)==0 then
    in_p0 = p0 "Pressure set by parameter";
  end if;

  flange.hBA =in_h;
  if cardinality(in_h)==0 then
    in_h = h "Enthalpy set by parameter";
  end if;
    annotation (Documentation(info="<html>
<<p><b>Modelling options</b></p>
<p>If <tt>R</tt> is set to zero, the pressure source is ideal; otherwise, the outlet pressure decreases proportionally to the outgoing flowrate.</p>
<p>If the <tt>in_p0</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>p0</tt>.</p>
<p>If the <tt>in_h</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>h</tt>.</p>    
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model and standard medium definition added.</li>
<li><i>18 Jun 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Removed <tt>p0_fix</tt> and <tt>hfix</tt>; the connection of external signals is now detected automatically.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</body>
</html>"),
    Icon(
      graphics={
        Text(extent={{-106,90},{-52,50}}, textString=
                                                 "p0"),
        Text(extent={{66,90},{98,52}}, textString=
                             "h"),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere),
        Line(points={{-2,0},{100,0}}, color={0,0,255})}));
end SourceP;
