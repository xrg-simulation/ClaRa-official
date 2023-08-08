within ClaRa.Components.Adapters;
model FuelAerosolDistributor "fuel2aerosol-interface, defines particle diameter classes and mass fractions of aerosol flow"

  extends ClaRa.Basics.Icons.Adapter2_fw;

  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification=ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_geo02() annotation (Dialog(group="Fundamental Medium Definitions"), choicesAllMatching=true);
  parameter ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1]=((1/classification.N_class)*ones(classification.N_class-1)) "Particle class mass fraction" annotation(Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.FuelOutletDistr outlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.Fuel_inlet inlet(fuelModel = fuelModel) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));

equation
  outlet.p = inlet.p;
  outlet.m_flow = -inlet.m_flow;

  outlet.classFraction_outflow = classFraction;
  outlet.T_outflow = inStream(inlet.T_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  inlet.xi_outflow = inStream(outlet.xi_outflow);
  inlet.T_outflow = inStream(outlet.T_outflow);

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
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelAerosolDistributor;
