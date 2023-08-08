within ClaRa_Obsolete.Components.Furnace;
model SimpleCombustionChamber
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import ClaRa;

 extends ClaRa.Basics.Icons.ComplexityLevel(complexity="1");
extends ClaRa.Basics.Icons.SimpleCombustionChamber;
extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_3;
 model Summary
 extends ClaRa.Basics.Icons.RecordIcon;
 input ClaRa.Basics.Units.Temperature T_flueGas_out "Outlet temperature";
 input ClaRa.Basics.Units.Temperature T_slag_bottom "Slag temperature";
 input Real xi_slag "Slag fraction";
 input ClaRa.Basics.Units.MassFlowRate m_flow_slag_out "Slag mass flow rate";
 input ClaRa.Basics.Units.MassFlowRate m_flow_coal_in "Coal mass flow rate";
 input ClaRa.Basics.Units.MassFlowRate m_flow_combustible_in "Mass flow rate of combustibles";
 input ClaRa.Basics.Units.MassFlowRate m_flow_gas_in "Inlet mass flow rate";
 input ClaRa.Basics.Units.MassFlowRate m_flow_flueGas_out "Flue gas mass flow rate";
 input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value";
 input ClaRa.Basics.Units.HeatFlowRate Q_flow_boiler "Combustion Heat";
 input ClaRa.Basics.Units.MassFlowRate m_flow_O2_req "Required O2 flow rate for stochiometric combustion";
 input ClaRa.Basics.Units.MassFlowRate m_flow_Air_req "Required air flow rate for stochiometric combustion";
 input Real lambda "Excess air";
 input Real xi_NOx "NOx fraction at outlet";
 input Real xi_SOx "SOx fraction at outlet";
 input ClaRa.Basics.Units.Pressure p_combustion_chamber "Combustion chamber pressure";
 end Summary;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=0,
    powerAux=inlet.fuel.m_flow*inStream(inlet.fuel.LHV_outflow)) if contributeToCycleSummary;

//__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
// inner parameter ClaRa.Basics.Media.Coal.PartialCoal coal=simCenter.coalModel
//    "Coal elemental composition used for combustion" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"),Placement(transformation(extent={{-80,52},{-60,72}})));
 parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType=simCenter.fuelModel1 "Coal elemental composition used for combustion"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
 parameter ClaRa.Basics.Media.Slag.PartialSlag slagType = simCenter.slagModel "Slag properties" annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
 inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used in tubes" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

//___________________________/ Parameters \_________________________________________________________
 parameter ClaRa.Basics.Units.Temperature T_flueGas_out = 573.15 "Temeperature of fluegas leaving the combustion chamber towards deNOx-Filter"
                                                                                              annotation(Dialog(group="Fixed Boundaries"));
 parameter ClaRa.Basics.Units.Temperature T_slag_bottom = 773.15 "Temeperature of slag collected at bottom of the chamber" annotation(Dialog(group="Fixed Boundaries"));
 parameter Real xi_slag(min = 0, max= 1) = 0.1 "Mass fraction of slag leaving chamber at bottom, related to ash fraction entering the chamber"
                                                                                              annotation(Dialog(group="Fixed Boundaries"));

 parameter ClaRa.Basics.Units.MassFraction_ppm xi_NOx = 1000 "NOx mass fraction [ug/kg] in fluegas leaving the combustion chamber"
                                                                                              annotation(Dialog(group="Fixed Boundaries"));
/* parameter ClaRa.Basics.Units.MassFraction_ppm xi_SOx = 1000 
    "SOx mass fraction [ug/kg] in fluegas leaving the combustion chamber"                                                           annotation(Dialog(group="Fixed Boundariess"));
*/

 parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

//______________________________________/ Connectors \__________________________________________
  Basics.Interfaces.FuelFlueGas_inlet inlet(final fuelType=fuelType, final flueGas(Medium=medium)) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  ClaRa.Basics.Interfaces.Slag_outlet
                                    slag_outlet(final slagType=slagType)
     annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

  ClaRa.Basics.Interfaces.GasPortOut
                                   flueGas_outlet(final Medium = medium)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

//________________________/ Fluegas Media Objects \_____________________________________________
protected
  TILMedia.Gas_pT     gasInlet(p=inlet.flueGas.p, T= inStream(inlet.flueGas.T_outflow), xi=
        flueGas_outlet.xi_outflow,                                                                                    gasType = medium)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  TILMedia.Gas_pT     flueGasOutlet(p=flueGas_outlet.p, T=T_flueGas_out, xi=
        flueGas_outlet.xi_outflow, gasType = medium)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

//_____________/ Calculated quantities \_________________________________

protected
ClaRa.Basics.Units.MassFraction xi_coal_in[fuelType.nc-1];
ClaRa.Basics.Units.MassFraction xi_gas_in[medium.nc-1];

//Stoichometric coefficents
//_________/Educts\__________________
protected
  Modelica.Units.SI.MolarFlowRate n_flow_C;
  Modelica.Units.SI.MolarFlowRate n_flow_H;
  Modelica.Units.SI.MolarFlowRate n_flow_O;
  Modelica.Units.SI.MolarFlowRate n_flow_N;
  Modelica.Units.SI.MolarFlowRate n_flow_S;
  Modelica.Units.SI.MolarFlowRate n_flow_Ash;
  Modelica.Units.SI.MolarFlowRate n_flow_H2O;

//_________/Products\__________________
  Modelica.Units.SI.MolarFlowRate n_flow_CO2;
  Modelica.Units.SI.MolarFlowRate n_flow_H2O_prod;
  Modelica.Units.SI.MolarFlowRate n_flow_SO2;
  Modelica.Units.SI.MolarFlowRate n_flow_N2;
  Modelica.Units.SI.MolarFlowRate n_flow_NO;

  Modelica.Units.SI.MolarMass M_CO2;
  Modelica.Units.SI.MolarMass M_H2O;
  Modelica.Units.SI.MolarMass M_SO2;
  Modelica.Units.SI.MolarMass M_N2;
  Modelica.Units.SI.MolarMass M_NO;

//Molar mass of coal
  Modelica.Units.SI.MolarMass M_coal;

public
ClaRa.Basics.Units.MassFlowRate
                            m_flow_combustible_in "Mass of the combustible, i.e. Mass of coal w/o water and ash";
ClaRa.Basics.Units.MassFlowRate
                            m_flow_oxygen_req "Required O2 flow rate for stochiometric combustion";
ClaRa.Basics.Units.MassFlowRate
                            m_flow_air_req "Required combustion air flow rate for stochiometric combustion determined in dependence of m_flow_oxygen_req and actual Xi of gasInlet";

ClaRa.Basics.Units.MassFlowRate
                            m_flow_O2_NOx "O2 mass flow rate consumption for NOx fraction";

//ClaRa.Basics.Units.MassFlowRate m_flow_O2_SOx
//    "O2 mass flow rate consumption for SOx fraction";

// ClaRa.Basics.Units.EnthalpyMassSpecific
//                                     LHV "LHV of the coal";
  Modelica.Blocks.Interfaces.RealOutput Q_flow_boiler annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput lambda "lambda of combustion given by O2in/O2req"
                                                annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=180, origin={-110,-80})));

public
  inner Summary summary(
    T_flueGas_out=T_flueGas_out,
    T_slag_bottom=T_slag_bottom,
    xi_slag=xi_slag,
    m_flow_slag_out=slag_outlet.m_flow,
    m_flow_coal_in=inlet.fuel.m_flow,
    m_flow_combustible_in=m_flow_combustible_in,
    m_flow_gas_in=inlet.flueGas.m_flow,
    m_flow_flueGas_out=flueGas_outlet.m_flow,
    LHV=inStream(inlet.fuel.LHV_outflow),
    Q_flow_boiler=Q_flow_boiler,
    m_flow_O2_req=m_flow_oxygen_req,
    m_flow_Air_req=m_flow_air_req,
    lambda=lambda,
    xi_NOx=xi_NOx,
    xi_SOx=flueGas_outlet.xi_outflow[4]*1e6,
    p_combustion_chamber=gasInlet.p);

Real sum_xi;

equation
//asserts for flow reversal

  inlet.fuel.p = slag_outlet.p;

  inlet.fuel.T_outflow = T_flueGas_out;//dummy for flow reversal
  inlet.fuel.xi_outflow = zeros(fuelType.nc-1);

  slag_outlet.T_outflow = T_slag_bottom;

  inlet.flueGas.xi_outflow = zeros(medium.nc-1); // Reversefow not allowed, dummy zeros.
  inlet.flueGas.T_outflow = T_flueGas_out;//dummy for flow reversal

  flueGas_outlet.T_outflow = T_flueGas_out;

  inlet.flueGas.p = flueGas_outlet.p;

  xi_coal_in = inStream(inlet.fuel.xi_outflow); // eleemntal composition of the coal  {C,H,O,N,S,Ash,H2O}
  xi_gas_in = inStream(inlet.flueGas.xi_outflow);

  //_________________/ Mass balance \____________________________________________________
  inlet.fuel.m_flow + slag_outlet.m_flow + inlet.flueGas.m_flow + flueGas_outlet.m_flow = 0;
  slag_outlet.m_flow = - inlet.fuel.m_flow * xi_coal_in[6]*xi_slag;

//   if calculate_LHV then
//     LHV = (33907*xi_coal_in[1] + 142324*(xi_coal_in[2]-xi_coal_in[3]/8.) + 10465*xi_coal_in[5]- 2512*((1-sum({xi_coal_in[i] for i in 1:fuelType.nc-1})) + 9*xi_coal_in[2]))*1e3;
//   else
//     LHV = LHV_fixed;
//   end if;

  //________________/ Energy balance \____________________________________________________

          -Q_flow_boiler = inlet.flueGas.m_flow*(gasInlet.h - flueGasOutlet.h)
+ slag_outlet.m_flow *slagType.cp *(inStream(inlet.fuel.T_outflow)-T_slag_bottom)
+ inlet.fuel.m_flow * (1.0 - xi_coal_in[6] * xi_slag) * inStream(inlet.fuel.cp_outflow) * (inStream(inlet.fuel.T_outflow)-T_flueGas_out)
     + inlet.fuel.m_flow * inStream(inlet.fuel.LHV_outflow);
  //________________/ Chemical reaction/flueGas composition \_______________
  // calculation of the combustible mass flow rate
  m_flow_combustible_in = inlet.fuel.m_flow * (1 - xi_coal_in[6] - (1-sum({xi_coal_in[i] for i in 1:fuelType.nc-1})));
  // calculation of the Molar flow rate of coal comming into the chamber
  n_flow_C = xi_coal_in[1]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_C;
                                                      //   coal.M_C;
  n_flow_H = xi_coal_in[2]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_H;
  n_flow_O = xi_coal_in[3]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_O;
  n_flow_N = xi_coal_in[4]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_N;
  n_flow_S = xi_coal_in[5]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_S;
  n_flow_Ash = xi_coal_in[6]*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_Ash;
  n_flow_H2O = (1.0-sum({xi_coal_in[i] for i in 1:fuelType.nc-1}))*inlet.fuel.m_flow/ClaRa.Basics.Constants.M_H2O;

  // Molar Mass of the coal
  M_coal = n_flow_C/inlet.fuel.m_flow*ClaRa.Basics.Constants.M_C
                                               + 1/2.*n_flow_H/inlet.fuel.m_flow*ClaRa.Basics.Constants.M_H
                                                                                          + n_flow_S/inlet.fuel.m_flow*ClaRa.Basics.Constants.M_S
                                                                                              + 1/2.*n_flow_O/inlet.fuel.m_flow*ClaRa.
    Basics.Constants.M_O                                                                                                    + 1/2.*n_flow_N/inlet.fuel.m_flow*ClaRa.
    Basics.Constants.M_N;
  // Molar mass of products

  M_CO2 =flueGasOutlet.M_i[3];
  M_H2O =flueGasOutlet.M_i[8];
  M_SO2 =flueGasOutlet.M_i[4];
  M_N2 =flueGasOutlet.M_i[5];
  M_NO =flueGasOutlet.M_i[7];

  // required mass flow rates for stochometric combustion
  //m_flow_oxygen_req = (n_flow_C + n_flow_H/4.0 + n_flow_S  - n_flow_O/2.)*coal.M_O*2.0;  // hier Anteil von N abzeihen, der fr berschssige NO Bildung bentigt wird

 // m_flow_oxygen_req = (n_flow_C + n_flow_H/4.0 + n_flow_S + n_flow_N/2. * (-flueGas_outlet.m_flow*xi_NOx*1e-6)/M_NO  - 0*n_flow_O/2.)*Constants.M_O2;
  m_flow_oxygen_req = (n_flow_C + n_flow_H/4.0 + n_flow_S + n_flow_NO) *ClaRa.Basics.Constants.M_O2;
  m_flow_air_req*xi_gas_in[6] = (m_flow_oxygen_req  - inlet.fuel.m_flow*xi_coal_in[3]);
  lambda = (inlet.fuel.m_flow*xi_coal_in[3] + inlet.flueGas.m_flow*xi_gas_in[6])/m_flow_oxygen_req;

 // Molar flow rates of products (valid for stochiometric combustion)
// berdenke Vorzeichenkonvention fr edukte/produkte
  n_flow_CO2 = n_flow_C;
  n_flow_H2O_prod = 1/2.*n_flow_H;
  n_flow_SO2 = n_flow_S;
  n_flow_N2 = 1/2 * (n_flow_N  - n_flow_NO);
  //assert(-flueGas_outlet.m_flow*xi_NOx*1e-6/M_NO < n_flow_N, "NOx_fraction not possible, too less N comming into chamber!");
  //n_flow_NO = n_flow_N * (-flueGas_outlet.m_flow*xi_NOx*1e-6/M_NO);
   n_flow_NO = (-flueGas_outlet.m_flow*xi_NOx*1e-6/M_NO);
//_____________________/ Component Mass Balance \__________________________________________________

// O2 consumption for NOx (NO) formation  IN MOL RECHNEN!!!!
 m_flow_O2_NOx = -(flueGas_outlet.m_flow * xi_NOx*1e-6)/M_NO*ClaRa.Basics.Constants.M_O;
// O2 consumption for SOx (NO) formation (in addition to stochiometric combustion)
 //m_flow_O2_SOx = -(flueGas_outlet.m_flow * xi_SOx*1e-6)/M_SO2*coal.M_O;

 //assert(inlet.flueGas.m_flow *xi_gas_in[6] + xi_coal_in[3]*inlet.fuel.m_flow >  m_flow_O2_NOx + m_flow_oxygen_req,  "Too little combustion air, running below lambda = 1");
 //assert(n_flow_SO2*M_SO2 < ( -flueGas_outlet.m_flow * xi_SOx*1e-6), "Given xi_SOx too low, even for a stochiometeric combustion");

  // Note: Just O2 Komponent of  Gas_inlet is part of combustion!!!
  //_____________/ Flue Gas Composition \___________________
  flueGas_outlet.xi_outflow[1]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[1] + (1.0 - xi_slag)*inlet.fuel.m_flow*xi_coal_in[6]);                                                                         //Ash
  flueGas_outlet.xi_outflow[2]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[2]);                                                                             //CO
  flueGas_outlet.xi_outflow[3]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[3] + n_flow_CO2*M_CO2);                                                                             //CO2
  flueGas_outlet.xi_outflow[4]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[4] + n_flow_SO2*M_SO2);                                                                              //SO2
  flueGas_outlet.xi_outflow[5]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[5] + n_flow_N2*M_N2);                                                                               //N2
  flueGas_outlet.xi_outflow[6]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[6] + inlet.fuel.m_flow*xi_coal_in[3] - m_flow_oxygen_req);
                                                                                           /*n_flow_O*Constants.M_O*/
                                                                                                      //O2
  flueGas_outlet.xi_outflow[7]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[7] + n_flow_NO*M_NO);                                                                               //NO
  flueGas_outlet.xi_outflow[8]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[8] + (1.0 - sum({xi_coal_in[i] for i in 1:fuelType.nc - 1}))*
    inlet.fuel.m_flow + (n_flow_H2O_prod)*M_H2O);                                                                                                    //H20
  flueGas_outlet.xi_outflow[9]*flueGas_outlet.m_flow = -(inlet.flueGas.m_flow*
    xi_gas_in[9]);
    sum_xi =sum({flueGas_outlet.xi_outflow[i] for i in 1:medium.nc - 1});
inlet.fuel.cp_outflow = inStream(inlet.fuel.cp_outflow);
  inlet.fuel.LHV_outflow =inStream(inlet.fuel.LHV_outflow)
  annotation (Diagram(graphics));
end SimpleCombustionChamber;
