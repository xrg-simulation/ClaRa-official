within ClaRa.Components.VolumesValvesFittings.Fittings;
model JoinVLE_L2_Y "A join for two inputs"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
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

  extends ClaRa.Basics.Icons.Tpipe;

  import SI = ClaRa.Basics.Units;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  outer ClaRa.SimCenter simCenter;

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Volume volume_tot "Total volume";
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet1;
  ClaRa.Basics.Records.FlangeVLE           inlet2;
  ClaRa.Basics.Records.FlangeVLE           outlet;
  ClaRa.Basics.Records.FluidVLE_L2           fluid;
end Summary;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                               annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
replaceable model PressureLossIn1 =
    Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at inlet 1" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossIn2 =
      Fundamentals.NoFriction  constrainedby Fundamentals.BaseDp "Pressure loss model at inlet 2" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossOut =
      Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at outlet" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
   parameter SI.Volume volume(min=1e-6)=0.1 "System Volume"                               annotation(Dialog(tab="General", group="Geometry"));
  parameter SI.MassFlowRate m_flow_in_nom[2]= {10, 10} "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));
  parameter SI.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  parameter SI.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"                          annotation(Dialog(group="Nominal Values"));

  parameter SI.EnthalpyMassSpecific h_start= 1e5 "Start value of sytsem specific enthalpy"
                                             annotation(Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start= 1e5 "Start value of sytsem pressure"               annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc-1] = medium.xi_default "Start value for mass fraction" annotation(Dialog(tab="Initialisation"));

  parameter Integer initOption=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
    parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean preciseTwoPhase = true "|Expert Stettings||True, if two-phase transients should be capured precisely";
protected
    parameter SI.DensityMassSpecific rho_nom= TILMedia.VLEFluidFunctions.density_phxi(medium, p_nom, h_nom) "Nominal density";
    SI.Power Hdrhodt =  if preciseTwoPhase then h*volume*drhodt else 0 "h*volume*drhodt";
    Real Xidrhodt[medium.nc-1]= if preciseTwoPhase then xi*volume*drhodt else zeros(medium.nc-1) "h*volume*drhodt";

public
  SI.EnthalpyFlowRate H_flow_in[2];
  SI.EnthalpyFlowRate H_flow_out;
  SI.EnthalpyMassSpecific h(start=h_start);
  SI.Mass mass "Total system mass";
  Real drhodt;//(unit="kg/(m3s)");
  SI.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_in[2,medium.nc-1] "Mass fraction flows at inlet";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_out[medium.nc-1] "Mass fraction flows at outlet";
  ClaRa.Basics.Units.MassFraction xi[medium.nc-1](start=xi_start) "Mass fraction";

   Summary summary(outline(volume_tot = volume),
                   inlet1(showExpertSummary = showExpertSummary,m_flow=inlet1.m_flow,  T=fluidIn1.T, p=inlet1.p, h=fluidIn1.h,s=fluidIn1.s, steamQuality=fluidIn1.q, H_flow=fluidIn1.h*inlet1.m_flow, rho=fluidIn1.d),
                   inlet2(showExpertSummary = showExpertSummary,m_flow=inlet2.m_flow,  T=fluidIn2.T, p=inlet2.p, h=fluidIn2.h,s=fluidIn2.s, steamQuality=fluidIn2.q, H_flow=fluidIn2.h*inlet2.m_flow, rho=fluidIn2.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                   outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h*outlet.m_flow, rho=fluidOut.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
PressureLossIn1 pressureLossIn1;
PressureLossIn2 pressureLossIn2;
PressureLossOut pressureLossOut;
public
  ClaRa.Basics.Interfaces.FluidPortIn inlet1(each Medium=medium) "First inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
TILMedia.VLEFluid_ph bulk(each vleFluidType = medium, p = outlet.p, h=h) annotation (Placement(transformation(extent={{-10,-12},
            {10,8}},                                                                                                    rotation=0)));

public
  ClaRa.Basics.Interfaces.EyeOut eye if showData      annotation(Placement(transformation(extent={{90,-90},
            {110,-70}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{45,-81},{47,-79}})));
public
  ClaRa.Basics.Interfaces.FluidPortIn inlet2(each Medium=medium) "First inlet port"
    annotation (Placement(transformation(extent={{-10,70},{10,90}}),
        iconTransformation(extent={{-10,90},{10,110}})));
protected
TILMedia.VLEFluid_ph fluidIn1(
    each vleFluidType=medium,
    h=noEvent(actualStream(inlet1.h_outflow)),
    p=inlet1.p)                                                          annotation (Placement(transformation(extent={{-90,-12},
            {-70,8}},                                                                                                   rotation=0)));
TILMedia.VLEFluid_ph fluidIn2(
    each vleFluidType=medium,
    h=noEvent(actualStream(inlet2.h_outflow)),
    p=inlet2.p)                                                          annotation (Placement(transformation(extent={{-10,50},
            {10,70}},                                                                                                   rotation=0)));
TILMedia.VLEFluid_ph fluidOut(
    each vleFluidType=medium,
    h=noEvent(actualStream(outlet.h_outflow)),
    p=outlet.p)                                                          annotation (Placement(transformation(extent={{70,-12},
            {90,8}},                                                                                                    rotation=0)));
equation
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(volume>0, "The system volume must be greater than zero!");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
   mass= if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d;

   drhodt*volume = inlet1.m_flow + inlet2.m_flow + outlet.m_flow "Mass balance";
   drhodt = der(p)*bulk.drhodp_hxi
          + der(h)*bulk.drhodh_pxi
          + sum(der(xi).*bulk.drhodxi_ph);
                                                   //calculating drhodt from state variables

   der(h) = 1/mass*(sum(H_flow_in) + H_flow_out  + volume*der(p) -Hdrhodt) "Energy balance, decoupled from the mass balance to avoid heavy mass fluctuations during phase change or flow reversal. The term '-h*volume*drhodt' is ommited";
   der(xi) = {(sum(Xi_flow_in[:,i])+ Xi_flow_out[i]- Xidrhodt[i])/mass for i in 1:medium.nc-1} "Species balance";

//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  pressureLossIn1.m_flow = inlet1.m_flow;
  pressureLossIn2.m_flow = inlet2.m_flow;
  pressureLossOut.m_flow = -outlet.m_flow;

  H_flow_in[1]=if useHomotopy then homotopy(actualStream(inlet1.h_outflow)*inlet1.m_flow, inStream(inlet1.h_outflow)*m_flow_in_nom[1]) else actualStream(inlet1.h_outflow)*inlet1.m_flow;
  H_flow_in[2]=if useHomotopy then homotopy(actualStream(inlet2.h_outflow)*inlet2.m_flow, inStream(inlet2.h_outflow)*m_flow_in_nom[2]) else actualStream(inlet2.h_outflow)*inlet2.m_flow;
  Xi_flow_in[1]=if useHomotopy then homotopy(actualStream(inlet1.xi_outflow)*inlet1.m_flow, inStream(inlet1.xi_outflow)*m_flow_in_nom[1]) else actualStream(inlet1.xi_outflow)*inlet1.m_flow;
  Xi_flow_in[2]=if useHomotopy then homotopy(actualStream(inlet2.xi_outflow)*inlet2.m_flow, inStream(inlet2.xi_outflow)*m_flow_in_nom[2]) else actualStream(inlet2.xi_outflow)*inlet2.m_flow;

  inlet1.p = p+pressureLossIn1.dp;
  inlet2.p = p+pressureLossIn2.dp;
  inlet1.h_outflow = h;
  inlet2.h_outflow = h;
  inlet1.xi_outflow = xi;
  inlet2.xi_outflow = xi;

  H_flow_out= if useHomotopy then homotopy(actualStream(outlet.h_outflow)*outlet.m_flow, -h*sum(m_flow_in_nom)) else actualStream(outlet.h_outflow)*outlet.m_flow;
  Xi_flow_out= if useHomotopy then homotopy(actualStream(outlet.xi_outflow)*outlet.m_flow, -xi*sum(m_flow_in_nom)) else actualStream(outlet.xi_outflow)*outlet.m_flow;
  outlet.p=p - pressureLossOut.dp;
  outlet.h_outflow=h;
  outlet.xi_outflow=xi;

  eye_int[1].m_flow=-outlet.m_flow;
  eye_int[1].T= bulk.T-273.15;
  eye_int[1].s=bulk.s/1e3;
  eye_int[1].p=bulk.p/1e5;
  eye_int[1].h=h/1e3;

  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-80},{46,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
initial equation
  if initOption == 208 then
    der(h)=0;
    der(p)=0;
  elseif initOption == 1 then
    der(h)=0;
    der(p)=0;
    // der(xi)=zeros(medium.nc-1); to be activated when species balancing is added
  elseif initOption == 201 then
    der(p)=0;
  elseif initOption == 202 then
    der(h)=0;
  elseif initOption ==0 then
    // do nothing
  else
    assert(false, "Unknown initialisation type in " + getInstanceName());
  end if;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
              graphics));
end JoinVLE_L2_Y;
