within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model LinearPressureLoss_L4 "Medium independent || Linear PL with const. PL coeff"
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

  import SI = ClaRa.Basics.Units;

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4;
  final parameter ClaRa.Basics.Units.Length length=sum(geo.Delta_x);
equation
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]));
    end for;
    Delta_p[1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[1]));
    end for;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[iCom.N_cv + 1]));
    end for;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //FlowModel=FlowModelStructure.inlet_dp_innerPipe_dp_outlet
    for i in 1:iCom.N_cv + 1 loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/length);
    end for;

  end if;

end LinearPressureLoss_L4;
