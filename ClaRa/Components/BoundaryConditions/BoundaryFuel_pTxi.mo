within ClaRa.Components.BoundaryConditions;
model BoundaryFuel_pTxi "A source defining pressure, temperature and composition"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
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
    powerIn=if energyType == 1 then -fuel_a.m_flow*h_coal else 0,
    powerOut_th=if energyType == 2 then  fuel_a.m_flow*h_coal else 0,
    powerOut_elMech=0,
    powerAux=0) if  contributeToCycleSummary;
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer  energyType=0 "Type of energy" annotation(Dialog(tab="Summary and Visualisation"), choices(choice = 0 "Energy is loss", choice = 1 "Energy is effort", choice=2 "Energy is profit"));

    parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_p=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Basics.Units.Pressure p_const=1e5 "Constant mass flow rate" annotation (Dialog(group="Constant Boundaries", enable=not variable_p));
  parameter Basics.Units.Temperature T_const=simCenter.T_amb_start "Constant specific temperature of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_T));
  parameter Basics.Units.MassFraction xi_const[fuelModel.N_c - 1]=fuelModel.defaultComposition "Constant composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));

  outer ClaRa.SimCenter simCenter;
protected
  Modelica.SIunits.Pressure p_in;
  Modelica.SIunits.Temperature T_in;
  Modelica.SIunits.MassFraction xi_in[fuelModel.N_c-1];
  Basics.Units.EnthalpyMassSpecific h_coal;

  Basics.Media.FuelObject fuelObject(
    p=fuel_a.p,
    T=fuel_a.T_outflow,
    xi_c=fuel_a.xi_outflow,
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
public
  ClaRa.Basics.Interfaces.Fuel_inlet fuel_a(final fuelModel=fuelModel)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput p(value=p_in) if (variable_p) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable specific temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[fuelModel.N_c-1](value=xi_in) if
       (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
equation

  h_coal = fuelObject.LHV + fuelObject.cp*(actualStream(fuel_a.T_outflow) - 298.15);

  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  fuel_a.T_outflow=T_in;
  fuel_a.p=p_in;
  fuel_a.xi_outflow=xi_in;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                  graphics={
        Text(
          extent={{-100,30},{10,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T
xi")}),                      Diagram(graphics));
end BoundaryFuel_pTxi;
