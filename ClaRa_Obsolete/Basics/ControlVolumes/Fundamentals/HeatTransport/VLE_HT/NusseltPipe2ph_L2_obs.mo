within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltPipe2ph_L2_obs "Pipe Geo || L2 || HTC || Nusselt || 2ph || obsolete"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.2.2                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
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
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends Icons.Obsolete_v1_2;

  outer ClaRa.SimCenter simCenter;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry geo;
  import FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC;
  import FluidDissipation.HeatTransfer.StraightPipe.kc_overall;
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

  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(group="Nominal Values"));
protected
  constant Real heps=1000;
//  parameter SI.CoefficientOfHeatTransfer alpha_nom=(if inVar_2ph_nom.x_flow >= (1 - eps) or inVar_2ph_nom.x_flow <= 1e-3 then min(10e2*inVar_1ph_nom.lambda/inCon_1ph.d_hyd, kc_overall(inCon_1ph, inVar_1ph_nom)) else kc_twoPhaseOverall_KC(inCon_2ph, inVar_2ph_nom));
//   parameter SI.CoefficientOfHeatTransfer alpha_nom=(if inVar_2ph_nom.x_flow >= (1 - eps) or inVar_2ph_nom.x_flow <= 1e-3 then kc_overall(inCon_1ph, inVar_1ph_nom) else kc_twoPhaseOverall_KC(inCon_2ph, inVar_2ph_nom));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=kc_overall(inCon_1ph, inVar_1ph_nom);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_bubble=fluidObjectFunction_h_bubble(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_dew=fluidObjectFunction_h_dew(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
public
  parameter FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget HTModel = FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor "Type of two-phase heat transfer"
                                                                                        annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, group="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha(start=alpha_nom) "Heat transfer coefficient used for heat transfer calculation";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_1ph "Heat transfer coefficient for single phase case";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_2ph "Heat transfer coefficient for two phase case";
  Real Pr "Prandtl number";
  Real Re "Reynolds number";
  Real Fr_l "Froude number";

  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var inVar_2ph_nom(
    target=HTModel,
    m_flow=noEvent(max(0.0000001, abs(sum(iCom.m_flow_nom))/geo.N_tubes)),
    qdot_A=(Modelica.Constants.eps
                + Q_flow_nom)/geo.A_heat_CF[heatSurfaceAlloc],
    x_flow=fluidFunction_x(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    pressure=iCom.p_nom,
    rho_g=fluidFunction_rho_dew(iCom.mediumModel, iCom.p_nom),
    rho_l=fluidFunction_rho_bubble(iCom.mediumModel, iCom.p_nom),
    dh_lg=fluidFunction_h_dew(iCom.mediumModel, iCom.p_nom) - fluidFunction_h_bubble(iCom.mediumModel, iCom.p_nom),
    cp_l=fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        fluidFunction_h_bubble(iCom.mediumModel, iCom.p_nom)),
    lambda_l=fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        fluidFunction_h_bubble(iCom.mediumModel, iCom.p_nom)),
    eta_g=fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        fluidFunction_h_dew(iCom.mediumModel, iCom.p_nom)),
    eta_l=fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        fluidFunction_h_bubble(iCom.mediumModel, iCom.p_nom))) annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_con inCon_2ph(
    target=HTModel,
    p_crit=TILMedia.VLEFluidFunctions.criticalPressure_xi(iCom.mediumModel),
    A_cross=geo.A_cross,
    perimeter=geo.A_heat_CF[heatSurfaceAlloc]/geo.length*geo.N_passes/geo.N_tubes,
    MM=TILMedia.VLEFluidFunctions.averageMolarMass_xi(iCom.mediumModel)*1000)
                                                                      annotation (Placement(transformation(extent={{-14,-100},{6,-80}})));
  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con inCon_1ph(
    d_hyd=geo.diameter,
    L=geo.length*geo.N_passes,
    roughness=FluidDissipation.Utilities.Types.Roughness.Neglected) annotation (Placement(transformation(extent={{34,-100},{54,-80}})));
  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var inVar_2ph(
    target=HTModel,
    rho_g=fluidObjectFunction_rho_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    rho_l=fluidObjectFunction_rho_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    dh_lg=fluidObjectFunction_h_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    m_flow=noEvent(max(0.0000001, abs(iCom.m_flow_in/geo.N_tubes))),
    qdot_A=(Modelica.Constants.eps
                + heat.Q_flow)/geo.A_heat_CF[heatSurfaceAlloc],
    cp_l=fluidObjectFunction_cp_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    lambda_l=fluidObjectFunction_lambda(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    eta_g=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_dew(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    eta_l=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
          iCom.p_out,
          iCom.xi_out,
          iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out),
    pressure=iCom.p_bulk,
    x_flow=min(1 - 1e-6, max(1e-6, fluidObjectFunction_x(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out)))) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var inVar_1ph_nom(
    cp=fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    eta=fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    lambda=fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    rho=fluidFunction_rho(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom),
    m_flow=abs(iCom.m_flow_nom/geo.N_tubes)) annotation (Placement(transformation(extent={{62,-60},{82,-40}})));
  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var inVar_1ph(
    cp=fluidObjectFunction_cp(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    lambda=fluidObjectFunction_lambda(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    rho=fluidObjectFunction_rho(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
    m_flow=noEvent(max(0.0000001, abs(iCom.m_flow_in/geo.N_tubes))),
    eta=fluidObjectFunction_eta(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out)) annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
equation
  Re = 4*inVar_1ph.m_flow/inCon_1ph.d_hyd/Modelica.Constants.pi/inVar_1ph.eta;
  Pr = 1;
  Fr_l= (inVar_2ph.m_flow/inCon_2ph.A_cross)/(inVar_2ph.rho_l^2*9.81*geo.diameter);

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

  alpha_1ph = if useHomotopy then homotopy(kc_overall(inCon_1ph, inVar_1ph), alpha_nom*abs(sum(inVar_2ph.m_flow))/sum(iCom.m_flow_nom)) else kc_overall(inCon_1ph, inVar_1ph);
  alpha_2ph = if useHomotopy then homotopy(min(1e6, kc_twoPhaseOverall_KC(inCon_2ph, inVar_2ph)), alpha_nom*abs(sum(inVar_2ph.m_flow))/sum(iCom.m_flow_nom)) else min(1e6, kc_twoPhaseOverall_KC(inCon_2ph, inVar_2ph));

  // defining the HTC for a straight pipe for both, one-phase and two-phase flow:
  alpha = Stepsmoother(h_bubble, h_bubble + heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_dew, h_dew - heps, iCom.h_out)*alpha_1ph
        + Stepsmoother(h_bubble + heps, h_bubble, iCom.h_out)*Stepsmoother(h_dew - heps, h_dew, iCom.h_out)*alpha_2ph;

end NusseltPipe2ph_L2_obs;
