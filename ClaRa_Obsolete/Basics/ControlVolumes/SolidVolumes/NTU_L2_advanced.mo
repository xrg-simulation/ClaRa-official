within ClaRa_Obsolete.Basics.ControlVolumes.SolidVolumes;
model NTU_L2_advanced "NTU-based heat transfer resistance"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import SI = ClaRa.Basics.Units;

  outer ClaRa.SimCenter simCenter;
  extends ClaRa.Basics.Icons.NTU;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  extends Icons.Obsolete_v1_1;
//_____________fundamental definitions_________________________________________//

 replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
                                                                    constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                                "Material of the cylinder"
                               annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Type of HeatExchanger"
                                                                                       annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

//______________geometry definitions________________________________________//
  parameter Integer N_t=1 "Number of tubes in one pass" annotation(Dialog(group="Geometry"));
  parameter Integer N_p=1 "Number of passes" annotation(Dialog(group="Geometry"));
  parameter SI.Length length "Tube length (for one pass)" annotation (Dialog(group="Geometry"));
  parameter SI.Length radius_i "Inner radius of tube" annotation (Dialog(group="Geometry"));
  parameter SI.Length radius_o "Outer radius of tube" annotation (Dialog(group="Geometry"));
  parameter SI.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(group="Geometry"));
  discrete SI.Mass mass "Total mass of HEX";

  parameter Real CF_geo=1 "Correction coefficient due to fins etc." annotation(Dialog(group="Geometry"));

//Area of Heat Transfer
  final parameter SI.Area A_heat_m=(A_heat_o - A_heat_i)/log(A_heat_o/A_heat_i) "Mean area of heat transfer (single tube)";
  final parameter SI.Area A_heat_i=2*Modelica.Constants.pi*radius_i*length*N_t*N_p "Area of heat transfer at inner phase";
  final parameter SI.Area A_heat_o=2*Modelica.Constants.pi*radius_o*length*N_t*N_p "Area of heat transfer at oter phase";

//______________Initialisation______________________________________________//
  parameter SI.Temperature T_w_i_start=293.15 "Initial temperature at inner phase" annotation (Dialog(tab="Initialisation"));
  parameter SI.Temperature T_w_a_start=293.15 "Initial temperature at outer phase" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Choices.Init initChoice=ClaRa.Basics.Choices.Init.noInit "Initialisation option"                   annotation(Dialog(tab="Initialisation"));
//______________Visualisation______________________________________________//
 parameter Boolean showExpertSummary = false "|Summary and Visualisation||True, if expert summary should be applied";

//______________Inputs_____________________________________________________//
  input SI.Temperature T_i_in "Inlet temperature of inner flow" annotation (Dialog(group="Input"));
  input SI.Temperature T_a_in "Inlet temperature of outer flow" annotation (Dialog(group="Input"));

  input SI.MassFlowRate m_flow_i "Mass flow rate of inner side" annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_a "Mass flow rate of outer side" annotation (Dialog(group="Input"));

  input SI.CoefficientOfHeatTransfer alpha_i "Coefficient of heatTransfer for inner side" annotation (Dialog(group="Input"));
  input SI.CoefficientOfHeatTransfer alpha_o "Coefficient of heatTransfer for outer side" annotation (Dialog(group="Input"));

  input SI.HeatCapacityMassSpecific cp_mean_i "Mean cp of inner flow" annotation (Dialog(group="Input"));
  input SI.HeatCapacityMassSpecific cp_mean_a "Mean cp of outer flow" annotation (Dialog(group="Input"));

//______________Variables__________________________________________________//
  SI.Temperature T_i_out "Outlet temperature of steady state inner flow";
  SI.Temperature T_a_out "Outlet temperature of steady state outer flow";
  SI.HeatFlowRate Q_flow_NTU_1 "Steady state heat flow rate outer to inner phase";
  Real kA(unit="W/K") "The product U*S";
  Real effectiveness "Heat exchanger efficiency";

//  parameter Units.HeatFlowRate Q_flow_nom=1e7;

protected
  SI.Temperature T_w_i(start=T_w_i_start) "Wall temperature at inner phase";
  SI.Temperature T_w_a(start=T_w_a_start) "Wall temperature at outer phase";

  Real R_1 "Aspect ratio of heat capacity rates W1/W2<1";
//  Real R_2 "Aspect ratio of heat capacity flow rates W2/W1";

  Real NTU_1 "Number of Transfer Units related to the flow 1";
  Real NTU_2 "Number of Transfer Units related to flow 2";

  Real C_flow_1(unit="W/K") "Smaller heat capacity rate";
  Real C_flow_2(unit="W/K") "Larger heat capacity rate";

//   Real Q_flow_in_nom;
//   Real Q_flow_out_nom;
//   Real Q_flow_NTU_1_nom;
Real k=(0.5*mass*solid.cp)/100;
public
record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Boolean showExpertSummary;
  Real NTU_1 if showExpertSummary "Number of Transfer Units related to the flow 1";
  Real NTU_2 if showExpertSummary "Number of Transfer Units related to flow 2";

  Real C_flow_low(unit="W/K") if showExpertSummary "Smaller heat capacity rate";
  Real C_flow_high(unit="W/K") if showExpertSummary "Larger heat capacity rate";

  SI.Area A_mean "Mean area of heat transfer (single tube)";
  SI.Temperature T_i_out "Outlet temperature of steady state inner flow";
  SI.Temperature T_o_out "Outlet temperature of steady state outer flow";
  Real kA(unit="W/K") "The product of thermal transmission and heat transfer area";
  Real effectiveness "Heat exchanger efficiency";
  SI.HeatFlowRate Q_flow "Steady state heat flow rate outer to inner phase";
  SI.HeatCapacityMassSpecific cp_mean_i "Mean cp of inner flow";
  SI.HeatCapacityMassSpecific cp_mean_a "Mean cp of outer flow";
  SI.DensityMassSpecific d "Material density";
end Summary;

public
  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase "outer side of cylinder"
                                         annotation (Placement(transformation(
          extent={{-10,80},{10,100}}, rotation=0)));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   innerPhase "inner side of cylinder"
                                         annotation (Placement(transformation(
          extent={{-10,-100},{10,-80}},
                                      rotation=0)));
  TILMedia.Solid.Solid solid(redeclare replaceable model SolidType = Material, T=(T_w_i + T_w_a)/2)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  HeatExchangerType heatExchangerType(NTU_1=NTU_1, R_1=R_1) annotation (Placement(transformation(extent={{20,20},{40,40}},   rotation=0)));
  Summary summary(showExpertSummary=showExpertSummary,C_flow_low=C_flow_1,C_flow_high=C_flow_2,NTU_1=NTU_1,NTU_2=NTU_2,A_mean=A_heat_m,T_i_out=T_i_out,T_o_out=T_a_out,kA=kA,effectiveness=effectiveness,Q_flow=Q_flow_NTU_1, cp_mean_i=cp_mean_i,cp_mean_a=cp_mean_a, d=solid.d)
annotation(Placement(transformation(extent={{-100,-102},{-80,-82}})));

initial equation
   if initChoice == ClaRa.Basics.Choices.Init.steadyState then
      der(T_w_i)=0;
      der(T_w_a)=0;

   end if;
innerPhase.T = T_w_i;
outerPhase.T = T_w_a;
//  innerPhase.T = T_w_i *Q_flow_nom/(0.5*mass*solid.cp);
//  outerPhase.T = T_w_a *Q_flow_nom/(0.5*mass*solid.cp);
equation
when initial() then
  mass = mass_struc + solid.d*N_t*N_p*length*Modelica.Constants.pi*(radius_o^2-radius_i^2);
end when;
  //variables of the NTU method:
  C_flow_1=noEvent(min(cp_mean_i*abs(m_flow_i), cp_mean_a*abs(m_flow_a)));
  C_flow_2=noEvent(max(cp_mean_i*abs(m_flow_i), cp_mean_a*abs(m_flow_a)));

  R_1=(C_flow_1+1e-3)/(C_flow_2+1e-3);
//  R_2=C_flow_2/C_flow_1;

//Heat transfer coefficient
  kA = 2*Modelica.Constants.pi*length*N_p*N_t/(1/(alpha_i*radius_i) + log(radius_o/radius_i)/solid.lambda + 1/(CF_geo * alpha_o*radius_o));

//Wall temperatures:
//   innerPhase.T = T_w_i *Q_flow_nom/(0.5 * mass*solid.cp);
//   outerPhase.T = T_w_a *Q_flow_nom/(0.5 * mass*solid.cp);

   //innerPhase.T = T_w_i ;
   innerPhase.Q_flow=k*(innerPhase.T-T_w_i);

  //outerPhase.T = T_w_a ;
outerPhase.Q_flow=k*(outerPhase.T-T_w_a);

//Number of Transfer Units:
  NTU_1 = kA/(C_flow_1+1e-3)*heatExchangerType.CF_NTU;
  NTU_2 = kA/(C_flow_2+1e-3)*heatExchangerType.CF_NTU;

  effectiveness = (1 - exp(-NTU_1*(1-R_1)))/(1 - R_1*exp(-NTU_1*(1-R_1))); //for CounterFlow

//heat flow from flow 1 to flow 2:
  T_i_out = noEvent(if cp_mean_i*abs(m_flow_i) < cp_mean_a*abs(m_flow_a) then T_i_in-effectiveness*(T_i_in - T_a_in) else T_i_in + Q_flow_NTU_1/(C_flow_2+1e-3));
  T_a_out = noEvent(if cp_mean_i*abs(m_flow_i) > cp_mean_a*abs(m_flow_a) then T_a_in+effectiveness*(T_i_in - T_a_in) else T_a_in - Q_flow_NTU_1/(C_flow_2+1e-3));

//Heat flow rate using the effectiveness of the heat exchanger
   Q_flow_NTU_1=effectiveness*C_flow_1*(T_a_in-T_i_in);
//Energy Balance:
      der(T_w_i)=(innerPhase.Q_flow+Q_flow_NTU_1)/(0.5 * mass*solid.cp);
      der(T_w_a)=(outerPhase.Q_flow-Q_flow_NTU_1)/(0.5 * mass*solid.cp);

// Q_flow_in_nom=innerPhase.Q_flow/Q_flow_nom;
// Q_flow_out_nom=outerPhase.Q_flow/Q_flow_nom;
// Q_flow_NTU_1_nom=Q_flow_NTU_1/Q_flow_nom;
//
//     der(T_w_i)=(Q_flow_in_nom+Q_flow_NTU_1_nom);
//     der(T_w_a)=(Q_flow_out_nom-Q_flow_NTU_1_nom);

//(Q_flow_in_nom+Q_flow_NTU_1_nom)=innerPhase.T/Q_flow_nom/(0.5 * mass*solid.cp);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end NTU_L2_advanced;
