within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
model PressureLossCoeffcient_L2 "All geo || Quadratic pressure loss || constant pressure loss coefficient || density dependent "
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2;
  import TILMedia.Internals.VLEFluidObjectFunctions.density_phxi;
  import ClaRa.Basics.Functions.Stepsmoother;
protected
  ClaRa.Basics.Units.DensityMassSpecific rho_in "Density at inlet";
  ClaRa.Basics.Units.DensityMassSpecific rho_out "Density at outlet";

public
  ClaRa.Basics.Units.DensityMassSpecific rho=if useHomotopy then homotopy(Stepsmoother(
      10,
      -10,
      Delta_p)*rho_in + Stepsmoother(
      -10,
      10,
      Delta_p)*rho_out, rho_in) else Stepsmoother(
      10,
      -10,
      Delta_p)*rho_in + Stepsmoother(
      -10,
      10,
      Delta_p)*rho_out;

  parameter Units.Pressure Delta_p_smooth=100 "Start linearisation for decreasing pressure loss";
  parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient";
equation
  rho_in = density_phxi(
    iCom.p_in,
    iCom.h_in,
    iCom.xi_in,
    iCom.fluidPointer_in);
  rho_out = density_phxi(
    iCom.p_out,
    iCom.h_out,
    iCom.xi_out,
    iCom.fluidPointer_out);

  iCom.m_flow_in =  rho*geo.A_cross*
    Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower(
    Delta_p,
    Delta_p_smooth,
    0.5)/(0.5*zeta_TOT*rho)^0.5;


end PressureLossCoeffcient_L2;
