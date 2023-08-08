within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell2ph_L2 "Shell Geo, Horizontal Piping || L2 || HTC || Nusselt || 2ph"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;

  outer ClaRa.SimCenter simCenter;
//  outer parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

   import ClaRa.Basics.Functions.Stepsmoother;


  // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluidFunctions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluidFunctions.density_phxi;
  import fluidFunction_rho_bubble = TILMedia.VLEFluidFunctions.bubbleDensity_pxi;
  import fluidFunction_h_bubble = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidFunction_rho_dew = TILMedia.VLEFluidFunctions.dewDensity_pxi;
  import fluidFunction_h_dew = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi;
  import fluidFunction_T_dew = TILMedia.VLEFluidFunctions.dewTemperature_pxi;
  import fluidFunction_x = TILMedia.VLEFluidFunctions.steamMassFraction_phxi;

  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluidObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluidObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_x = TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi;
  import fluidObjectFunction_h_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidObjectFunction_cp_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificIsobaricHeatCapacity_pxi;
  import fluidObjectFunction_rho_bubble = TILMedia.VLEFluidObjectFunctions.bubbleDensity_pxi;
  import fluidObjectFunction_h_dew = TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi;
  import fluidObjectFunction_rho_dew = TILMedia.VLEFluidObjectFunctions.dewDensity_pxi;
  import fluidObjectFunction_T_dew = TILMedia.VLEFluidObjectFunctions.dewTemperature_pxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluidObjectFunctions.density_phxi;

protected
  Modelica.SIunits.ReynoldsNumber Re_1ph "Reynolds number for one phase";
  Modelica.SIunits.NusseltNumber Nu_1ph "Nusselt number one tube row for one phase";
  Modelica.SIunits.PrandtlNumber Pr_1ph "Prandtl number of fluid for one phase";
  Real failureStatus_1ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  Real alpha_1ph "HTC for single phase case";

  Modelica.SIunits.ReynoldsNumber Re_2ph "Reynolds number for one phase";
  Modelica.SIunits.NusseltNumber Nu_2ph "Nusselt number one tube row for one phase";
  Modelica.SIunits.PrandtlNumber Pr_2ph "Prandtl number of fluid for one phase";
  Real failureStatus_2ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  Real alpha_2ph "HTC for two phase case";
  parameter Real steamQuality_nom = TILMedia.VLEFluidFunctions.steamMassFraction_phxi(iCom.mediumModel, iCom.p_nom,iCom.h_nom,iCom.xi_nom);

//  Real smoother;
  SI.EnthalpyMassSpecific h_bubble=fluidObjectFunction_h_bubble(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
  SI.EnthalpyMassSpecific h_dew=fluidObjectFunction_h_dew(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
  Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom=if steamQuality_nom >= (1 - eps) or steamQuality_nom <= eps or heating_nom == true then Nu_B_nom*lambda_nom/L else alpha_2ph_nom;
//  constant Real Teps=1e-3;
  constant Real heps=1000;

public
  final parameter Real C=if geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                        annotation (Dialog(tab="General", group="Geometry"));
  parameter Boolean heating_nom=false "Ture, if nominal state implies heating, else fasle" annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  Real failureStatus;

protected
  Real MIN=1e-5 "Limiter";
  Real Nu_lam "Nusselt number of laminar flow, one tube";
  Real Nu_turb "Nusselt number of turbulent flow, one tube";
  Real Nu_B "Average Nusselt number of whole tube bundle";
  Real Pr_w "Prandtl number of fluid near wall";
  Real fa "Alignment factor";
  SI.Length L "Characteristic length";
  Real a "Longitudinal alignment ratio";
  Real b "Perpendicular alignment ratio";
  Real psi "Void ratio";
  Real K "Heat flow direction coefficient";
  Real Nu_lam_nom "Nusselt number of laminar flow, one tube";
  Real Nu_turb_nom  "Nusselt number of turbulent flow, one tube";
  Real Nu_nom  "Nusselt number one tube";
  Real Nu_B_nom  "Average Nusselt number of whole tube bundle";
  Real Re_nom  "Laminar Reynolds number one tube";
  Real Pr_w_nom  "Prandtl number of fluid near wall";
  Modelica.SIunits.PrandtlNumber Pr_nom "Prandtl number of fluid";
  Real K_nom "Heat flow direction coefficient";

  Real lambda=fluidObjectFunction_lambda(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real m_flow=noEvent(max(Modelica.Constants.eps, abs(iCom.m_flow_in)));
  Real lambda_w=if heat.T < (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - 1e-6) then lambda_w_nom else fluid_wall.transp.lambda;
   Real eta_w=if heat.T < (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - 1e-6) then eta_w_nom else fluid_wall.transp.eta;
  Real  cp=fluidObjectFunction_cp(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real rho=fluidObjectFunction_rho(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real eta=fluidObjectFunction_eta(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real cp_w=fluid_wall.cp;


  Real cp_w_nom=fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real  eta_w_nom=fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real  lambda_w_nom=fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real cp_nom = fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real eta_nom = fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real lambda_nom = fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
   Real rho_nom = fluidFunction_rho(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);


  Real Xi;
  Real G;
  Real Ph "Phase change number";
  Real Fr "Froude number";

  Real   cp_bub=fluidObjectFunction_cp_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   lambda_bub=fluidObjectFunction_lambda(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   rho_dew=fluidObjectFunction_rho_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   rho_bub=fluidObjectFunction_rho_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   eta_dew=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_dew(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   eta_bub=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
 Real    T_s=fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  Real   T_w=min(T_s - 1e-5, heat.T);
  Real  Delta_h_evap=max(1e-3, fluidObjectFunction_h_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out));

  Real Xi_nom;
  Real G_nom;
  Real Ph_nom "Phase change number";
  Real Pr_2ph_nom;
  Real Fr_nom "Froude number";
  Real Re_2ph_nom;
  Real alpha_2ph_nom "HTC for two phase case";
  Real m_flow_nom= iCom.m_flow_nom;

  TILMedia.VLEFluid_pT fluid_wall(
    T = heat.T,
    p = iCom.p_bulk,
    vleFluidType=iCom.mediumModel,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{80,80},{100,100}})));


   Real rho_dew_nom = TILMedia.VLEFluidFunctions.dewDensity_pxi(iCom.mediumModel, iCom.p_nom);
  Real rho_bub_nom = TILMedia.VLEFluidFunctions.bubbleDensity_pxi(iCom.mediumModel, iCom.p_nom);
  Real Delta_h_evap_nom = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom) - TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom);
  Real T_w_nom = if heating_nom then T_s + 5 else T_s - 5;
  Real T_s_nom = TILMedia.VLEFluidFunctions.dewTemperature_pxi(iCom.mediumModel, iCom.p_nom);
  Real cp_bub_nom = TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
          iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom));
  Real  lambda_bub_nom = TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom));
  Real eta_dew_nom = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom));
  Real eta_bub_nom = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(iCom.mediumModel, iCom.p_nom));


equation

//////////////////////////////////////////////////////////Calculation of HTC fpr 1phase case //////////////////////////////
  a= geo.Delta_z_ort/geo.diameter_t;
  b= geo.Delta_z_par/geo.diameter_t;
  // b<=0 refers to single row case!
  psi= if b >= 1 or b<=0 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b;
  L= Modelica.Constants.pi/2*geo.diameter_t;
  Re_1ph = abs(m_flow)/geo.A_front/rho*L/psi/eta*rho;
  Pr_1ph   = eta*cp/max(MIN,lambda);
  Pr_w   = eta_w*cp_w/max(MIN,lambda_w);
  Nu_lam = 0.664*sqrt(Re_1ph)*max(MIN,Pr_1ph)^(1/3);
  Nu_turb = (0.037*Re_1ph^0.8*Pr_1ph)/(1 + 2.443*max(MIN,Re_1ph)^(-0.1)*(max(MIN,Pr_1ph)^(2/3) - 1));
  K = if Pr_1ph/Pr_w > 1 then (max(MIN,Pr_1ph/Pr_w))^0.25 else (max(MIN,Pr_1ph/Pr_w))^0.11;
  Nu_1ph = K*(0.3 + sqrt((Nu_lam^2 + Nu_turb^2)));
  if geo.staggeredAlignment then
    fa =  1 + (if b>0 then 2/3/b else 0);
  else
    fa =  1 + (if b>0 then 0.7/psi^1.5*(b/a - 0.3)/(b/a + 0.7)^2 else 0);
  end if;
  Nu_B =  Nu_1ph*(if geo.N_rows>=10 then fa else (((geo.N_rows-1)*fa+1)/geo.N_rows));

  alpha_1ph =  if useHomotopy then homotopy(Nu_B*lambda/L, alpha_nom) else Nu_B*lambda/L;
  failureStatus_1ph =  if (Re_1ph<10e6 and Re_1ph>10) and (Pr_1ph<10e3 and Pr_1ph>0.6)  then 0 else 1;
// end of calculation of single phase heat transfer coefficient

//calculation of NOMINAL single phase heat transfer coefficient:
  Re_nom = abs(iCom.m_flow_nom)/geo.A_front/rho*L/psi/eta*rho_nom;
  Pr_nom   = eta*cp/max(MIN,lambda_nom);
  Pr_w_nom   = eta_w_nom*cp_w_nom/max(MIN,lambda_w_nom);
  Nu_lam_nom = 0.664*sqrt(Re_nom)*max(MIN,Pr_nom)^(1/3);
  Nu_turb_nom = (0.037*Re_nom^0.8*Pr_nom)/(1 + 2.443*max(MIN,Re_nom)^(-0.1)*(max(MIN,Pr_nom)^(2/3) - 1));
  K_nom = if Pr_nom/Pr_w_nom > 1 then (max(MIN,Pr_nom/Pr_w_nom))^0.25 else (max(MIN,Pr_nom/Pr_w_nom))^0.11;
  Nu_nom = K_nom*(0.3 + sqrt((Nu_lam_nom^2 + Nu_turb_nom^2)));
  Nu_B_nom =  Nu_nom*(if geo.N_rows>=10 then fa else (((geo.N_rows-1)*fa+1)/geo.N_rows));
  //alpha_nom = Nu_B_nom*lambda_nom/L;
////////////////////////////////////////////////////////// end of calculation of single phase heat transfer coefficient////////

////////////////////////////////////////////////////////// Calculation of two phase HTC ///////////////////////////////////////
  Ph    = cp_bub*(T_s - T_w)/Delta_h_evap;
  Pr_2ph    = eta_bub*cp_bub/lambda_bub;
  G     = Ph/Pr_2ph*(rho_bub*eta_bub/(rho_dew*eta_dew))^0.5;
  Xi    = 0.9*(1 + 1/G)^(1/3);
  // According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter "d" instead of characteristic length of film flow "L" = (eta_liq^2/rho_liq^2/g)^(1/3).
  Re_2ph = abs(m_flow)/geo.A_front/rho_dew*geo.diameter_t/(eta_bub/rho_bub);
  Fr    = (max(Modelica.Constants.eps, abs(m_flow))/geo.A_front/rho_dew)^2/Modelica.Constants.g_n/geo.diameter_t;

  alpha_2ph = lambda_bub/geo.diameter_t*C*Xi*(1 + (0.276*Pr_2ph)/(Xi^4*Fr*Ph))^0.25* sqrt(Re_2ph);
  Nu_2ph =  alpha_2ph*geo.diameter_t/lambda_bub;
  failureStatus_2ph =  if Re_2ph<5e5 then 1 else 0
    "The greater the steam velocity (Re), the better the accuracy | for Re>5e5 the deviation is below 5%";

//////////////NOMINAL 2phase HTC: ///////////
  Ph_nom    = cp_bub_nom*(T_s_nom - T_w_nom)/Delta_h_evap_nom;
  Pr_2ph_nom    = eta_bub_nom*cp_bub_nom/lambda_bub_nom;
  G_nom     = Ph_nom/Pr_2ph_nom*(rho_bub_nom*eta_bub_nom/(rho_dew_nom*eta_dew_nom))^0.5;
  Xi_nom    = 0.9*(1 + 1/G_nom)^(1/3);
  // According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter "d" instead of characteristic length of film flow "L" = (eta_liq^2/rho_liq^2/g)^(1/3).
  Re_2ph_nom = abs(m_flow_nom)/geo.A_front/rho_dew_nom*geo.diameter_t/(eta_bub_nom/rho_bub_nom);
  Fr_nom    = (max(Modelica.Constants.eps, abs(m_flow_nom))/geo.A_front/rho_dew_nom)^2/Modelica.Constants.g_n/geo.diameter_t;

  alpha_2ph_nom = lambda_bub_nom/geo.diameter_t*C*Xi_nom*(1 + (0.276*Pr_2ph_nom)/(Xi_nom^4*Fr_nom*Ph_nom))^0.25* sqrt(Re_2ph_nom);
//////////////////////////////////////////////////////end of Calculation of two phase HTC /////////////////////////////////////

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

  // defining the HTC for a shell area, either heated or cooled flow supporting laminar film condensation and one phase heat transfer. Evaporation is NOT supported

  //alpha = smoother*alpha_2ph + (1 - smoother)*alpha_1ph;
  alpha = Stepsmoother(h_bubble, h_bubble + heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_dew, h_dew - heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_bubble + heps, h_bubble, iCom.h_out)*Stepsmoother(h_dew - heps, h_dew, iCom.h_out)*alpha_2ph;
  failureStatus = if iCom.h_out > h_bubble and iCom.h_out < h_dew then failureStatus_2ph else failureStatus_1ph;

  annotation (Icon(graphics));
end NusseltShell2ph_L2;
