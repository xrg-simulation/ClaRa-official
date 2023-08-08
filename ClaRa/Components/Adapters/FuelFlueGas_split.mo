within ClaRa.Components.Adapters;
model FuelFlueGas_split
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
  extends ClaRa.Basics.Icons.Adapter2_fw;

//__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter ClaRa.Basics.Media.Slag.PartialSlag slag=simCenter.slagModel "Slag properties" annotation (choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Medium to be used in tubes" annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.Fuel_outlet  fuel_outlet(fuelModel=fuelModel) annotation (Placement(transformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.GasPortOut flueGas_outlet(Medium=flueGas) annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  ClaRa.Basics.Interfaces.FuelFlueGas_inlet fuelFlueGas_inlet(flueGas(Medium=flueGas), fuelModel=fuelModel) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

equation
  fuelFlueGas_inlet.flueGas.m_flow = -flueGas_outlet.m_flow;
  fuelFlueGas_inlet.flueGas.T_outflow = inStream(flueGas_outlet.T_outflow);
  flueGas_outlet.T_outflow = inStream(fuelFlueGas_inlet.flueGas.T_outflow);
  fuelFlueGas_inlet.flueGas.xi_outflow = inStream(flueGas_outlet.xi_outflow);
  flueGas_outlet.xi_outflow = inStream(fuelFlueGas_inlet.flueGas.xi_outflow);
  fuelFlueGas_inlet.flueGas.p = flueGas_outlet.p;

  fuelFlueGas_inlet.fuel.m_flow = -fuel_outlet.m_flow;
  fuelFlueGas_inlet.fuel.T_outflow = inStream(fuel_outlet.T_outflow);
  fuel_outlet.T_outflow = inStream(fuelFlueGas_inlet.fuel.T_outflow);
  fuelFlueGas_inlet.fuel.xi_outflow = inStream(fuel_outlet.xi_outflow);
  fuel_outlet.xi_outflow = inStream(fuelFlueGas_inlet.fuel.xi_outflow);
  fuelFlueGas_inlet.fuel.p = fuel_outlet.p;

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
</html>"),
   Icon(graphics),         Diagram(graphics));
end FuelFlueGas_split;
