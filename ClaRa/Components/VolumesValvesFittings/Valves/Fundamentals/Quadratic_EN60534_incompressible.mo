within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_EN60534_incompressible "Quadratic | Kv definition | choked flow | incompressible |EN60534"

  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible_base;
equation
  flowIsChoked=SM(Delta_p_choke+100,Delta_p_choke-100,abs(Delta_p)) "1 if flow is choked, 0 if not";
  PR_choked=(-1*(Delta_p_choke-p_in))/p_in "Pressure ratio at which choking occurs";

  m_flow =  if checkValve then if useHomotopy then homotopy(SM(Delta_p_eps/10,0, Delta_p) * 1/3600*0.1*Kv*F_P*ClaRa.Basics.Functions.ThermoRoot(sign(Delta_p)*min(abs(Delta_p),abs(Delta_p_choke)), Delta_p_eps)*sqrt(iCom.rho_in), aperture_*m_flow_nominal)
                                       else SM(Delta_p_eps/10,0, Delta_p)*1/3600*0.1*Kv*F_P*
    ClaRa.Basics.Functions.ThermoRoot(sign(Delta_p)*min(abs(Delta_p),abs(Delta_p_choke)), Delta_p_eps)*sqrt(iCom.rho_in) else if useHomotopy then homotopy(1/3600*0.1*Kv*F_P*ClaRa.Basics.Functions.ThermoRoot(sign(Delta_p)*min(abs(Delta_p),abs(Delta_p_choke)), Delta_p_eps)*sqrt(iCom.rho_in), aperture_*m_flow_nominal)
                                       else 1/3600*0.1*Kv*F_P*
    ClaRa.Basics.Functions.ThermoRoot(sign(Delta_p)*min(abs(Delta_p),abs(Delta_p_choke)), Delta_p_eps)*sqrt(iCom.rho_in);

end Quadratic_EN60534_incompressible;
