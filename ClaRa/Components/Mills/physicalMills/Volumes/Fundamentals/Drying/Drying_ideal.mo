within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Drying;
model Drying_ideal "Ideal coal drying process to desired residual water content| driven by H2O concentration difference"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.7.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
  // Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends Drying_base;
  outer Records.iCom_Dryer iComDryer;

  parameter ClaRa.Basics.Units.MassFraction xi_H2O_res = 0.02 "residual water mass content of coal after drying";

//________Mass Flows___________
  ClaRa.Basics.Units.MassFlowRate m_flow_gas_evap_max "Maximum evaporation flow until gas saturation";
  ClaRa.Basics.Units.MassFlowRate m_flow_fuel_evap_max "Maximum evaporation flow until fuel dry out";

equation

  //Drying of Fuel: -----------------------------------------------------------------------------------------------------------------------------------
  m_flow_gas_evap_max = iComDryer.m_flow_gas_in*(iComDryer.xi_gas_out_s-iComDryer.xi_gas_in[iComDryer.mediumModel.condensingIndex]);  //Maximum H2O evaporation mass flow until gas is saturated
  m_flow_fuel_evap_max = iComDryer.m_flow_fuel_in*(1-sum(iComDryer.xi_fuel_in[:])-xi_H2O_res);  //Maximum H2O evaporation mass flow until fuel is dry

  iComDryer.m_flow_H2O_evap = min(m_flow_gas_evap_max,m_flow_fuel_evap_max);
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
</html>"));
end Drying_ideal;
