within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_EN60534_compressible "Quadratic | Kv definition | choked flow | compressible |EN60534"

  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_base;
equation
  PR_choked=(-1*(Delta_p_choke-p_in))/p_in "Pressure ratio at which choking occurs";
  flowIsChoked=SM(x_TChoked*p_in+100,x_TChoked*p_in-100,abs(Delta_p)) "1 if flow is choked, 0 if not";

      m_flow = if checkValve then if useHomotopy then homotopy(SM(Delta_p_eps/10,0, Delta_p) *1/3600*0.1*Kv*F_P*Y*ClaRa.Basics.Functions.ThermoRoot(Delta_p_actual, Delta_p_eps)*sqrt(max(Modelica.Constants.eps,iCom.rho_in)), aperture_*m_flow_nom)
 else
     SM(Delta_p_eps/10,0, Delta_p) * 1/3600*0.1*Kv*F_P*Y*
    ClaRa.Basics.Functions.ThermoRoot(Delta_p_actual, Delta_p_eps)*sqrt(max(Modelica.Constants.eps,iCom.rho_in)) else if useHomotopy then homotopy(1/3600*0.1*Kv*F_P*Y*ClaRa.Basics.Functions.ThermoRoot(Delta_p_actual, Delta_p_eps)*sqrt(max(Modelica.Constants.eps,iCom.rho_in)), aperture_*m_flow_nom)
                                       else 1/3600*0.1*Kv*F_P*Y*
    ClaRa.Basics.Functions.ThermoRoot(Delta_p_actual, Delta_p_eps)*sqrt(max(Modelica.Constants.eps,iCom.rho_in));

end Quadratic_EN60534_compressible;
