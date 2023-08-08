within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticParallelZones_L3 "All geo | L3 | quadratic | parallel zones | nominal point"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3;

  parameter SI.Pressure Delta_p_nom[iCom.N_inlet]=ones(iCom.N_inlet)*1000 "Nominal ressure loss";
  parameter SI.PressureDifference Delta_p_smooth=100 "Small pressure difference for linearisation around zero mass flow";
  parameter Real CF_backflow=1 "Enhancement factor for reverse flow pressure loss";
  //   SI.PressureDifference Delta_p[iCom.N_inlet]
  //     "Pressure difference du to friction";

  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_inlet]=Delta_p_nom ./ iCom.m_flow_nom;
equation
  //   iCom.m_flow_in = {semiLinear(ClaRa.Basics.Functions.ThermoRoot(Delta_p[i]/Delta_p_nom[i], Delta_p_smooth/Delta_p_nom[i]), 1, CF_backflow)*sqrt(1/zeta[i]) for i in 1:iCom.N_inlet};
  iCom.m_flow_in = {homotopy(iCom.m_flow_nom*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i]/Delta_p_nom[i], Delta_p_smooth/Delta_p_nom[i]), iCom.m_flow_nom/Delta_p_nom[i]*Delta_p[i]) for i in 1:iCom.N_inlet};

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end QuadraticParallelZones_L3;
