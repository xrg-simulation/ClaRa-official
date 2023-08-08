within ClaRa.Components.TurboMachines.Pumps.Fundamentals;
partial model PumpVLE_affinityBase "Base class for affinity law based pumps"
  //import ClaRa;
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

  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import Modelica.Constants.pi;
  import TILMedia.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  import TILMedia.VLEFluidFunctions.density_phxi;
  import TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi;

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Pump_Base; //(inlet( m_flow(      start=V_flow_max*losses.V_flow_opt_*1000)))

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=0,
    powerOut_th=0,
    powerAux=P_shaft) if  contributeToCycleSummary;

  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.RPM rpm_fixed=60 "Constant rotational speed of pump" annotation (Dialog(group="Fundamental Definitions", enable=not useMechanicalPort));
  parameter Modelica.SIunits.Inertia J "Moment of Inertia" annotation(Dialog(group="Fundamental Definitions", enable= not steadyStateTorque));

  parameter Basics.Units.RPM rpm_nom "Nomial rotational speed" annotation (Dialog(group="Characteristic Field", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpCharField1.png"));
  parameter Basics.Units.VolumeFlowRate V_flow_max "Maximum volume flow rate at nominal speed" annotation (Dialog(group="Characteristic Field"));
  parameter Basics.Units.Pressure Delta_p_max "Maximum pressure difference at nominal speed" annotation (Dialog(group="Characteristic Field"));

  replaceable model Hydraulics =   ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics "Hydraulic characteristic" annotation(choicesAllMatching, Dialog(group= "Characteristic Field"));
  replaceable model Losses =  ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency.EfficiencyCurves_Q1  constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpEfficiency.BaseEfficiency "Model for losses"         annotation(choicesAllMatching, Dialog(group= "Characteristic Field"));
protected
  replaceable record ICom = ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 annotation(Dialog(hide=true));

 model Outline
   extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Outline;
    input Basics.Units.Power P_iso "Power for isentropic flow";
    input Basics.Units.Power P_shaft "Mechanicl power at shaft";
    input ClaRa.Basics.Units.RPM rpm "Pump revolutions per minute";
 end Outline;


public
  Modelica.SIunits.AngularAcceleration a "Angular acceleration of the shaft";
  Modelica.SIunits.Torque tau_fluid "Fluid torque";
  Basics.Units.RPM rpm "Rotational speed";

//  Real eta_hyd(start=eta_hyd_nom) "Hydraulic efficiency";
protected
  Basics.Units.EnthalpyMassSpecific h_iso_in(start=bubbleSpecificEnthalpy_pxi(
        iCom.medium,
        Delta_p_max,
        iCom.medium.xi_default)*0.9) "Inlet spec. enthalpy for isentropic state change";
  Basics.Units.EnthalpyMassSpecific h_iso_out "Outlet spec. enthalpy for isentropic state change";
  Basics.Units.Power P_iso "Power for isentropic pressure increase";
  Basics.Units.Power P_shaft "Shaft power";
  ClaRa.Basics.Units.DensityMassSpecific rho_upstream(start=density_phxi(
        iCom.medium,
        Delta_p_max,
        bubbleSpecificEnthalpy_pxi(
          iCom.medium,
          Delta_p_max,
          iCom.medium.xi_default)*0.9,
        iCom.medium.xi_default)) "Upstream density";


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
    Delta_p_max=Delta_p_max,
    V_flow_max=V_flow_max,
    rpm_nom=rpm_nom,
    V_flow=V_flow) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

public
  Hydraulics hydraulics annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-30,-30})));
  Losses losses annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,-30})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft if  useMechanicalPort
    annotation (Placement(transformation(extent={{-10,62},{10,82}}),
        iconTransformation(extent={{-10,89},{10,109}})));


protected
  ClaRa.Components.TurboMachines.Fundamentals.GetInputsRotary getInputsRotary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));



protected
  TILMedia.VLEFluid ptr_iso_in(vleFluidType=medium);
  TILMedia.VLEFluid ptr_iso_out(vleFluidType=medium);
equation

//_______________Additional media properties _______________
  h_iso_out = noEvent(if iCom.V_flow > 0 then ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) else inStream(outlet.h_outflow));
  h_iso_in = noEvent(if iCom.V_flow < 0 then ptr_iso_in.h_psxi(fluidIn.p, fluidOut.s, fluidIn.xi) else inStream(inlet.h_outflow));
  rho_upstream = noEvent(if iCom.V_flow > 0 then fluidIn.d else fluidOut.d);

//____________________ Mechanics ___________________________
   if useMechanicalPort then
     der(getInputsRotary.rotatoryFlange.phi) = (2*pi*rpm/60);
     J*a = - tau_fluid + getInputsRotary.rotatoryFlange.tau "Mechanical momentum balance";
   else
     rpm = rpm_fixed;
     getInputsRotary.rotatoryFlange.phi = 0.0;
   end if;

   if (steadyStateTorque) then
     a = 0;
   else
     a = (2*pi/60)*der(rpm);
   end if;

//____________________ Calculate Power _____________________
  //P_iso = Delta_p*V_flow; // Approximate rel. error is approx. 3% due to the assumption of constant density.
  P_iso = (h_iso_out -  h_iso_in)*inlet.m_flow;
  P_shaft = getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60;
  P_fluid = P_iso + losses.tau_loss*2*pi*rpm/60;
  V_flow = hydraulics.V_flow;
  tau_fluid = if noEvent(2*pi*rpm/60<1e-8) then 0 else (P_iso+losses.P_loss)/(2*pi*rpm/60);



  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,72},{0,72},{0,30}}, color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(graphics));
end PumpVLE_affinityBase;
