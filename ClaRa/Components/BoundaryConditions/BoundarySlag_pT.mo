within ClaRa.Components.BoundaryConditions;
model BoundarySlag_pT "A source defining pressure and temperature"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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
    powerIn=if energyType == 1 then -slag_inlet.m_flow*h_slag else 0,
    powerOut_th=if energyType == 2 then  slag_inlet.m_flow*h_slag else 0,
    powerOut_elMech=0,
    powerAux=0) if  contributeToCycleSummary;
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer  energyType=0 "Type of energy" annotation(Dialog(tab="Summary and Visualisation"), choices(choice = 0 "Energy is loss", choice = 1 "Energy is effort", choice=2 "Energy is profit"));

  parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_p=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if Temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));

  parameter Basics.Units.Pressure p_const=1e5 "Constant mass flow rate" annotation (Dialog(group="Constant Boundaries", enable=not mInputIsActive));
  parameter Basics.Units.Temperature T_const=simCenter.T_amb_start "Constant specific enthalpy of source" annotation (Dialog(group="Constant Boundaries", enable=not hInputIsActive));

  outer ClaRa.SimCenter simCenter;
protected
  Basics.Units.Pressure p_in;
  Basics.Units.Temperature T_in;
  Basics.Units.EnthalpyMassSpecific h_slag;

public
  Basics.Interfaces.Slag_inlet        slag_inlet(final slagType = slagType)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-12},{110,8}})));

  Modelica.Blocks.Interfaces.RealInput p(value=p_in) if (variable_p) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable specific enthalpy"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));

equation
  h_slag = slag_inlet.m_flow*slagType.cp*(actualStream(slag_inlet.T_outflow) - 298.15);

  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  /*if (not XInputIsActive) then
    X_in=X_const;
  end if;
*/
  slag_inlet.T_outflow=T_in;
  slag_inlet.p=p_in;
  //coal_a.Xi_outflow=X_in;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                  graphics={
        Text(
          extent={{-100,30},{10,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T
xi")}),                      Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                     graphics));
end BoundarySlag_pT;
