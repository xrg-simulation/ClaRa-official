within ClaRa_Obsolete.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_L3_TwoZonesNPort "A volume element balancing liquid and vapour phase with n inlet and outlet ports"
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
  extends ClaRa.Basics.Icons.Volume2Zones;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_1;
  outer ClaRa.SimCenter simCenter;

  import Modelica.Constants.eps;
  import ClaRa.Basics.Functions.Stepsmoother;
  import ClaRa;

  //______________________________________________________
  //____________local summary definition__________________
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    ClaRa.Basics.Units.Volume volume_tot "Total volume";
    ClaRa.Basics.Units.Area A_heat_tot "Heat transfer area";
    ClaRa.Basics.Units.Volume volume[2] if showExpertSummary "Volume of liquid and steam volume";
    ClaRa.Basics.Units.Area A_heat[2] if showExpertSummary "Heat transfer area";
    ClaRa.Basics.Units.Length level_abs "Absolue filling level";
    Real level_rel if showExpertSummary "relative filling level";
    ClaRa.Basics.Units.Mass fluidMass "Total fluid mass";
    ClaRa.Basics.Units.Enthalpy H_tot if showExpertSummary "Systems's enthalpy";
    ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
    ClaRa.Basics.Units.HeatFlowRate Q_flow[2] if showExpertSummary "Zonal heat flow rate";
    ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    parameter Integer N_inlet=1;
    parameter Integer N_outlet=1;
    ClaRa.Basics.Records.FlangeVLE inlet[N_inlet];
    ClaRa.Basics.Records.FlangeVLE outlet[N_outlet];
    ClaRa.Basics.Records.FluidVLE_L34 fluid;
  end Summary;

  //_____________________________________________________
  //_______________replaceable models____________________
  inner parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L3 "1st: choose heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=
        true);

  replaceable model PhaseBorder =
      ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution.RealSeparated
    constrainedby ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.SpatialDistribution.RealPhases "1st: choose phase border model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=
        true);

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "1st: choose friction model | 2nd: edit corresponding record"
                                                                  annotation (
      Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

  //_____________________________________________________
  //______________________parameters_____________________
  parameter ClaRa.Basics.Units.Time Tau_cond=0.03 "Time constant of condensation" annotation(Dialog(tab="Phase Border"));
  parameter ClaRa.Basics.Units.Time Tau_evap=Tau_cond "Time constant of evaporation" annotation(Dialog(tab="Phase Border"));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "HTC of the phase border" annotation(Dialog(tab="Phase Border"));
  parameter ClaRa.Basics.Units.Area A_heat_ph=geo.A_hor*100 "Heat transfer area at phase border" annotation(Dialog(tab="Phase Border"));
  parameter Real exp_HT_phases = 0 "Exponent for volume dependency on inter phase HT" annotation(Dialog(tab="Phase Border"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(tab="Initialisation"));
  inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet"
    annotation (Dialog(tab="General", group="Nominal Values"));

  inner parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure"
    annotation (Dialog(group="Nominal Values"));

  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_liq_nom=
      TILMedia.VLEFluid.Functions.bubbleDensity_pxi(
                                                   medium, p_nom) "Nominal density";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_vap_nom=
      TILMedia.VLEFluid.Functions.dewDensity_pxi(
                                                medium, p_nom) "Nominal density";

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluid.Functions.bubbleSpecificEnthalpy_pxi(
                                                            medium, p_start) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluid.Functions.dewSpecificEnthalpy_pxi(
                                                         medium, p_start) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction xi_liq_start[medium.nc - 1]=medium.xi_default "Initial composition of liquid phase" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_vap_start[medium.nc - 1]=medium.xi_default "Initial composition of vapour phase" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure"
                                     annotation (Dialog(tab="Initialisation"));
  parameter Real level_rel_start=0.5 "Start value for relative filling level"
    annotation (Dialog(tab="Initialisation"));

  inner parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Initialisation", choicesAllMatching));
  //  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius" annotation(Dialog(group="Geometry"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered" annotation(dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));

  //_____________________________________________________
  //_______Variables and model instances_________________
public
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_liq(start=h_liq_start) "Specific enthalpy of liquid phase";
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_vap(start=h_vap_start) "Specific enthalpy of vapour phase";
  ClaRa.Basics.Units.MassFraction xi_liq[medium.nc - 1](start=xi_liq_start) "Species mass fraction in liquid phase";
  ClaRa.Basics.Units.MassFraction xi_vap[medium.nc - 1](start=xi_vap_start) "Species mass fraction in vapour phase";
  // SI.MassFraction xi_in[medium.nc-1] "Inlet species mass fraction";
  // SI.MassFraction xi_out[medium.nc-1] "Outlet species mass fraction";

  Real drho_liqdt;
  Real drho_vapdt;
  //(unit="kg/(m3s)");
  ClaRa.Basics.Units.Volume volume_liq "Liquid volume";
  ClaRa.Basics.Units.Volume volume_vap(start=(1 - phaseBorder.level_rel_start)*geo.volume) "Vapour volume";
  ClaRa.Basics.Units.MassFlowRate m_flow_cond "Condensing mass flow";
  ClaRa.Basics.Units.MassFlowRate m_flow_evap "Evaporating mass flow";
   ClaRa.Basics.Units.HeatFlowRate Q_flow_phases "Heat flow between phases";

  ClaRa.Basics.Units.Mass mass_liq "Liquid mass";
  ClaRa.Basics.Units.Mass mass_vap "Vapour mass";
  inner ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";

  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_inliq[geo.N_inlet] "Enthalpy flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_invap[geo.N_inlet] "Enthalpy flow rate passing from inlet to vapour zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_outliq[geo.N_outlet] "Enthalpy flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate H_flow_outvap[geo.N_outlet] "Enthalpy flow rate passing from outlet to vapour zone and vice versa";

  ClaRa.Basics.Units.EnthalpyFlowRate Xi_flow_inliq[geo.N_inlet,medium.nc - 1] "Mass flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate Xi_flow_invap[geo.N_inlet,medium.nc - 1] "Enthalpy flow rate passing from inlet to vapour zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate Xi_flow_outliq[geo.N_outlet,medium.nc - 1] "Enthalpy flow rate passing from inlet to liquid zone and vice versa";
  ClaRa.Basics.Units.EnthalpyFlowRate Xi_flow_outvap[geo.N_outlet,medium.nc - 1] "Enthalpy flow rate passing from outlet to vapour zone and vice versa";

  ClaRa.Basics.Interfaces.FluidPortIn inlet[geo.N_inlet](each Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet[geo.N_outlet](each Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat[2] annotation (Placement(
        transformation(extent={{84,86},{104,106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));

  TILMedia.VLEFluid.VLEFluid_ph fluidIn[geo.N_inlet](
    each vleFluidType=medium,
    final p=inlet.p,
    final h={if useHomotopy then homotopy(actualStream(inlet[i].h_outflow), inStream(inlet[i].h_outflow)) else
        actualStream(inlet[i].h_outflow) for i in 1:geo.N_inlet},
    xi={if useHomotopy then homotopy(actualStream(inlet[i].xi_outflow), inStream(inlet[i].xi_outflow)) else
        actualStream(inlet[i].xi_outflow) for i in 1:geo.N_inlet})
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=0)));

  TILMedia.VLEFluid.VLEFluid_ph fluidOut[geo.N_outlet](
    each vleFluidType=medium,
    final p=outlet.p,
    final h={if useHomotopy then homotopy(actualStream(outlet[i].h_outflow), outlet[i].h_outflow) else actualStream(
        outlet[i].h_outflow) for i in 1:geo.N_outlet},
    xi={if useHomotopy then homotopy(actualStream(outlet[i].xi_outflow), outlet[i].xi_outflow) else actualStream(outlet[
        i].xi_outflow) for i in 1:geo.N_outlet})
    annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));

  HeatTransfer heattransfer(
  final heatSurfaceAlloc=heatSurfaceAlloc)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));
  PhaseBorder phaseBorder(level_rel_start=level_rel_start)
    annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  PressureLoss pressureLoss
    annotation (Placement(transformation(extent={{12,60},{32,80}})));

  Summary summary(
    final N_inlet=geo.N_inlet,
    final N_outlet=geo.N_outlet,
    inlet(
      each showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidIn.T,
      p=inlet.p,
      h=fluidIn.h,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=fluidIn.h .* inlet.m_flow,
      rho=fluidIn.d),
    outlet(
      each showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h .* outlet.m_flow,
      rho=fluidOut.d),
    fluid(
      showExpertSummary=showExpertSummary,
      mass={mass_liq,mass_vap},
      p={p,p},
      h=iCom.h,
      h_bub={liq.VLE.h_l,vap.VLE.h_l},
      h_dew={liq.VLE.h_v,vap.VLE.h_v},
      T=iCom.T,
      T_sat={liq.VLE.T_l,vap.VLE.T_l},
      s={liq.s,vap.s},
      steamQuality={liq.q,vap.q},
      H=iCom.h .* {mass_liq,mass_vap},
      rho={liq.d,vap.d},
      final N_cv=2),
    outline(
      showExpertSummary=showExpertSummary,
      volume_tot=geo.volume,
      volume={volume_liq,volume_vap},
      A_heat=geo.A_heat[heatSurfaceAlloc]*{volume_liq,volume_vap}/geo.volume,
      A_heat_tot=geo.A_heat[heatSurfaceAlloc],
      level_abs=phaseBorder.level_abs,
      level_rel=phaseBorder.level_rel,
      Delta_p=inlet[1].p - outlet[1].p,
      fluidMass=mass_vap + mass_liq,
      H_tot=h_liq*mass_liq + h_vap*mass_vap,
      Q_flow_tot=sum(heat.Q_flow),
      Q_flow=heattransfer.heat.Q_flow)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

protected
  inner TILMedia.VLEFluid.VLEFluid_ph vap(
    vleFluidType=medium,
    p=p,
    h=h_vap,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    xi=xi_vap) annotation (Placement(transformation(extent={{-10,8},{10,28}}, rotation=0)));
  inner TILMedia.VLEFluid.VLEFluid_ph liq(
    vleFluidType=medium,
    h=h_liq,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    p=p,
    xi=xi_liq) annotation (Placement(transformation(extent={{-10,-20},{10,0}}, rotation=0)));
  inner ClaRa.Basics.Records.IComVLE_L3_NPort
                                       iCom(
    p_in=inlet.p,
    p_out=outlet.p,
    h={h_liq,h_vap},
    T_in=fluidIn.T,
    T_out=fluidOut.T,
    N_cv=2,
    m_flow_nom=m_flow_nom,
    N_inlet=geo.N_inlet,
    N_outlet=geo.N_outlet,
    volume={volume_liq,volume_vap},
    m_flow_in=inlet.m_flow,
    T={liq.T,vap.T},
    p={p,p},
    m_flow_out=outlet.m_flow,
    fluidPointer_in=fluidIn.vleFluidPointer,
    fluidPointer_out=fluidOut.vleFluidPointer,
    fluidPointer={liq.vleFluidPointer, vap.vleFluidPointer},
    h_in=fluidIn.h,
    h_out=fluidOut.h,
    xi_in=fluidIn.xi,
    xi_out=fluidOut.xi,
    mediumModel=medium,
    xi={liq.xi,vap.xi}) "Internal communication record"
    annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));
equation

  //_____________________________________________________
  //_______Asserts_______________________________________
  assert(geo.volume > 0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceAlloc] >= 0, "The area of heat transfer must be greater than zero!");

  //_____________________________________________________
  //_______System definition_____________________________
  mass_liq = if useHomotopy then homotopy(volume_liq*liq.d, volume_liq*
    rho_liq_nom) else volume_liq*liq.d;
  mass_vap = if useHomotopy then homotopy(volume_vap*vap.d, volume_vap*
    rho_vap_nom) else volume_vap*vap.d;
  drho_liqdt = der(p)*liq.drhodp_hxi + der(h_liq)*liq.drhodh_pxi + sum(der(xi_liq)*liq.drhodxi_ph);
  //calculating drhodt from state variables
  drho_vapdt = der(p)*vap.drhodp_hxi + der(h_vap)*vap.drhodh_pxi + sum(der(xi_vap)*vap.drhodxi_ph);
  //calculating drhodt from state variables
  volume_liq = geo.volume - volume_vap;

  //_____________________________________________________
  //_______Mass Balances_________________________________

  drho_liqdt*volume_liq = +liq.d*der(volume_vap) + sum(phaseBorder.m_flow_inliq)
     + sum(phaseBorder.m_flow_outliq) + m_flow_cond - m_flow_evap "Liquid mass balance";
  drho_vapdt*volume_vap = -vap.d*der(volume_vap) + sum(phaseBorder.m_flow_invap) +
    sum(phaseBorder.m_flow_outvap) - m_flow_cond + m_flow_evap "Liquid mass balance";

  //_____________________________________________________
  //______Species Balances_______________________________
   for i in 1:medium.nc-1 loop
     der(xi_liq[i]) = if mass_liq > 1e-6 then (sum(Xi_flow_inliq[:,i]) + sum(Xi_flow_outliq[:,i])
                                           + m_flow_cond.*liq.VLE.xi_l[i]- m_flow_evap.*liq.VLE.xi_v[i]
                                           -liq.xi[i]*(drho_liqdt*volume_liq -liq.d*der(volume_vap)))
                                             ./ mass_liq
                   else der(xi_vap[i]);
      der(xi_vap[i]) = if mass_vap > 1e-6 then (sum(Xi_flow_invap[:,i]) + sum(Xi_flow_outvap[:,i])
                                            - m_flow_cond.*vap.VLE.xi_l[i] + m_flow_evap.*vap.VLE.xi_v[i]
                                            -vap.xi[i].*(drho_vapdt*volume_vap +vap.d.*der(volume_vap)))
                                             ./ mass_vap
                    else der(xi_liq[i]);
   end for;

  //_____________________________________________________
  //______Energy Balances________________________________
//   der(h_liq) = if mass_liq > 1e-6 then (sum(H_flow_inliq) + sum(H_flow_outliq) + m_flow_cond*max(vap.VLE.h_l,h_vap) - m_flow_evap*min(vap.VLE.h_v, h_liq)
//      + volume_liq*der(p) + p*der(volume_liq) - h_liq*volume_liq*drho_liqdt -
//     liq.d*h_liq*der(volume_liq) + phaseBorder.Q_flow_phases + heattransfer.heat[1].Q_flow)/
//     mass_liq else der(h_vap);
//
//   der(h_vap) = if mass_vap > 1e-6 then (sum(H_flow_invap) + sum(H_flow_outvap) - m_flow_cond*max(vap.VLE.h_l,h_vap) + m_flow_evap*min(vap.VLE.h_v,h_liq) +
//     volume_vap*der(p) + p*der(volume_vap) - h_vap*volume_vap*drho_vapdt - vap.d
//     *h_vap*der(volume_vap) - phaseBorder.Q_flow_phases + heattransfer.heat[2].Q_flow)/
//     mass_vap else der(h_liq);
  der(h_liq) = if mass_liq > 1e-6 then (sum(H_flow_inliq) + sum(H_flow_outliq) + m_flow_cond*vap.VLE.h_l - m_flow_evap*vap.VLE.h_v
     + volume_liq*der(p) + p*der(volume_liq) - h_liq*volume_liq*drho_liqdt -
    liq.d*h_liq*der(volume_liq) + Q_flow_phases + heattransfer.heat[1].Q_flow)/
    mass_liq else der(h_vap);

  der(h_vap) = if mass_vap > 1e-6 then (sum(H_flow_invap) + sum(H_flow_outvap) - m_flow_cond*vap.VLE.h_l + m_flow_evap*vap.VLE.h_v +
    volume_vap*der(p) + p*der(volume_vap) - h_vap*volume_vap*drho_vapdt - vap.d
    *h_vap*der(volume_vap) - Q_flow_phases + heattransfer.heat[2].Q_flow)/
    mass_vap else der(h_liq);
//________________________________________________________________________________
//______Coupling of the Phases: Heat Transfer_____________________________________
//   Q_flow_phases = noEvent(alpha_ph*A_heat_ph*(iCom.T[2] - iCom.T[1]));
  Q_flow_phases = noEvent(alpha_ph*A_heat_ph*min((1e-6+iCom.volume[1])/(1e-6+iCom.volume[2]), (1e-6+iCom.volume[2])/(1e-6+iCom.volume[1]))^exp_HT_phases*(iCom.T[2] - iCom.T[1]));

//________________________________________________________________________________
//______Coupling of the Phases: Mass Transfer_____________________________________
  m_flow_cond = Stepsmoother(1e-1, 1e-3, mass_vap*(1 - vap.q))*Stepsmoother(-10, +10, h_vap - vap.VLE.h_v)*(1 - noEvent(max(0, min(1, vap.q))))*max(0, mass_vap)/Tau_cond;
  m_flow_evap = Stepsmoother(1e-1, 1e-3,mass_liq*liq.q)       *Stepsmoother(-10, +10, liq.VLE.h_l - h_liq)*     noEvent(max(0, min(1, liq.q)))        *mass_liq /Tau_evap;

//    m_flow_cond = Stepsmoother(1e-1,1e-3,mass_vap*(1 - vap.q))*Stepsmoother(vap.VLE.h_l, vap.VLE.h_v+100, h_vap)*mass_vap/Tau_cond;
//    m_flow_evap = Stepsmoother(1e-1,1e-3,mass_liq*liq.q)      *Stepsmoother(liq.VLE.h_v+100, liq.VLE.h_l, h_liq)*mass_liq/Tau_evap;
  //____________________________________________________
  //______Boundary Conditions___________________________

  inlet.h_outflow  =  {(phaseBorder.zoneAlloc_in[i]-1)*iCom.h[2] + (2-phaseBorder.zoneAlloc_in[i]) *iCom.h[1] for i in 1:geo.N_inlet};
  outlet.h_outflow =  {(phaseBorder.zoneAlloc_out[i]-1)*iCom.h[2]+ (2-phaseBorder.zoneAlloc_out[i])*iCom.h[1] for i in 1:geo.N_outlet};
   inlet.xi_outflow  ={(phaseBorder.zoneAlloc_in[i]-1)*iCom.xi[2,:] + (2-phaseBorder.zoneAlloc_in[i]) *iCom.xi[1,:] for i in 1:geo.N_inlet};
   outlet.xi_outflow = {(phaseBorder.zoneAlloc_out[i]-1)*iCom.xi[2,:]+ (2-phaseBorder.zoneAlloc_out[i])*iCom.xi[1,:] for i in 1:geo.N_outlet};

  for i in 1:geo.N_inlet loop
    H_flow_inliq[i] = phaseBorder.m_flow_inliq[i]*fluidIn[i].h;//semiLinear(phaseBorder.m_flow_inliq[i], inStream(inlet[i].h_outflow), h_liq);
    H_flow_invap[i] = phaseBorder.m_flow_invap[i]*fluidIn[i].h;//semiLinear(phaseBorder.m_flow_invap[i], inStream(inlet[i].h_outflow), h_vap);
    Xi_flow_inliq[i,:] = phaseBorder.m_flow_inliq[i]*fluidIn[i].xi;//semiLinear(phaseBorder.m_flow_inliq[i], inStream(inlet[i].Xi_outflow), xi_liq);
    Xi_flow_invap[i,:] = phaseBorder.m_flow_invap[i]*fluidIn[i].xi;//semiLinear(phaseBorder.m_flow_invap[i], inStream(inlet[i].Xi_outflow), xi_vap);
  end for;
  for i in 1:geo.N_outlet loop
     H_flow_outliq[i] = phaseBorder.m_flow_outliq[i]* fluidOut[i].h;//semiLinear(phaseBorder.m_flow_outliq[i], inStream(outlet[i].h_outflow), h_liq);
     H_flow_outvap[i] = phaseBorder.m_flow_outvap[i]* fluidOut[i].h;//semiLinear(phaseBorder.m_flow_outvap[i], inStream(outlet[i].h_outflow), h_vap);
     Xi_flow_outliq[i,:] = phaseBorder.m_flow_outliq[i]* fluidOut[i].xi;//semiLinear(phaseBorder.m_flow_outliq[i], inStream(outlet[i].Xi_outflow), xi_liq);
     Xi_flow_outvap[i,:] = phaseBorder.m_flow_outvap[i]* fluidOut[i].xi;//semiLinear(phaseBorder.m_flow_outvap[i], inStream(outlet[i].Xi_outflow), xi_vap);
  end for;

  for i in 1:geo.N_inlet loop
    inlet[i].p =p + pressureLoss.Delta_p[i] + phaseBorder.Delta_p_geo_in[i];
  end for;
  for i in 1:geo.N_outlet loop
    outlet[i].p =p + phaseBorder.Delta_p_geo_out[i] "The friction term is lumped at the inlet side to avoid direct coupling of two flow models, this avoids an iteration of mass flow rates in some application cases";
  end for;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  In the following equations dividing the friction pressure loss into two parts located at the inlet and outlet side respectively leads
  //  to a disadvatageous coupling of flow model cascades and iteration of mass flow rates in some applications.
  //    inlet.p  =  p + pressureLoss.Delta_p/2 + phaseBorder.dp_geo_in;
  //    outlet.p = p - pressureLoss.Delta_p/2 + phaseBorder.dp_geo_out;
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //____________________________________________________
  //______Chemistry_____________________________________
  // No chemical reaction taking place:
//    inlet.Xi_outflow = inStream(outlet.Xi_outflow);
//    outlet.Xi_outflow = inStream(inlet.Xi_outflow);

  //___________________________________________________
  //______Initial Equations____________________________
initial equation
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h_liq) = 0;
    der(h_vap) = 0;
    der(p) = 0;
    der(volume_vap) = 0;

  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p) = 0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h_liq) = 0;
    der(h_vap) = 0;
    //der(volume_vap)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensity then
    //    der(y)=0;
    phaseBorder.level_rel = phaseBorder.level_rel_start;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensityPressure then
    //phaseBorder.relLevel=phaseBorder.level_rel_start;
    //der(volume_vap)=0;
  elseif initType == ClaRa.Basics.Choices.Init.noInit then
    phaseBorder.level_rel = phaseBorder.level_rel_start;
    h_liq = h_liq_start;
    h_vap = h_vap_start;
    p = p_start;
  end if;

equation
  connect(heattransfer.heat, heat) annotation (Line(
      points={{-60,70},{-54,70},{-54,96},{94,96}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
</html>"));
end VolumeVLE_L3_TwoZonesNPort;
