within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell1ph_L2 "Shell Geo || L2 || HTC || Nusselt || 1ph"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;

  outer ClaRa.SimCenter simCenter;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
  Modelica.SIunits.NusseltNumber Nu "Nusselt number one tube row";
  Modelica.SIunits.PrandtlNumber Pr "Prandtl number of fluid";
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

  Real lambda=fluidObjectFunction_lambda( iCom.p_out, iCom.h_out, iCom.xi_out, iCom.fluidPointer_out);
  Real m_flow=noEvent(max(Modelica.Constants.eps, abs(iCom.m_flow_in)));
  Real lambda_w=if heat.T < (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - 1e-6) then lambda_w_nom else fluid_wall.transp.lambda;
   Real eta_w=if heat.T < (fluidObjectFunction_T_dew(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out) - 1e-6) then eta_w_nom else fluid_wall.transp.eta;
  Real  cp=fluidObjectFunction_cp(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out);
  Real rho=fluidObjectFunction_rho(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out);
  Real eta=fluidObjectFunction_eta(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out);
  Real cp_w=fluid_wall.cp;

   Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom;
  TILMedia.VLEFluid_pT fluid_wall(
    T=heat.T,
    p=iCom.p_bulk,
    vleFluidType=iCom.mediumModel,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{70,70},{90,90}})));

  final parameter  Real cp_w_nom=fluidFunction_cp(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom);
  final parameter  Real  eta_w_nom=fluidFunction_eta(iCom.mediumModel,iCom.p_nom, iCom.h_nom, iCom.xi_nom);
  final parameter  Real  lambda_w_nom=fluidFunction_lambda( iCom.mediumModel, iCom.p_nom,iCom.h_nom, iCom.xi_nom);
  final parameter  Real cp_nom = fluidFunction_cp( iCom.mediumModel,iCom.p_nom, iCom.h_nom,iCom.xi_nom);
  final parameter  Real eta_nom = fluidFunction_eta( iCom.mediumModel, iCom.p_nom, iCom.h_nom,iCom.xi_nom);
  final parameter  Real lambda_nom = fluidFunction_lambda( iCom.mediumModel, iCom.p_nom, iCom.h_nom, iCom.xi_nom);
  final parameter  Real rho_nom = fluidFunction_rho(iCom.mediumModel,iCom.p_nom,iCom.h_nom, iCom.xi_nom);
public
  final parameter Real C=if geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                        annotation (Dialog(tab="General", group="Geometry"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  Modelica.SIunits.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";


equation

//calculation of heat transfer coefficient: // defining the HTC for a shell area, either heated or cooled ONE-PHASE flow. Evaporation and condensation are NOT supported
  a= geo.Delta_z_ort/geo.diameter_t;
  b= geo.Delta_z_par/geo.diameter_t;
  // b<=0 refers to single row case!
  psi= if b >= 1 or b<=0 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b;
  L= Modelica.Constants.pi/2*geo.diameter_t;
  Re = abs(m_flow)/geo.A_front/rho*L/psi/eta*rho;
  Pr   = eta*cp/max(MIN,lambda);
  Pr_w   = eta_w*cp_w/max(MIN,lambda_w);
  Nu_lam = 0.664*sqrt(Re)*max(MIN,Pr)^(1/3);
  Nu_turb = (0.037*Re^0.8*Pr)/(1 + 2.443*max(MIN,Re)^(-0.1)*(max(MIN,Pr)^(2/3) - 1));
  K = if Pr/Pr_w > 1 then (max(MIN,Pr/Pr_w))^0.25 else (max(MIN,Pr/Pr_w))^0.11;
  Nu = K*(0.3 + sqrt((Nu_lam^2 + Nu_turb^2)));
  if geo.staggeredAlignment then
    fa =  1 + (if b>0 then 2/3/b else 0);
  else
    fa =  1 + (if b>0 then 0.7/psi^1.5*(b/a - 0.3)/(b/a + 0.7)^2 else 0);
  end if;
  Nu_B =  Nu*(if geo.N_rows>=10 then fa else (((geo.N_rows-1)*fa+1)/geo.N_rows));

  alpha =  if useHomotopy then homotopy(Nu_B*lambda/L, alpha_nom) else Nu_B*lambda/L;
  failureStatus =  if (Re<10e6 and Re>10) and (Pr<10e3 and Pr>0.6)  then 0 else 1;
// end of calculation of heat transfer coefficient

//calculation of NOMINAL heat transfer coefficient:
  Re_nom = abs(iCom.m_flow_nom)/geo.A_front/rho*L/psi/eta*rho_nom;
  Pr_nom   = eta*cp/max(MIN,lambda_nom);
  Pr_w_nom   = eta_w_nom*cp_w_nom/max(MIN,lambda_w_nom);
  Nu_lam_nom = 0.664*sqrt(Re_nom)*max(MIN,Pr_nom)^(1/3);
  Nu_turb_nom = (0.037*Re_nom^0.8*Pr_nom)/(1 + 2.443*max(MIN,Re_nom)^(-0.1)*(max(MIN,Pr_nom)^(2/3) - 1));
  K_nom = if Pr_nom/Pr_w_nom > 1 then (max(MIN,Pr_nom/Pr_w_nom))^0.25 else (max(MIN,Pr_nom/Pr_w_nom))^0.11;
  Nu_nom = K_nom*(0.3 + sqrt((Nu_lam_nom^2 + Nu_turb_nom^2)));
  Nu_B_nom =  Nu_nom*(if geo.N_rows>=10 then fa else (((geo.N_rows-1)*fa+1)/geo.N_rows));
  alpha_nom = Nu_B_nom*lambda_nom/L;
// end of calculation of heat transfer coefficient

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;


  annotation (Icon(graphics), Diagram(graphics));
end NusseltShell1ph_L2;
