within ClaRa.Basics.Interfaces;
connector FuelSlagFlueGas_outlet "Port describing Coal,Slag and FlueGas flow"

extends ClaRa.Basics.Interfaces.FuelSlagFlueGas_inlet;

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
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
</body>
</html>"),
   Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          lineThickness=0.5,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-45,45},{45,-45}},
          lineColor={27,36,42},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-35,35},{35,-35}},
          lineColor={255,255,255},
          fillColor={234,171,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics));
end FuelSlagFlueGas_outlet;
