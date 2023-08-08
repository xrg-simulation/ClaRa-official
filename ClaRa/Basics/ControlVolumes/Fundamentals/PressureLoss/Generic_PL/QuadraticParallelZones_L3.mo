within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticParallelZones_L3 "All geo | L3 | quadratic | parallel zones | nominal point"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3(final hasPressureLoss=true);

  parameter Units.Pressure Delta_p_nom[iCom.N_inlet]=ones(iCom.N_inlet)*1000 "Nominal ressure loss";
  parameter Units.PressureDifference Delta_p_smooth=100 "Small pressure difference for linearisation around zero mass flow";
  parameter Real CF_backflow=1 "Enhancement factor for reverse flow pressure loss";
  //   SI.PressureDifference Delta_p[iCom.N_inlet]
  //     "Pressure difference du to friction";

  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_inlet]=Delta_p_nom ./ iCom.m_flow_nom;
equation
  //   iCom.m_flow_in = {semiLinear(ClaRa.Basics.Functions.ThermoRoot(Delta_p[i]/Delta_p_nom[i], Delta_p_smooth/Delta_p_nom[i]), 1, CF_backflow)*sqrt(1/zeta[i]) for i in 1:iCom.N_inlet};
  iCom.m_flow_in = {homotopy(iCom.m_flow_nom*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i]/Delta_p_nom[i], Delta_p_smooth/Delta_p_nom[i]), iCom.m_flow_nom/Delta_p_nom[i]*Delta_p[i]) for i in 1:iCom.N_inlet};

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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end QuadraticParallelZones_L3;
