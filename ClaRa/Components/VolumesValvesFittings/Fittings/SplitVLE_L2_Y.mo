within ClaRa.Components.VolumesValvesFittings.Fittings;
model SplitVLE_L2_Y "A voluminous split for 2 outputs"
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
  import SI = ClaRa.Basics.Units;
 extends ClaRa.Basics.Interfaces.DataInterfaceVector(final N_sets=2);
  extends ClaRa.Basics.Icons.Tpipe2;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  outer ClaRa.SimCenter simCenter;
model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Volume volume_tot "Total volume";
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet1;
  ClaRa.Basics.Records.FlangeVLE           outlet2;
  ClaRa.Basics.Records.FluidVLE_L2           fluid;
end Summary;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                               annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

replaceable model PressureLossIn =
    Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at inlet" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossOut1 =
      Fundamentals.NoFriction  constrainedby Fundamentals.BaseDp "Pressure loss model at outlet 1" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossOut2 =
      Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at outlet 2" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
   parameter SI.Volume volume(min=1e-6)=0.1 "System Volume"                               annotation(Dialog(tab="General", group="Geometry"));
  parameter SI.MassFlowRate m_flow_out_nom[2]= {10, 10} "Nominal mass flow rates at outlet"
                                         annotation(Dialog(tab="General", group="Nominal Values"));
  parameter SI.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  parameter SI.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"                      annotation(Dialog(group="Nominal Values"));

  parameter SI.EnthalpyMassSpecific h_start= 1e5 "Start value of sytsem specific enthalpy"
                                             annotation(Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start= 1e5 "Start value of sytsem pressure"               annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction  xi_start[medium.nc-1] = medium.xi_default annotation(Dialog(tab="Initialisation"));
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
  SI.EnthalpyFlowRate H_flow_in;
  SI.EnthalpyFlowRate H_flow_out[2];
  SI.EnthalpyMassSpecific h(start=h_start);
  SI.Mass mass "Total system mass";
  Real drhodt;//(unit="kg/(m3s)");
  SI.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_in[medium.nc-1] "Mass fraction flows at inlet";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_out[2,medium.nc-1] "Mass fraction flows at outlet";
  ClaRa.Basics.Units.MassFraction xi[medium.nc-1](start=xi_start) "Mass fraction";

public
   Summary summary(outline(volume_tot = volume),
                   inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                   outlet1(showExpertSummary = showExpertSummary,m_flow = -outlet1.m_flow, T=fluidOut1.T, p=outlet1.p, h=fluidOut1.h, s=fluidOut1.s, steamQuality=fluidOut1.q, H_flow=-fluidOut1.h*outlet1.m_flow, rho=fluidOut1.d),
                   outlet2(showExpertSummary = showExpertSummary,m_flow = -outlet2.m_flow, T=fluidOut2.T, p=outlet2.p, h=fluidOut2.h, s=fluidOut2.s, steamQuality=fluidOut2.q, H_flow=-fluidOut2.h*outlet2.m_flow, rho=fluidOut2.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet1(each Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
TILMedia.VLEFluid_ph bulk(each vleFluidType = medium, p = p,h=h) annotation (Placement(transformation(extent={{-10,-12},
            {10,8}},                                                                                                    rotation=0)));

public
  ClaRa.Basics.Interfaces.FluidPortOut outlet2(each Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
protected
TILMedia.VLEFluid_ph fluidOut1(
    each vleFluidType=medium,
    h=noEvent(actualStream(outlet1.h_outflow)),
    p=outlet1.p)                                                         annotation (Placement(transformation(extent={{70,-10},
            {90,10}},                                                                                                   rotation=0)));
protected
TILMedia.VLEFluid_ph fluidIn(
    each vleFluidType=medium,
    h=noEvent(actualStream(inlet.h_outflow)),
    p=inlet.p)                                                           annotation (Placement(transformation(extent={{-90,-12},
            {-70,8}},                                                                                                   rotation=0)));
TILMedia.VLEFluid_ph fluidOut2(
    each vleFluidType=medium,
    h=noEvent(actualStream(outlet2.h_outflow)),
    p=outlet2.p)                                                         annotation (Placement(transformation(extent={{-10,-70},
            {10,-50}},                                                                                                  rotation=0)));

PressureLossIn pressureLossIn;
PressureLossOut1 pressureLossOut1;
PressureLossOut2 pressureLossOut2;

equation
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(volume>0, "The system volume must be greater than zero!");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
   mass= if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d;

   drhodt*volume=inlet.m_flow + outlet1.m_flow + outlet2.m_flow "Mass balance";
   drhodt = der(p)*bulk.drhodp_hxi
          + der(h)*bulk.drhodh_pxi
          + sum(der(xi).*bulk.drhodxi_ph);
                                                   //calculating drhodt from state variables

   der(h) = 1/mass*(sum(H_flow_out) + H_flow_in  + volume*der(p) -Hdrhodt) "Energy balance, decoupled from the mass balance to avoid heavy mass fluctuations during phase change or flow reversal. The term '-h*volume*drhodt' is ommited";
   der(xi) = {(sum(Xi_flow_out[:,i])+ Xi_flow_in[i]- Xidrhodt[i])/mass for i in 1:medium.nc-1} "Species balance";
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
    pressureLossIn.m_flow=inlet.m_flow;
  pressureLossOut1.m_flow=-outlet1.m_flow;
  pressureLossOut2.m_flow=-outlet2.m_flow;
    H_flow_out[1]=if useHomotopy then homotopy(noEvent(actualStream(outlet1.h_outflow))*outlet1.m_flow, -h*m_flow_out_nom[1]) else noEvent(actualStream(outlet1.h_outflow))*outlet1.m_flow;
    H_flow_out[2]=if useHomotopy then homotopy(noEvent(actualStream(outlet2.h_outflow))*outlet2.m_flow, -h*m_flow_out_nom[2]) else noEvent(actualStream(outlet2.h_outflow))*outlet2.m_flow;
    Xi_flow_out[1]=if useHomotopy then homotopy(noEvent(actualStream(outlet1.xi_outflow))*outlet1.m_flow, -xi*m_flow_out_nom[1]) else noEvent(actualStream(outlet1.xi_outflow))*outlet1.m_flow;
    Xi_flow_out[2]=if useHomotopy then homotopy(noEvent(actualStream(outlet2.xi_outflow))*outlet2.m_flow, -xi*m_flow_out_nom[2]) else noEvent(actualStream(outlet2.xi_outflow))*outlet2.m_flow;


    outlet1.p=p - pressureLossOut1.dp;
    outlet1.h_outflow=h;
    outlet1.xi_outflow=xi;
    outlet2.p=p - pressureLossOut2.dp;
    outlet2.h_outflow=h;
    outlet2.xi_outflow=xi;
    H_flow_in= if useHomotopy then homotopy(noEvent(actualStream(inlet.h_outflow))*inlet.m_flow, inStream(inlet.h_outflow)*sum(m_flow_out_nom)) else noEvent(actualStream(inlet.h_outflow))*inlet.m_flow;
    Xi_flow_in= if useHomotopy then homotopy(noEvent(actualStream(inlet.xi_outflow))*inlet.m_flow, inStream(inlet.xi_outflow)*sum(m_flow_out_nom)) else noEvent(actualStream(inlet.xi_outflow))*inlet.m_flow;

    inlet.p=p+pressureLossIn.dp;
    inlet.h_outflow=h;
    inlet.xi_outflow=xi;
  for i in 1:2 loop

    eye[i].T= bulk.T-273.15;
    eye[i].s=bulk.s/1e3;
    eye[i].p=bulk.p/1e5;
    eye[i].h=h/1e3;
  end for;
    eye[1].m_flow=-outlet1.m_flow;
    eye[2].m_flow=-outlet2.m_flow;

initial equation
  if initOption == 208 then
    der(h)=0;
    der(p)=0;
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
                   graphics={Rectangle(
          extent={{-92,32},{-74,-32}},
          pattern=LinePattern.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=pressureLossIn.hasPressureLoss), Rectangle(
          extent={{74,32},{92,-32}},
          pattern=LinePattern.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=pressureLossOut1.hasPressureLoss),
        Rectangle(
          extent={{-32,-76},{32,-92}},
          pattern=LinePattern.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=pressureLossOut2.hasPressureLoss)}),
                              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics));
end SplitVLE_L2_Y;
