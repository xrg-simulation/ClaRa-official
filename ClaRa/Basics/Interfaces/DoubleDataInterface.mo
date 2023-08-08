within ClaRa.Basics.Interfaces;
model DoubleDataInterface "Two data connectors named dat1 and dat2"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  input Real p_int_1;
  input Real p_int_2         annotation(HideResult=true);
  input Real h_int_1;
  input Real h_int_2         annotation(HideResult=true);
  input Real m_flow_int_1;
  input Real m_flow_int_2              annotation(HideResult=true);
  input Real T_int_1;
  input Real T_int_2          annotation(HideResult=true);
  input Real s_int_1;
  input Real s_int_2          annotation(HideResult=true);
  ClaRa.Basics.Interfaces.EyeOut dat1
    annotation (Placement(transformation(extent={{-70,96},{-50,116}})));

  ClaRa.Basics.Interfaces.EyeOut dat2
    annotation (Placement(transformation(extent={{70,96},{90,116}})));
equation
    dat1.p=p_int_1;
    dat1.h=h_int_1;
    dat1.m_flow=m_flow_int_1;
    dat1.T=T_int_1;
    dat1.s=s_int_1;
    dat2.p=p_int_2;
    dat2.h=h_int_2;
    dat2.m_flow=m_flow_int_2;
    dat2.T=T_int_2;
    dat2.s=s_int_2;

  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
</html>"),Diagram(graphics));
end DoubleDataInterface;
