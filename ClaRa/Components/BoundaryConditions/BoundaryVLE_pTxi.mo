within ClaRa.Components.BoundaryConditions;
model BoundaryVLE_pTxi "A boundary defining pressure, temperature and composition"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends ClaRa.Basics.Icons.FlowSink;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=if massFlowIsLoss then 0 else min(0, steam_a.m_flow*actualStream(steam_a.h_outflow)),
    powerOut=if massFlowIsLoss then 0 else max(0, steam_a.m_flow*actualStream(steam_a.h_outflow)),
    powerAux=0) if                                                                                                     contributeToCycleSummary;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_p=false "True, if pressure defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean massFlowIsLoss = true "True if mass flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

  parameter SI.Pressure p_const=0 "Constant pressure"  annotation(Dialog(group="Constant Boundaries", enable= not variable_p));
  parameter SI.Temperature T_const=293.15 "Constant specific temperature of source"
                                               annotation(Dialog(group="Constant Boundaries", enable= not hInputIsActive));
  parameter SI.MassFraction xi_const[medium.nc-1]=zeros(medium.nc-1) "Constant composition"
                            annotation(Dialog(group="Constant Boundaries", enable= not variable_xi));
  parameter SI.Pressure Delta_p= 0 "Flange pressure drop at nominal mass flow (zero refers to ideal boundary)"
                                                                                              annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom= 1 "Nominal flange mass flow "            annotation(Dialog(group="Nominal Values"));
  outer ClaRa.SimCenter simCenter;
protected
  SI.Pressure p_in;
  SI.Temperature T_in;
  SI.MassFraction xi_in[medium.nc-1];

public
  ClaRa.Basics.Interfaces.FluidPortIn steam_a(Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput p(value=p_in) if (variable_p) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable specific temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[medium.nc-1](value=xi_in) if
       (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Basics.Interfaces.EyeOut       eye if showData
    annotation (Placement(transformation(extent={{94,-86},{106,-74}}),
        iconTransformation(extent={{94,-86},{106,-74}})));
protected
  Basics.Interfaces.EyeIn       eye_int[1]
    annotation (Placement(transformation(extent={{55,-81},{57,-79}}),
        iconTransformation(extent={{55,-55},{57,-53}})));

   TILMedia.VLEFluid_pT fluidOut(
    vleFluidType=medium,
    p=p_in,
    T=T_in,
    xi=xi_in) annotation (Placement(transformation(extent={{64,-10},{84,10}})));

equation
  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  steam_a.h_outflow=fluidOut.h;
  if Delta_p>0 then
    steam_a.p=p_in + Delta_p/m_flow_nom*steam_a.m_flow;
  else
    steam_a.p=p_in;
  end if;
  steam_a.xi_outflow=xi_in;

  eye_int[1].m_flow = -steam_a.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = steam_a.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;
  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-80},{56,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Text(
          extent={{-100,30},{10,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T
xi")}),                       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics));
end BoundaryVLE_pTxi;
