within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model LinearParallelZones_L3 "All geo | L3 | linear | parallel zones | nominal point"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3(final hasPressureLoss=true);

  parameter Units.Pressure Delta_p_nom[iCom.N_inlet]=ones(iCom.N_inlet)*1000 "Nominal ressure loss";
  parameter Real CF_backflow=1 "Enhancement factor for reverse flow pressure loss";
  //   ClaRa.Basics.Units.PressureDifference Delta_p[iCom.N_inlet]
  //     "Pressure difference du to friction";

equation
  //Delta_p = Delta_p_nom./iCom.m_flow_nom.*iCom.m_flow_in;
  iCom.m_flow_in = {semiLinear(
    Delta_p[i]/Delta_p_nom[i],
    1,
    CF_backflow)*iCom.m_flow_nom for i in 1:iCom.N_inlet};
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end LinearParallelZones_L3;
