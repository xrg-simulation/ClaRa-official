within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticNominalPoint_L4 "Medium independent || Nominal point, property independent"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4;

  //  outer ClaRa.Components.ComponentBaseClasses.Fundamentals2.PipeGeometry geo;

  parameter Modelica.SIunits.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=iCom.Delta_p_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";
protected
  Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_cv + 1] "Pressure loss coefficient for total pipe";

equation
  // Note that we want distribute zeta linearly over tha pipe length. Hence use zeta[i]=zeta_TOT*geo.Delta_x_FM[i]/(L -geo.Delta_x_FM[1]-geo.Delta_x_FM[N_cv+1] ) <-- notice that the last two terms depend on the flow model
  // for the homotopy equation we use a linear function depending on the nominal pressure difference and mass flow and the actual pressure difference.
  // Notice that we have to use the rugularised square root in order to allow for negative initial pressure losses!
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i]) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1])*Delta_p[i]) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1])*Delta_p[i]) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //frictionAtInlet and frictionAtOutlet
    for i in 1:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM));
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM))*Delta_p[i]) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;

  end if;

end QuadraticNominalPoint_L4;
