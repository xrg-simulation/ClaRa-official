within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L1_affinity "A pump for VLE mixtures based on affinity laws"

//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

//   import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
//   import SM = ClaRa.Basics.Functions.Stepsmoother;
//   import Modelica.Constants.pi;
//   import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  import Modelica.Constants.pi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubblePressure_Txi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi;
  import SM = ClaRa.Basics.Functions.Stepsmoother;

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.PumpVLE_affinityBase;

  parameter Boolean useDensityAffinity=false "True, if hydraulic characteristic shall be scalled w.r.t. densities according to affinity law" annotation(Dialog(group="Characteristic Field"));
  parameter Boolean useHead=false "True, if a pump head (height) | False, if pump head (pressure) should be used" annotation(Dialog(group="Characteristic Field"));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_zerohead = 1 "Volume flow where Delta_p/head = 0 for rpm_nom" annotation(Dialog(group="Characteristic Field"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_zeroflow_const = 1e5 "Constant pressure difference at flow = 0 for rpm_nom, T_nom_char, p_nom_char, xi_nom_char" annotation(Dialog(group="Characteristic Field", enable=not useHead));
  parameter ClaRa.Basics.Units.Length Head_zeroflow_const = 10 "Constant head at flow = 0 for rpm_nom" annotation(Dialog(group="Characteristic Field", enable=useHead));
  parameter ClaRa.Basics.Units.Temperature T_nom_char = 293.15 "Nominal temperature related to Delta_p_zeroflow_const (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.Pressure p_nom_char = 1e5 "Nominal pressure related to Delta_p_zeroflow_const (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.MassFraction xi_nom_char[medium.nc-1] = medium.xi_default "Nominal mass fraction related to Delta_p_zeroflow_const (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_eps = V_flow_zerohead/100 "Minimum volumetric flow rate for which hydraulic characteristic is still scaled with respect to density | For V_flow < abs(V_flow_eps) no density scalling is used." annotation(Dialog(tab="Expert Settings", enable = useDensityAffinity));


  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");


  Real mult_eta "1/eta if pump mode else eta (turbine mode)";
  ClaRa.Basics.Units.PressureDifference Delta_p_zeroflow "Pressure difference at flow= 0 for rpm_nom";
  Real rho_CF "Correction ratio of density w.r.t. affinity law";

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeVLE           inlet;
   ClaRa.Basics.Records.FlangeVLE           outlet;
 end Summary;

protected
  replaceable record ICom = ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 annotation(Dialog(hide=true));

  Basics.Units.EnthalpyMassSpecific h_iso_in(start=bubbleSpecificEnthalpy_pxi(
        iCom.medium,
        max(1e5, Delta_p_zeroflow_const),
        iCom.medium.xi_default)*0.9) "Inlet spec. enthalpy for isentropic state change";
  Basics.Units.EnthalpyMassSpecific h_iso_out "Outlet spec. enthalpy for isentropic state change";

  ClaRa.Basics.Units.DensityMassSpecific rho_upstream(start=density_phxi(
        iCom.medium,
        max(1e5, Delta_p_zeroflow_const),
        bubbleSpecificEnthalpy_pxi(
          iCom.medium,
          max(1e5, Delta_p_zeroflow_const),
          iCom.medium.xi_default)*0.9,
        iCom.medium.xi_default)) "Upstream density";

  ClaRa.Basics.Units.DensityMassSpecific rho_nom_char = density_pTxi(
        iCom.medium,
        p_nom_char,
        T_nom_char,
        xi_nom_char) "Nominal density related to Delta_p_zeroflow_const";

public
   Summary summary(
     outline(
       rpm=rpm,
       V_flow=iCom.V_flow,
       P_iso=P_iso,
       P_fluid =  P_fluid,
       P_shaft = getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60,
       Delta_p=Delta_p,
       head= Delta_p/(fluidIn.d*Modelica.Constants.g_n),
       NPSHa = (inlet.p - bubblePressure_Txi(fluidIn.T, fluidIn.xi, fluidIn.vleFluidPointer))/(fluidIn.d*Modelica.Constants.g_n),
       eta_hyd= energetics.eta,
       eta_mech=1),
     inlet(
       showExpertSummary = showExpertSummary,
       m_flow=inlet.m_flow,
       T=fluidIn.T,
       p=inlet.p,
       h=fluidIn.h,
       s=fluidIn.s,
       steamQuality = fluidIn.q,
       H_flow= fluidIn.h*inlet.m_flow,
       rho=fluidIn.d),
     outlet(
       showExpertSummary=showExpertSummary,
       m_flow=-outlet.m_flow,
       T=fluidOut.T,
       p=outlet.p,
       h=fluidOut.h,
       s=fluidOut.s,
       steamQuality=fluidOut.q,
       H_flow=-fluidOut.h*outlet.m_flow,
       rho=fluidOut.d))                                                                              annotation(Placement(transformation(
         extent={{-10,-10},{10,10}},
         origin={-70,-90})));


  inner ICom iCom(
    P_iso=P_iso,
    Delta_p=Delta_p,
    rpm=rpm,
    medium=medium,
    fluidPointer_in=fluidIn.vleFluidPointer,
    fluidPointer_out=fluidOut.vleFluidPointer,
    h_in=fluidIn.h,
    h_out=fluidOut.h,
    p_in=inlet.p,
    p_out=outlet.p,
    xi_in=fluidIn.xi,
    xi_out=fluidOut.xi,
    Delta_p_zeroflow=Delta_p_zeroflow,
    V_flow_zerohead=V_flow_zerohead,
    rpm_nom=rpm_nom,
    V_flow=V_flow,
    m_flow=inlet.m_flow,
    h_in_iso=h_iso_in,
    h_out_iso=h_iso_out) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_iso_in(vleFluidType=medium);
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_iso_out(vleFluidType=medium);
equation
//_______________Pressure head _______________
    if useDensityAffinity then
      if useHead then Delta_p_zeroflow = Head_zeroflow_const*rho_nom_char*Modelica.Constants.g_n*rho_CF;
      else Delta_p_zeroflow=Delta_p_zeroflow_const*rho_CF;
      end if;
    else
      if useHead then Delta_p_zeroflow=Head_zeroflow_const*rho_nom_char*Modelica.Constants.g_n;
      else Delta_p_zeroflow=Delta_p_zeroflow_const;
      end if;
    end if;

//  Delta_p_zeroflow = if useHead then Head_zeroflow_const*rho_nom_char*Modelica.Constants.g_n*rho_CF else Delta_p_zeroflow_const*rho_CF;
  rho_CF = SM(-V_flow_eps/1000, -V_flow_eps, iCom.V_flow) * SM(V_flow_eps/1000, V_flow_eps, iCom.V_flow) * 1
         + SM(-V_flow_eps, -V_flow_eps/1000, iCom.V_flow) * fluidOut.d/rho_nom_char
         + SM(V_flow_eps, V_flow_eps/1000, iCom.V_flow) * fluidIn.d/rho_nom_char;

//_______________Additional media properties _______________
  h_iso_out = noEvent(if iCom.V_flow > 0 then ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) else inStream(outlet.h_outflow));
  h_iso_in = noEvent(if iCom.V_flow < 0 then ptr_iso_in.h_psxi(fluidIn.p, fluidOut.s, fluidIn.xi) else inStream(inlet.h_outflow));
  rho_upstream = noEvent(if iCom.V_flow > 0 then fluidIn.d else fluidOut.d);

//____________________ Balance equations ___________________

  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p = outlet.p - inlet.p "Momentum balance";
  //outlet.h_outflow = SM(2*Delta_p_eps,Delta_p_eps, Delta_p)* SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p)*(h_iso_out - h_iso_in)/eta_hyd +  h_iso_in "Application of eta_hyd's definition";
  mult_eta = noEvent(if iCom.Delta_p> 0 then 1/energetics.eta else energetics.eta);
  outlet.h_outflow = (h_iso_out - h_iso_in)*mult_eta +  h_iso_in "Application of eta_hyd's definition";

//___________________ Boundary definition __________________
  inlet.h_outflow =  inStream(outlet.h_outflow) "Dummy value, reverse flow i not supported";
  inlet.xi_outflow =  inStream(outlet.xi_outflow) "No chemical reactions";
  outlet.xi_outflow =  inStream(inlet.xi_outflow) "No chemical reactions";

  inlet.m_flow = iCom.V_flow*rho_upstream;
  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,72},{0,72},{0,30}}, color={0,0,0}));
  annotation (Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineThickness=1,
            lineColor={167,25,48},
            fillPattern=FillPattern.None,
            pattern=DynamicSelect(LinePattern.None, if summary.outline.NPSHa <0 then LinePattern.Solid else LinePattern.None))}), Diagram(graphics));
end PumpVLE_L1_affinity;
