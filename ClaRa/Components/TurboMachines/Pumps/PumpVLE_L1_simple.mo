within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L1_simple "A pump for VLE mixtures with a volume flow rate depending on drive power and pressure difference only"
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

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Pump_Base(inlet(m_flow(start=m_flow_start)));
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  import TILMedia.VLEFluidObjectFunctions.bubblePressure_Txi;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=inlet.m_flow*(fluidIn.h - fluidOut.h),
    powerAux=(P_drive - inlet.m_flow*(fluidOut.h - fluidIn.h))) if  contributeToCycleSummary;



  parameter Real eta_mech = 0.98 "Mechanic efficiency of the drive"
   annotation(Dialog(group="Part Load and Efficiency"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_start=1 "Initial guess value for mass flow" annotation(Dialog(group="Initialisation"));
   parameter ClaRa.Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero" annotation(Dialog(tab="Expert Settings", group="Numerical Robustnes"));

  Modelica.Blocks.Interfaces.RealInput P_drive "Power input of the pump's motor"
                                      annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Fundamentals.Summary summary(
    outline(V_flow=V_flow,
      P_fluid=P_fluid,
      Delta_p=Delta_p,
      head= Delta_p/(fluidIn.d*Modelica.Constants.g_n),
      NPSHa = (inlet.p - bubblePressure_Txi(fluidIn.T, fluidIn.xi, fluidIn.vleFluidPointer))/(fluidIn.d*Modelica.Constants.g_n),
      eta_hyd=0, eta_mech=eta_mech),
    inlet(showExpertSummary=showExpertSummary,
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
      rho=fluidOut.d))                                                                                                     annotation(Placement(transformation(
        extent={{-10,-11},{10,11}},
        origin={-70,-91})));
equation
  P_fluid=P_drive*eta_mech;
  V_flow= P_fluid/(Delta_p+Delta_p_eps);
  inlet.m_flow=V_flow * fluidIn.d;
  inlet.h_outflow=inStream(outlet.h_outflow); // This is a dummy - flow reversal is not supported!
//____________________ Balance equations ___________________
  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p=outlet.p-inlet.p "Momentum balance";
//   inStream(inlet.h_outflow) + outlet.h_outflow + P_hyd/inlet.m_flow/eta_hyd = 0.0
//     "Energy balance";
  outlet.h_outflow = inStream(inlet.h_outflow)  + P_drive*eta_mech/(inlet.m_flow+1e-6) "Energy balance";

  annotation (Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineThickness=1,
            lineColor={167,25,48},
            fillPattern=FillPattern.None,
            pattern=DynamicSelect(LinePattern.None, if summary.outline.NPSHa <0 then LinePattern.Solid else LinePattern.None))}), Diagram(graphics));
end PumpVLE_L1_simple;
