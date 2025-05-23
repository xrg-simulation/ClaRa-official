﻿within ClaRa.Components.Mills.HardCoalMills.Fundamentals;
record ASV3 "Loesche LM 19D: Mill 3 of Asnaes Power Station (DK)"
  extends ClaRa.Components.Mills.HardCoalMills.Fundamentals.RollerBowlMillDefinition(
                                   K_1=0.0353,
                                   K_2=0.0151,
                                   K_3=0.0442,
                                   K_4=0.5556,
                                   K_5=0.0048,
                                   K_6=2.7727,
                                   K_7=9.8144,
                                   K_8=0.0197,
                                   K_9=0.6017,
                                   K_10=4.3266,
                                   K_11=24.8e6,
                                   K_12=1.7,
                                   E_e=0.4,
                                   P_nom = 645e3);
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
</html>"));
end ASV3;
