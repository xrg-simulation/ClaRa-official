within ClaRa.Components.VolumesValvesFittings.Fittings;
model JoinVLE_L2_flex "A join for an arbitrary number of inputs"
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
  extends ClaRa.Basics.Icons.Adapter5_bw;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  outer ClaRa.SimCenter simCenter;

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Volume volume_tot "Total volume";
end Outline;

model Summary
  parameter Integer N_ports_in;
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet[N_ports_in];
  ClaRa.Basics.Records.FlangeVLE           outlet;
  ClaRa.Basics.Records.FluidVLE_L2           fluid;
end Summary;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium = simCenter.fluid1 "Medium in the component"
                               annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer N_ports_in(min=1)=1 "Number of inlet  ports"
    annotation(Evaluate=true, Dialog(tab="General",group="Fundamental Definitions"));//connectorSizing=true,
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
   parameter ClaRa.Basics.Units.Volume volume(min=1e-6)=0.1 "System Volume"                               annotation(Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_in_nom[N_ports_in]= {10} "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"            annotation(Dialog(group="Nominal Values"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start= 1e5 "Start value of sytsem specific enthalpy"
                                             annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start= 1e5 "Start value of sytsem pressure" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction  xi_start[medium.nc-1] = medium.xi_default annotation(Dialog(tab="Initialisation"));
  parameter Integer initOption=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

  parameter Boolean showExpertSummary = false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean preciseTwoPhase = true "|Expert Stettings||True, if two-phase transients should be capured precisely";

protected
    parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom= TILMedia.VLEFluidFunctions.density_phxi(medium, p_nom, h_nom) "Nominal density";
    ClaRa.Basics.Units.Power Hdrhodt =  if preciseTwoPhase then h*volume*drhodt else 0 "h*volume*drhodt";
    Real Xidrhodt[medium.nc-1]= if preciseTwoPhase then xi*volume*drhodt else zeros(medium.nc-1) "h*volume*drhodt";

public
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_in[N_ports_in];
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_out;
  ClaRa.Basics.Units.EnthalpyMassSpecific h(start=h_start);
  ClaRa.Basics.Units.Mass mass "Total system mass";
  Real drhodt;//(unit="kg/(m3s)");
  ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_in[N_ports_in, medium.nc-1] "Mass fraction flows at inlet";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_out[medium.nc-1] "Mass fraction flows at outlet";
  ClaRa.Basics.Units.MassFraction xi[medium.nc-1](start=xi_start) "Mass fraction";

    Summary summary(N_ports_in=N_ports_in,outline(volume_tot = volume),
                    inlet(each showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h .* inlet.m_flow, rho=fluidIn.d),
                    fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                    outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h .* outlet.m_flow, rho=fluidOut.d))
     annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

public
  ClaRa.Basics.Interfaces.FluidPortIn inlet[N_ports_in](each Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
TILMedia.VLEFluid_ph bulk(each vleFluidType =    medium, p = p,h=h) annotation (Placement(transformation(extent={{-8,-12},
            {12,8}},                                                                                                    rotation=0)));

public
  ClaRa.Basics.Interfaces.EyeOut eye if showData      annotation(Placement(transformation(extent={{90,-90},
            {110,-70}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{45,-81},{47,-79}})));
protected
TILMedia.VLEFluid_ph fluidIn[N_ports_in](
    each vleFluidType=medium,
    h=noEvent(actualStream(inlet.h_outflow)),
    p=inlet.p)                                                           annotation (Placement(transformation(extent={{-86,-10},
            {-66,10}},                                                                                                  rotation=0)));
protected
TILMedia.VLEFluid_ph fluidOut(
    each vleFluidType=medium,
    h=noEvent(actualStream(outlet.h_outflow)),
    p=outlet.p)                                                          annotation (Placement(transformation(extent={{70,-10},
            {90,10}},                                                                                                   rotation=0)));
equation
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(volume>0, "The system volume must be greater than zero!");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
   mass= if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d;

   drhodt*volume=sum(inlet.m_flow) + sum(outlet.m_flow) "Mass balance";
   drhodt = der(p)*bulk.drhodp_hxi
          + der(h)*bulk.drhodh_pxi
          + sum(der(xi).*bulk.drhodxi_ph);
                                                   //calculating drhodt from state variables

   der(h) = 1/mass*(sum(H_flow_in) + H_flow_out  + volume*der(p) -Hdrhodt) "Energy balance, decoupled from the mass balance to avoid heavy mass fluctuations during phase change or flow reversal. The term '-h*volume*drhodt' is ommited";
   der(xi) = {(sum(Xi_flow_in[:,i])+ Xi_flow_out[i]- Xidrhodt[i])/mass for i in 1:medium.nc-1}; //;
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  for i in 1:N_ports_in loop
    inlet[i].h_outflow=h;
    inlet[i].xi_outflow=xi;
    H_flow_in[i]=if useHomotopy then homotopy(actualStream(inlet[i].h_outflow)*inlet[i].m_flow, inStream(inlet[i].h_outflow)*m_flow_in_nom[i]) else actualStream(inlet[i].h_outflow)*inlet[i].m_flow;
    Xi_flow_in[i]=if useHomotopy then homotopy(actualStream(inlet[i].xi_outflow)*inlet[i].m_flow, inStream(inlet[i].xi_outflow)*m_flow_in_nom[i]) else actualStream(inlet[i].xi_outflow)*inlet[i].m_flow;

    inlet[i].p=p;
  end for;

    H_flow_out= if useHomotopy then homotopy(actualStream(outlet.h_outflow)*outlet.m_flow, -h*sum(m_flow_in_nom)) else actualStream(outlet.h_outflow)*outlet.m_flow;
    Xi_flow_out= if useHomotopy then homotopy(actualStream(outlet.xi_outflow)*outlet.m_flow, -xi*sum(m_flow_in_nom)) else actualStream(outlet.xi_outflow)*outlet.m_flow;
    outlet.p=p;
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

  annotation (Icon(graphics),
      Diagram(graphics));
end JoinVLE_L2_flex;
