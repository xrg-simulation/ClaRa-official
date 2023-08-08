within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model QuadraticFrictionFlowAreaSymetric_TWV "| Quadratic Pressure Dependency | Flow Area Definition | Opening Characteristics | Symetrical |"
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Basic_TWV;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L1;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L2;
  import SI = ClaRa.Basics.Units;
  parameter Basics.Units.Area effectiveFlowArea1=7.85e-3 "Effective flow area for straight outlet" annotation (Dialog(group="Valve Characteristics"));
  parameter Basics.Units.Area effectiveFlowArea2=effectiveFlowArea1 "Effective flow area for shunt outlet" annotation (Dialog(group="Valve Characteristics"));
  parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
  parameter Basics.Units.Time Tau=0.001 "Time Constant of Stabilisation" annotation (Dialog(
      tab="Expert Settings",
      group="Numerical Robustness",
      enable=useStabilisedMassFlow));
  parameter Basics.Units.PressureDifference Delta_p_smooth=100 "Below this value, root function is approximated linearly" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

  Basics.Units.Pressure Delta_p[2](start={10,10}) "Pressure differences";
equation
//////////// Simple hydraulics: ///////////////////////////////
  if useStabilisedMassFlow==false then
    Delta_p[1] = iCom.p_in - iCom.p_out1;
    Delta_p[2] = iCom.p_in - iCom.p_out2;
  else
    der(Delta_p[1]) = (iCom.p_in - iCom.p_out1 - Delta_p[1])/Tau;
    der(Delta_p[2]) = (iCom.p_in - iCom.p_out2 - Delta_p[1])/Tau;
  end if;

  m_flow_1 = sqrt(2*iCom.rho_out1)*ClaRa.Basics.Functions.ThermoRoot(Delta_p[1], Delta_p_smooth)*(aperture_)*effectiveFlowArea1;
  m_flow_2 = sqrt(2*iCom.rho_out2)*ClaRa.Basics.Functions.ThermoRoot(Delta_p[2], Delta_p_smooth)*(1-aperture_)*effectiveFlowArea2;

initial equation
  if useStabilisedMassFlow then
    Delta_p[1] = iCom.p_in - iCom.p_out1;
    Delta_p[2] = iCom.p_in - iCom.p_out2;
  end if;
end QuadraticFrictionFlowAreaSymetric_TWV;
