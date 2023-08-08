within ClaRa_Obsolete.StaticCycles;
model Dispatcher "Ideal fuel dispatcher"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  // Yellow input: Values of p, h are unknown and provided BY neighbor component, values of m_flow is known in component and provided FOR neighbor component.
  // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.

  import ClaRa.Basics.Constants.*;
  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));

  parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Nominal lower heating value" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFraction xi_fuel[fuelType.nc-1] = fuelType.defaultComposition "Fuel composition" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer N_burner_levels "Number of burner levels" annotation(Dialog(group="Fundamental Definitions"));

  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Combustion Air"));
  parameter ClaRa.Basics.Units.MassFraction xi_pa_in[flueGas.nc-1] = {0,0,0,0,0.77,0.23,0,0,0} "Primary air inlet composition" annotation(Dialog(group="Combustion Air"));
  parameter Real lambda = 1.15 "Excess air" annotation(Dialog(group="Combustion Air"));

  parameter ClaRa.Basics.Units.Power P_el_nom "Nominal electric power" annotation(Dialog(group="Nominal Operation Point"));
  parameter Real eta_el_nom "Nominal plant efficiency" annotation(Dialog(group="Nominal Operation Point"));

  parameter Real CharLine_P_el_[:,2]=[0,1;1,1] "Characteristic line of P_el as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_eta_el_[:,2]=[0,1;1,1] "Characteristic line of eta_el as function of P_target_" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Power P_el(fixed=false) "Electric power";
  final parameter Real eta_el(fixed=false) "Plant efficiency";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel = P_el/(eta_el*LHV)/N_burner_levels "Fuel mass flow (per burner level)";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_pa = Pi_m_flows*m_flow_fuel "Rprt: Primary air mass flow (per burner level)";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_total = (m_flow_fuel + m_flow_pa)*N_burner_levels "Total flue gass implied by all mills";

  final parameter Real Pi_m_flows = lambda*(n_flow_C_primary + n_flow_H_primary/4.0 + n_flow_S_primary - n_flow_O_primary/2)*ClaRa.Basics.Constants.M_O *2.0/max(1e-32,xi_pa_in[6])/m_flow_fuel;

  FuelSignal_black_b fuelSignal_black[N_burner_levels](
    each fuelType=fuelType,
    each m_flow=m_flow_fuel,
    each xi=xi_fuel,
    each LHV=LHV) annotation (Placement(transformation(extent={{100,-10},{108,10}}), iconTransformation(extent={{100,-10},{108,10}})));

protected
  final parameter Real n_flow_C_primary= xi_fuel[1].*m_flow_fuel/M_C;
  final parameter Real n_flow_H_primary= xi_fuel[2].*m_flow_fuel/M_H;
  final parameter Real n_flow_O_primary= xi_fuel[3].*m_flow_fuel/M_O;
  final parameter Real n_flow_S_primary= xi_fuel[5].*m_flow_fuel/M_S;
  Modelica.Blocks.Tables.CombiTable1Dv table1(table=CharLine_P_el_, u={P_target_});
  Modelica.Blocks.Tables.CombiTable1Dv table2(table=CharLine_eta_el_, u={P_target_});

initial equation
  P_el= P_el_nom*table1.y[1];
  eta_el= eta_el_nom*table2.y[1];

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{-80,60},{80,60},{-80,-60},{80,-60}}, color={0,131,169}),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.4.0"),
                                          Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid)}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end Dispatcher;
