within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL;
model QuadraticNominalPoint_L4 "Gas || Quadratic PL based on nominal values"
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
  import TILMedia.GasObjectFunctions.density_phxi;
  import Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom=TILMedia.GasFunctions.density_phxi(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.PressureLoss_L4;
//  Basics.Units.DensityMassSpecific rho[iCom.N_cv + 1] "Density in FlowModel cells";

  parameter SI.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";
  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=geo.A_cross_FM[1]^2*2*iCom.Delta_p_nom*rho_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";

  Basics.Units.DensityMassSpecific rho[iCom.N_cv + 1] "Density in FlowModel cells";
protected
  Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_cv + 1] "Pressure loss coefficient for total pipe";

equation
  /////// Calcultae Media Data Required //////////////////
  rho[2:geo.N_cv] = {smooth(1, noEvent(max(1e-6, if m_flow[i] > 0 then density_phxi(
    iCom.p[i - 1],
    iCom.h[i - 1],
    iCom.xi[i - 1, :],
    iCom.fluidPointer[i - 1]) else density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i])))) for i in 2:iCom.N_cv};
  rho[1] = smooth(1, noEvent(max(1e-6, if m_flow[1] > 0 then density_phxi(
    iCom.p_in[1],
    iCom.h_in[1],
    iCom.xi_in[1, :],
    iCom.fluidPointer_in[1]) else density_phxi(
    iCom.p[1],
    iCom.h[1],
    iCom.xi[1, :],
    iCom.fluidPointer[1]))));
  rho[geo.N_cv + 1] = smooth(1, noEvent(max(1e-6, if m_flow[geo.N_cv + 1] > 0 then density_phxi(
    iCom.p_in[end],
    iCom.h_in[end],
    iCom.xi_in[end, :],
    iCom.fluidPointer_in[end]) else density_phxi(
    iCom.p_out[1],
    iCom.h_out[1],
    iCom.xi_out[1, :],
    iCom.fluidPointer_out[1]))));

  ////// Calculate Pressure Losses ////////////////////
  // Note that we want distribute zeta linearly over tha pipe length. Hence use zeta[i]=zeta_TOT*geo.Delta_x_FM[i]/(L -geo.Delta_x_FM[1]-geo.Delta_x_FM[N_cv+1] ) <-- notice that the last two terms depend on the flow model
  // for the homotopy equation we use the dp_pressureLossCoefficient_MFLOW function, linearised about the initial pressure difference.
  // Notice that we have to use the rugularised square root in order to allow for negative initial pressure losses!
  // Simplified homotopy eaution based on linear, density independent corellation, passing the m_flow=0 at Delat_p=0
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i])
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i])
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM)  - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i])
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //frictionAtInlet and frictionAtOutlet
    for i in 1:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM));
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           (iCom.m_flow_nom/iCom.Delta_p_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM))*Delta_p[i])
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
  end if;

end QuadraticNominalPoint_L4;
