within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
partial model GeneralHeatExchanger_L3
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.1                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2023, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  import Modelica.Constants.eps;
  input Real NTU_1[3] "Number of Transfer Units at limiting side";
  input Real R_1[3] "Ratio of heat capacity flows at limiting side";
  output Real CF_NTU[3](start={1,1,1}) "Correction factor for heat flow based on the NTU method";

  parameter Real a "Geometry fitting factor";
  parameter Real b "Geometry fitting exponent";
  parameter Real c "Geometry fitting exponent";
  parameter Real d "Geometry fitting exponent";

  outer ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3 iCom;
  outer Boolean outerPhaseChange;
  outer Real yps_2ph;
  outer Real yps_1ph;

  Real yps[3] "Area fraction of the three zones";

  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_in[3] "Spec. enthalpy at the zone borders - inner side";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_in[3] "Spec. enthalpy at the zone borders - outer side";

  ClaRa.Basics.Units.Temperature T_in2out_o[6] "Temperatures at the zone borders - outer side";
  ClaRa.Basics.Units.Temperature T_in2out_i[6] "Temperatures at the zone borders - inner side";
  Real ff_i[3] "Mass Flow Fraction for the three zones at inner side";
  Real ff_o[3] "Mass Flow Fraction for the three zones at outer side";
  Real z_i[6] "Position of the zones at the inner side of the heat exchanger";
  Real z_o[6] "Position of the zones at the outer side of the heat exchanger";

equation
  CF_NTU = {1/(1+a*R_1[i]^(d*b)*max(eps,NTU_1[i])^b)^c for i in 1:3};

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2023.</p>
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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"), Icon(graphics={Polygon(
          points={{100,-34},{100,-36},{46,-24},{46,-24},{10,-46},{-40,6},{-48,
              16},{-22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={153,205,211},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,6},
          rotation=180,
          lineColor={0,0,0}),        Polygon(
          points={{100,-34},{100,-36},{66,4},{66,4},{10,-46},{-40,6},{-48,16},{
              -22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,-14},
          rotation=0,
          lineColor={0,0,0})}));
end GeneralHeatExchanger_L3;
