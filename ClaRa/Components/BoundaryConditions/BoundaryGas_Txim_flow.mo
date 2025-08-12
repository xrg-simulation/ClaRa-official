within ClaRa.Components.BoundaryConditions;
model BoundaryGas_Txim_flow "A gas source defining mass flow, temperature and composition"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
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

 extends ClaRa.Basics.Icons.FlowSource;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=if energyType == 1 then -gas_a.m_flow*h_port else 0,
    powerOut_th=if energyType == 2 then  gas_a.m_flow*h_port else 0,
    powerOut_elMech=0,
    powerAux=0)  if contributeToCycleSummary;

  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer  energyType=0 "Type of energy" annotation(Dialog(tab="Summary and Visualisation"), choices(choice = 0 "Energy is loss", choice = 1 "Energy is effort", choice=2 "Energy is profit"));

  parameter TILMedia.GasTypes.BaseGas                 medium = simCenter.flueGasModel "Medium to be used in tubes"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_m_flow=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Basics.Units.MassFlowRate m_flow_const=0 "Constant mass flow rate" annotation (Dialog(group="Constant Boundaries", enable=not variable_m_flow));
  parameter Basics.Units.Temperature T_const=simCenter.T_amb_start "Constant specific temperature of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_T));
  parameter Basics.Units.MassFraction xi_const[medium.nc-1]=medium.xi_default "Constant composition"
                           annotation(Dialog(group="Constant Boundaries", enable= not variable_xi));

  outer ClaRa.SimCenter simCenter;
protected
  Basics.Units.MassFlowRate m_flow_in;
  Basics.Units.Temperature T_in;
  Basics.Units.MassFraction xi_in[medium.nc-1];
  Basics.Units.EnthalpyMassSpecific h_port;
  Basics.Units.EntropyMassSpecific s_port;

public
  ClaRa.Basics.Interfaces.GasPortOut gas_a(Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput m_flow=m_flow_in if (variable_m_flow) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T=T_in if (variable_T) "Variable specific temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[medium.nc-1]=xi_in
    if (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));

  Basics.Interfaces.EyeOutGas eyeOut(medium=medium) annotation (Placement(transformation(extent={{100,-80},{106,-74}}),
                                  iconTransformation(extent={{94,-86},{106,-74}})));
protected
  TILMedia.Gas GasObject(gasType=medium);
  Basics.Interfaces.EyeInGas eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{76,-78},{74,-76}}),
                                  iconTransformation(extent={{90,-84},{84,-78}})));
equation

  h_port = GasObject.h_pTxi(gas_a.p,noEvent(actualStream(gas_a.T_outflow)),noEvent(actualStream(gas_a.xi_outflow)));
  s_port = GasObject.s_pTxi(gas_a.p,noEvent(actualStream(gas_a.T_outflow)),noEvent(actualStream(gas_a.xi_outflow)));

  if (not variable_m_flow) then
    m_flow_in=m_flow_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  gas_a.T_outflow=T_in;
  gas_a.m_flow=-m_flow_in;
  gas_a.xi_outflow=xi_in;

    //______________Eye port variable definition________________________
  eye_int[1].m_flow = -gas_a.m_flow;
  eye_int[1].T = noEvent(actualStream(gas_a.T_outflow))-273.15;
  eye_int[1].s = s_port/1e3;
  eye_int[1].p = gas_a.p/1e5;
  eye_int[1].h = h_port/1e3;
  eye_int[1].xi=noEvent(actualStream(gas_a.xi_outflow));

  connect(eye_int[1], eyeOut) annotation (Line(points={{75,-77},{103,-77}}, color={190,190,190}));
   annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
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
   Icon(graphics={
        Text(
          extent={{-100,30},{60,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T, xi")}));
end BoundaryGas_Txim_flow;
