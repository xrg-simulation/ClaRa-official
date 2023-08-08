within ClaRa.Basics.Records;
model FlangeVLE "A summary of flange flow properties"
  extends Icons.RecordIcon;

  parameter Boolean showExpertSummary= false;
  input Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
  input Units.Temperature T "Temperature" annotation (Dialog);
  input Units.Pressure p "Pressure" annotation (Dialog);
  input Units.EnthalpyMassSpecific h "Specific enthalpy" annotation (Dialog);
  input Units.EntropyMassSpecific s if  showExpertSummary "Specific entropy" annotation (Dialog);
  input Units.MassFraction steamQuality if showExpertSummary "Steam quality" annotation (Dialog);
  input Units.Power H_flow if showExpertSummary "Enthalpy flow rate" annotation (Dialog);
  input Units.DensityMassSpecific rho if showExpertSummary "Density" annotation (Dialog);
annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end FlangeVLE;
