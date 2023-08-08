within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L1_affinity "A pump for VLE mixtures based on affinity laws"
  import ClaRa;
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

//   import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
//   import SM = ClaRa.Basics.Functions.Stepsmoother;
//   import Modelica.Constants.pi;
//   import TILMedia.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.PumpVLE_affinityBase;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  import Modelica.Constants.pi;
  import TILMedia.VLEFluidObjectFunctions.bubblePressure_Txi;
  Real mult_eta "1/eta if pump mode else eta (turbine mode)";

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeVLE           inlet;
   ClaRa.Basics.Records.FlangeVLE           outlet;
 end Summary;

public
   Summary summary(
     outline(
       rpm=rpm,
       V_flow=iCom.V_flow,
       P_iso=P_iso,
       P_fluid =  P_iso + losses.P_loss,
       P_shaft = getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60,
       Delta_p=Delta_p,
       head= Delta_p/(fluidIn.d*Modelica.Constants.g_n),
       NPSHa = (inlet.p - bubblePressure_Txi(fluidIn.T, fluidIn.xi, fluidIn.vleFluidPointer))/(fluidIn.d*Modelica.Constants.g_n),
       eta_hyd= losses.eta,
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
equation

//____________________ Balance equations ___________________

  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p = outlet.p - inlet.p "Momentum balance";
  //outlet.h_outflow = SM(2*Delta_p_eps,Delta_p_eps, Delta_p)* SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p)*(h_iso_out - h_iso_in)/eta_hyd +  h_iso_in "Application of eta_hyd's definition";
  mult_eta = noEvent(if iCom.Delta_p> 0 then 1/losses.eta else losses.eta);
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
