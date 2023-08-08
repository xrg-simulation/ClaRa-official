within ClaRa.Components.VolumesValvesFittings.Fittings;
model FlueGasJunction_L2 "Adiabatic junction volume"
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

extends ClaRa.Basics.Icons.Tpipe2;
extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  outer ClaRa.SimCenter simCenter;

 model Gas
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Mass m "Mass flow rate"
                                               annotation(Dialog);
  input ClaRa.Basics.Units.Temperature T "Temperature"
                                                   annotation(Dialog);
  input ClaRa.Basics.Units.Pressure p "Pressure"
                                             annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy"
                                                                  annotation(Dialog);
  input ClaRa.Basics.Units.Enthalpy H "Specific enthalpy"
                                                      annotation(Dialog);
  input ClaRa.Basics.Units.DensityMassSpecific rho "Specific enthalpy"
                                                                   annotation(Dialog);
 end Gas;

 inner model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Gas gas;
   ClaRa.Basics.Records.FlangeGas portA;
   ClaRa.Basics.Records.FlangeGas portB;
   ClaRa.Basics.Records.FlangeGas portC;
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

  Basics.Interfaces.GasPortIn      portA(Medium = medium, m_flow)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.GasPortIn      portB(Medium=medium, m_flow)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Basics.Interfaces.GasPortIn      portC(Medium=medium, m_flow)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

parameter ClaRa.Basics.Units.Volume volume;

  TILMedia.Gas_pT     flueGasPortA(gasType = medium, p=p, T=noEvent(actualStream(portA.T_outflow)), xi=noEvent(actualStream(portA.xi_outflow)))
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  TILMedia.Gas_pT flueGasPortB(
    gasType=medium,
    p=portB.p,
    T=noEvent(actualStream(portB.T_outflow)),
    xi=noEvent(actualStream(portB.xi_outflow)))
    annotation (Placement(transformation(extent={{60,-14},{80,6}})));
  TILMedia.Gas_pT flueGasPortC(
    gasType=medium,
    p=portC.p,
    T=noEvent(actualStream(portC.T_outflow)),
    xi=noEvent(actualStream(portC.xi_outflow)))
    annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));
  inner TILMedia.Gas_ph     bulk(
    computeTransportProperties=false,
    gasType = medium,p=p,h=h,xi=xi,
    stateSelectPreferForInputs=true)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  /****************** Initial values *******************/

public
  parameter ClaRa.Basics.Units.Pressure p_start=1.013e5 "Initial value for air pressure"
    annotation(Dialog(group="Initial Values"));
//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Temperature T_start=298.15 "Initial value for air temperature"
    annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.MassFraction[medium.nc - 1]
                                                         mixingRatio_initial=zeros(medium.nc-1) "Initial value for mixing ratio"
                                     annotation(Dialog(group="Initial Values"));

  final parameter Modelica.SIunits.SpecificEnthalpy h_start = TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, mixingRatio_initial) "Start value for specific Enthalpy inside volume";

  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=mixingRatio_initial);
  Modelica.SIunits.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start) "Pressure";

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";

  Real drhodt "Density derivative";

  inner Summary    summary(portA(mediumModel=medium, m_flow=portA.m_flow,  T=flueGasPortA.T, p=portA.p, h=flueGasPortA.h, xi=flueGasPortA.xi, H_flow=portA.m_flow*flueGasPortA.h),
                           portB(mediumModel=medium, m_flow=portB.m_flow,  T=flueGasPortB.T, p=portB.p, h=flueGasPortB.h, xi=flueGasPortB.xi, H_flow=portB.m_flow*flueGasPortB.h),
                           portC(mediumModel=medium, m_flow=portC.m_flow,  T=flueGasPortC.T, p=portC.p, h=flueGasPortC.h, xi=flueGasPortC.xi, H_flow=portC.m_flow*flueGasPortC.h),
                   gas(m=mass, T=bulk.T, p=p, h=h, H=h*mass, rho=bulk.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

public
  Basics.Interfaces.EyeOutGas
                           eye1(each medium=medium) if
                                  showData
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50})));
protected
  Basics.Interfaces.EyeInGas
                          eye_int[2](each medium=medium)
    annotation (Placement(transformation(extent={{55,-51},{57,-49}})));
public
  Basics.Interfaces.EyeOutGas
                           eye2(each medium=medium) if
                                  showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
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

  portA.xi_outflow = xi;
  portB.xi_outflow = xi;
  portC.xi_outflow = xi;

  portA.T_outflow = bulk.T;
  portB.T_outflow = bulk.T;
  portC.T_outflow = bulk.T;

  portA.p = p; // Volume is located at PortA

  der(h) = 1/mass*(portA.m_flow*(flueGasPortA.h - h) +
      portB.m_flow*(flueGasPortB.h - h) +  portC.m_flow*(flueGasPortC.h - h)
      + volume*der(p)) "Energy balance";

  der(xi) = 1/mass*(portA.m_flow*(flueGasPortA.xi-xi) +
      portB.m_flow*(flueGasPortB.xi-xi) + portC.m_flow*(flueGasPortC.xi-xi)) "Mass balance";

      //______________ Balance euqations _______________________

    mass = volume*bulk.d "Mass in cv";

    drhodt = bulk.drhodh_pxi*der(h) + bulk.drhodp_hxi*der(p) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:medium.nc-1});

    drhodt*volume = portA.m_flow + portB.m_flow + portC.m_flow "Mass balance";

    portA.p - portB.p = 0 "Momentum balance";
    portA.p - portC.p = 0 "Momentum balance";

   eye_int[1].T= flueGasPortB.T-273.15;
    eye_int[1].s=flueGasPortB.s/1e3;
    eye_int[1].p=flueGasPortB.p/1e5;
    eye_int[1].h=flueGasPortB.h/1e3;
    eye_int[2].T= flueGasPortC.T-273.15;
    eye_int[2].s=flueGasPortC.s/1e3;
    eye_int[2].p=flueGasPortC.p/1e5;
    eye_int[2].h=flueGasPortC.h/1e3;
    eye_int[1].m_flow=-portB.m_flow;
    eye_int[2].m_flow=-portC.m_flow;
    eye_int[1].xi=flueGasPortB.xi;
    eye_int[2].xi=flueGasPortC.xi;

  connect(eye_int[1],eye1)  annotation (Line(
      points={{56,-50.5},{84,-50.5},{84,-50},{110,-50}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int[2],eye2)  annotation (Line(
      points={{56,-49.5},{56,-90},{30,-90},{30,-110}},
      color={190,190,190},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}, preserveAspectRatio=true),
        graphics));
end FlueGasJunction_L2;
