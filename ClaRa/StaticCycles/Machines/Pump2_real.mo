﻿within ClaRa.StaticCycles.Machines;
model Pump2_real "Real Pump || par.: efficiency, pressure ratio || blue | blue"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2024, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  // Blue input: Values of p is known and provided FOR neighbor component, values of m_flow and h are unknown in component and provided BY neighbor component.
  // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
    //---------Summary Definition---------
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter ClaRa.Basics.Units.Pressure Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    parameter ClaRa.Basics.Units.Power P_pump "Pump power" annotation (Dialog);
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
        Outline outline;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out),
  outline(Delta_p=Delta_p,
     P_pump=P_pump));
  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
                              annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter Real efficiency= 1 "Pump efficiency" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real Pi_nom = 1 "Nominal Pressure ratio" annotation(Dialog(group="Fundamental Definitions"));
  outer parameter Real P_target_;
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in=TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_in) "Inlet density";
  final parameter ClaRa.Basics.Units.Power P_pump=(h_out - h_in)*m_flow "Pump power";
  //protected
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in + (TILMedia.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in)/efficiency "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p=p_in - p_out "Presssure differerence p_in - p_out";

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(p=p_in,Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet(m_flow=m_flow, h=h_out,Medium=medium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));

initial equation
  inlet.h = h_in;
  inlet.m_flow = m_flow;
  outlet.p = p_out;

  p_out/p_in=Pi_nom*P_target_;

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

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
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
</html>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p <= 0 then FillPattern.Solid else FillPattern.Backward)),
        Line(
          points={{-100,0},{100,0}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None),
        Line(
          points={{60,40},{100,0},{58,-42}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None)}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end Pump2_real;
