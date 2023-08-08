within ClaRa.Components.Sensors;
model TinySensorGas_L1_O2dry "Ideal O2 concentration sensor | rel. to dry gas."

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

  outer ClaRa.SimCenter simCenter;
  extends ClaRa.Basics.Icons.PressureSensor;
  parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "p.u.", choice=2 "%"));

  Modelica.Blocks.Interfaces.RealOutput yps_O2dry "Fraction O2 re. to dry flow"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{60,-40},{80,-20}})));
  ClaRa.Basics.Interfaces.GasPortIn   port(Medium=medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

  constant Integer N_O2=6 "Index of O2 in gas fraction vector";
  constant Integer N_H2O=8 "Index of H2O in gas fraction vector";
  final parameter String unit = if unitOption==1 then " p.u." elseif unitOption==2 then " %%"  else "fgj";
  TILMedia.Gas_pT gas(p = port.p, T = inStream(port.T_outflow), xi = inStream(port.xi_outflow), gasType= medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  if unitOption == 1 then
    yps_O2dry = gas.x[N_O2]/(1-gas.x[N_H2O]);
  elseif unitOption == 2 then
    yps_O2dry=100*gas.x[N_O2]/(1-gas.x[N_H2O]);
  else
    yps_O2dry = -1;
    assert(false, "Unsupported unitOption in" + getInstanceName());
  end if;

  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(medium.nc - 1);
  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://
<a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-100},{60,20}}), graphics={
        Text(
          extent={{-68,12},{52,-68}},
          lineColor={118,124,127},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="O"),
        Line(points={{60,-30},{46,-30}}, color={27,36,42}),
        Text(
          extent={{-80,19},{80,49}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if yps_O2dry < 0 then {167,25,48} else {118,106,98}),
          textString=DynamicSelect(" O2 ", String(yps_O2dry, format="1.3f") + unit),
          horizontalAlignment=TextAlignment.Center),
        Text(
          extent={{-8,-36},{46,-70}},
          lineColor={118,124,127},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="2")}),                                   Diagram(coordinateSystem(extent={{-60,-100},{60,20}})));
end TinySensorGas_L1_O2dry;
