within ClaRa.Components.VolumesValvesFittings.Fittings;
model JoinGas_L2_flex "Adiabatic junction volume"
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

extends ClaRa.Basics.Icons.Adapter5_bw;
extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  outer ClaRa.SimCenter simCenter;

 model Gas
  extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass m "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.Enthalpy H "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.DensityMassSpecific rho "Specific enthalpy" annotation (Dialog);
 end Gas;

 inner model Summary
   parameter Integer N_ports_in;
   extends ClaRa.Basics.Icons.RecordIcon;
   Gas gas;
   ClaRa.Basics.Records.FlangeGas inlet[N_ports_in];
   ClaRa.Basics.Records.FlangeGas outlet;
 end Summary;

inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

// ***************************** defintion of medium used in cell *************************************************
inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  ClaRa.Basics.Interfaces.GasPortIn inlet[N_ports_in](each Medium=medium, m_flow)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortIn outlet(Medium=medium, m_flow)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
 parameter Integer  N_ports_in(min=1)=1 "Number of inlet  ports"
    annotation(Evaluate=true, Dialog(tab="General",group="Fundamental Definitions"));//connectorSizing=true,

  parameter ClaRa.Basics.Units.Volume volume=1 annotation (Dialog(tab="General", group="Geometry"));
parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

protected
  TILMedia.Gas_pT     gasInlet[N_ports_in](each gasType = medium, p=inlet.p, T=noEvent(actualStream(inlet.T_outflow)), xi=noEvent(actualStream(inlet.xi_outflow)))
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
protected
  TILMedia.Gas_pT gasOutlet(
    gasType=medium,
    p=outlet.p,
    T=noEvent(actualStream(outlet.T_outflow)),
    xi=noEvent(actualStream(outlet.xi_outflow)))
    annotation (Placement(transformation(extent={{60,-14},{80,6}})));
protected
  inner TILMedia.Gas_ph     bulk(
    computeTransportProperties=false,
    gasType = medium,p=p,h=h,xi=xi,
    stateSelectPreferForInputs=true)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  /****************** Nominal values *******************/
public
  parameter Modelica.SIunits.MassFlowRate m_flow_in_nom[N_ports_in]= fill(10,N_ports_in) "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  parameter Modelica.SIunits.Temperature T_nom=293.15 "Nominal specific enthalpy"              annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc - 1]=medium.xi_default annotation (Dialog(group="Nominal Values"));

  final parameter Modelica.SIunits.Density rho_nom= TILMedia.GasFunctions.density_pTxi(medium, p_nom, T_nom, xi_nom) "Nominal density";
  /****************** Initial values *******************/
public
    parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start=1.013e5 "Initial value for air pressure" annotation (Dialog(tab="Initialisation"));
//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Temperature T_start=298.15 "Initial value for air temperature" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction[medium.nc - 1] xi_start=medium.xi_default "Initial value for mixing ratio" annotation(Dialog(tab="Initialisation"));

  final parameter Modelica.SIunits.SpecificEnthalpy h_start = TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, xi_start) "Start value for specific Enthalpy inside volume";

  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start);
  Modelica.SIunits.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start) "Pressure";

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";

  Real drhodt "Density derivative";


public
  inner Summary    summary(N_ports_in=N_ports_in,inlet(each mediumModel=medium, m_flow=inlet.m_flow,  T=gasInlet.T, p=inlet.p, h=gasInlet.h, xi=gasInlet.xi, each H_flow=inlet.m_flow*gasInlet.h),
                           outlet(mediumModel=medium, m_flow=outlet.m_flow,  T=gasOutlet.T, p=outlet.p, h=gasOutlet.h, xi=gasOutlet.xi, H_flow=outlet.m_flow*gasOutlet.h),
                   gas(m=mass, T=bulk.T, p=p, h=h, H=h*mass, rho=bulk.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

public
  Basics.Interfaces.EyeOutGas    eye(each medium=medium) if showData      annotation(Placement(transformation(extent={{100,-90},{120,-70}})));
protected
  Basics.Interfaces.EyeInGas    eye_int[1](each medium=medium)
    annotation (Placement(transformation(extent={{55,-81},{57,-79}})));
initial equation

    if initOption == 1 then //steady state
      der(h)=0;
      der(p)=0;
      der(xi)=zeros(medium.nc-1);
    elseif initOption == 201 then //steady pressure
      der(p)=0;
    elseif initOption == 202 then //steady enthalpy
      der(h)=0;
    elseif initOption == 208 then // steady pressure and enthalpy
      der(h)=0;
      der(p)=0;
    elseif initOption == 210 then //steady density
      drhodt=0;
    elseif initOption == 0 then //no init
    // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

equation

  //inlet.xi_outflow = xi;
  outlet.xi_outflow = xi;

  //inlet.T_outflow = bulk.T;
  outlet.T_outflow = bulk.T;

  //inlet.p = p; // Volume is located at PortA

  for i in 1:N_ports_in loop
   inlet[i].p = p;
   inlet[i].T_outflow = bulk.T;
   inlet[i].xi_outflow = xi;
  end for;

 //  der(h) = 1/mass*(sum(inlet.m_flow .*(gasInlet.h - h*ones(N_ports_in))) + outlet.m_flow*(gasOutlet.h - h) + volume*der(p)) "Energy balance";
  der(h) =if useHomotopy then homotopy(1/mass*(sum(inlet.m_flow .*(gasInlet.h - h*ones(N_ports_in))) + outlet.m_flow*(gasOutlet.h - h) + volume*der(p)),  1/mass*(sum(m_flow_in_nom .*(gasInlet.h - h*ones(N_ports_in))) + m_flow_in_nom[1]*(gasOutlet.h - h) + volume*der(p))) else 1/mass*(sum(inlet.m_flow .*(gasInlet.h - h*ones(N_ports_in))) + outlet.m_flow*(gasOutlet.h - h) + volume*der(p)) "Energy balance";

  for i in 1:medium.nc - 1 loop
   // der(xi[i]) = 1/mass.*(sum(inlet.m_flow.*(gasInlet.xi[i]-xi[i]*ones(N_ports_in))) + outlet.m_flow.*(gasOutlet.xi[i]-xi[i])) "Mass balance";
   der(xi[i]) = if useHomotopy then homotopy(1/mass.*(sum(inlet.m_flow.*(gasInlet[:].xi[i]-xi[i]*ones(N_ports_in))) + outlet.m_flow.*(gasOutlet.xi[i]-xi[i])), 1/mass.*(sum(m_flow_in_nom.*(xi_nom[i]*ones(N_ports_in)-xi[i]*ones(N_ports_in))) +  m_flow_in_nom[1].*(xi_nom[i]-xi[i]))) else 1/mass.*(sum(inlet.m_flow.*(gasInlet[:].xi[i]-xi[i]*ones(N_ports_in))) + outlet.m_flow.*(gasOutlet.xi[i]-xi[i])) "Mass balance";
  end for;

      //______________ Balance euqations _______________________

    mass = if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d "Mass in control volume";

    drhodt = bulk.drhodh_pxi*der(h) + bulk.drhodp_hxi*der(p) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:medium.nc-1});

    drhodt*volume = sum(inlet.m_flow) + outlet.m_flow "Mass balance";

    outlet.p = p "Momentum balance";

  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = gasOutlet.T-273.15;
  eye_int[1].s = gasOutlet.s/1e3;
  eye_int[1].p = gasOutlet.p/1e5;
  eye_int[1].h = gasOutlet.h/1e3;
  eye_int[1].xi=gasOutlet.xi;
  connect(eye,eye_int[1])  annotation (Line(
      points={{110,-80},{56,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}, preserveAspectRatio=true),
        graphics));
end JoinGas_L2_flex;
