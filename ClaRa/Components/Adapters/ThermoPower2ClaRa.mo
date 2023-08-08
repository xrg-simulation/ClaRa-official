within ClaRa.Components.Adapters;
model ThermoPower2ClaRa "Adapter for ThermoPower 2.2 to ClaRa fluid connector"
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
  replaceable package ThermoPowerMedium =
      Modelica.Media.Water.WaterIF97_ph "Medium model of the ThermoPower part"
                                           annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid ClaRaMedium = simCenter.fluid1 "Medium model of the ClaRa part"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  ClaRa.Components.Adapters.Fundamentals.FlangeA flangeA(redeclare package Medium =
        ThermoPowerMedium)                                                                             annotation (Placement(transformation(extent={{-108,-12},{-88,8}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  Basics.Interfaces.FluidPortOut       outlet(Medium=ClaRaMedium)                 annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));

equation
  flangeA.w+outlet.m_flow = 0;
  flangeA.hAB = inStream(outlet.h_outflow);
  flangeA.hBA = outlet.h_outflow;

  flangeA.p = outlet.p;
  outlet.xi_outflow =ones(ClaRaMedium.nc-1);

  annotation (Documentation(info="<html>
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
</body>
</html>"),defaultComponentName =     "thermopower2clara",
          Icon(graphics={Polygon(
          points={{-96,10},{2,10},{36,-10},{-98,-10},{-96,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Polygon(
          points={{100,10},{100,10},{-20,10},{-20,10},{-12,0},{0,0},{12,0},{20,
              -10},{20,-10},{100,-10},{100,-10},{100,10}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid)}), Diagram(graphics));
end ThermoPower2ClaRa;
