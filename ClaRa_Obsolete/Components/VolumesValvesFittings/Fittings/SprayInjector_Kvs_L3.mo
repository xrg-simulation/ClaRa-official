within ClaRa_Obsolete.Components.VolumesValvesFittings.Fittings;
model SprayInjector_Kvs_L3 "A spray injector for i.e. temperature control"
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
  extends ClaRa.Basics.Icons.SprayInjector;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=
                                                      simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                               annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Real CL_valve[:,:]=[0,0; 1,1] "Effective apperture as function of valve position in p.u."
                                                                annotation(Dialog(group="Valve Characteristic"));
  parameter Real Kvs=1 "Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))"
                                                                                            annotation(Dialog(group="Valve Characteristic"));

parameter Integer N_wall=3 "Number of radial elements of the wall" annotation(Dialog(group="Fundamental Definitions"));

  parameter Modelica.SIunits.Length diameter_o=0.5 "Diameter of the component" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i=0.45 "Diameter of the component" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length length=3 "Length of the component"  annotation(Dialog(group="Geometry"));
  parameter Integer N=1 "Number of identical injectors in parallel"  annotation(Dialog(group="Geometry"));

  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure" annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nom_Main=3000e3 "Nominal specific enthalpy"
                                 annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nom_Spray=1000e3 "Nominal specific enthalpy"
                                 annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_main=300 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nom=1000 "Nominal pressure loss"  annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_spray=10 "Nominal injection mass flow rate"
                                        annotation(Dialog(group="Nominal Values"));

  parameter Modelica.SIunits.SpecificEnthalpy h_start_Main=3000e3 "Initial specific enthalpy at main inlet"
                                               annotation(Dialog(group="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy h_start_Spray=1000e3 "Initial specific enthalpy at main inlet"
                                               annotation(Dialog(group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_start=1e5 "Start value of sytsem pressure"
                                     annotation(Dialog(group="Initialisation"));

  parameter Integer initOption=0 "Type of initialisation at tube side"
    annotation (Dialog( group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                             annotation(Dialog(group="Initialisation"));
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";

  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean preciseTwoPhase = true "|Expert Stettings||True, if two-phase transients should be calculated precisely";
protected
  parameter Modelica.SIunits.SpecificEnthalpy h_nom_mix=(h_nom_Main*m_flow_nom_main+h_nom_Spray*m_flow_nom_spray)/(m_flow_nom_main+m_flow_nom_spray) "Nominal mix enthalpy";
  parameter Modelica.SIunits.SpecificEnthalpy h_start_mix=(h_start_Main*m_flow_nom_main+h_start_Spray*m_flow_nom_spray)/(m_flow_nom_main+m_flow_nom_spray) "Nominal mix enthalpy";
  parameter Modelica.SIunits.Temperature T_wall_start[N_wall]= ones(N_wall)*TILMedia.VLEFluidFunctions.temperature_phxi(medium, p_start-Delta_p_nom, h_start_mix) "Start values of wall temperature"
                                       annotation(Dialog(group="Initialisation"));
  extends Basics.Icons.Obsolete_v1_1;
public
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 outflowZone(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=diameter_i,
        length=length/2,
        Nt=N),
    medium=medium,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom_main + m_flow_nom_spray,
    h_nom=h_nom_mix,
    h_start=h_start_mix,
    p_nom=p_nom - Delta_p_nom,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=Delta_p_nom),
    p_start=p_start,
    showExpertSummary=showExpertSummary,
    initOption=initOption) annotation (Placement(transformation(extent={{34,10},{54,30}})));

  ClaRa.Basics.Interfaces.FluidPortIn MainInlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,10},{-90,30}})));
  ClaRa.Basics.Interfaces.FluidPortIn SprayInlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}}),
        iconTransformation(extent={{-30,-110},{-10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet1(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,10},{110,30}}),
        iconTransformation(extent={{90,10},{110,30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    redeclare replaceable model Material = Material,
    sizefunc=+1,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=length,
    N_tubes=N,
    initChoice=ClaRa.Basics.Choices.Init.steadyState,
    T_start=T_wall_start,
    N_rad=N_wall) annotation (Placement(transformation(extent={{38,42},{58,62}})));

  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1   valve(
    medium=medium,
    openingInputIsActive=true,
    showExpertSummary=showExpertSummary,
    showData=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
         CL_valve =     CL_valve, Kvs=Kvs),
    useStabilisedMassFlow=true,
    Tau=0.001)                        annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-20,-46})));

  Modelica.Blocks.Interfaces.RealInput opening "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-100})));
  ClaRa.Basics.Interfaces.EyeOut eye if showData      annotation(Placement(transformation(extent={{90,-30},
            {110,-10}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int
    annotation (Placement(transformation(extent={{45,-21},{47,-19}})));
public
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y mixingZone(
    volume=Modelica.Constants.pi/4*diameter_i^2*length/2*N,
    medium=medium,
    m_flow_in_nom={m_flow_nom_main,m_flow_nom_spray},
    p_nom=p_nom,
    h_nom=h_nom_mix,
    h_start=h_start_mix,
    p_start=p_start,
    useHomotopy=useHomotopy,
    preciseTwoPhase=preciseTwoPhase,
    showExpertSummary=showExpertSummary,
    showData=false,
    initOption=initOption) annotation (Placement(transformation(extent={{-30,30},{-10,10}})));

equation
//-------------------------------------------
//Summary:
    eye_int.m_flow=-outflowZone.outlet.m_flow;
    eye_int.T= outflowZone.summary.outlet.T-273.15;
    eye_int.s=outflowZone.fluidOut.s/1e3;
    eye_int.p=outflowZone.outlet.p/1e5;
    eye_int.h=actualStream(outflowZone.outlet.h_outflow)/1e3;

  connect(wall.innerPhase, outflowZone.heat)                  annotation (Line(
      points={{47.8,42.4},{47.8,30},{44,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outflowZone.outlet, outlet1)                  annotation (Line(
      points={{54,20},{100,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve.inlet, SprayInlet)     annotation (Line(
      points={{-20,-56},{-20,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve.opening_in, opening)     annotation (Line(
      points={{-29,-46},{-40,-46},{-40,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eye,eye_int)  annotation (Line(
      points={{100,-20},{46,-20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.outlet, outflowZone.inlet) annotation (Line(
      points={{-10,20},{34,20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.inlet1, MainInlet) annotation (Line(
      points={{-30,20},{-64,20},{-64,20},{-100,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.inlet2, valve.outlet) annotation (Line(
      points={{-20,10},{-20,-36}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                   graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
                  extent={{-100,-100},{100,100}}),
                                         graphics));
end SprayInjector_Kvs_L3;
