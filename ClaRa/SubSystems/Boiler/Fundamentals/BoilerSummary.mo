within ClaRa.SubSystems.Boiler.Fundamentals;
record BoilerSummary "A summary for boilers - takes only the water steam side at the connectors into account"
  extends ClaRa.Basics.Icons.RecordIcon;

   Modelica.SIunits.Pressure p_feed "Feedwater inlet pressure" annotation(Dialog(group="Feedwater"));
   Modelica.SIunits.SpecificEnthalpy h_feed "Feedwater inlet specific enthalpy"
                                       annotation(Dialog(group="Feedwater"));
   Modelica.SIunits.MassFlowRate m_flow_feed "Feedwater inlet mass flow"
                                                                        annotation(Dialog(group="Feedwater"));

   Modelica.SIunits.Pressure p_LS "Live steam pressure"
                                                       annotation(Dialog(group="Live steam"));
   Modelica.SIunits.SpecificEnthalpy h_LS "Live steam specific enthalpy"
                                                                        annotation(Dialog(group="Live steam"));
   Modelica.SIunits.MassFlowRate m_flow_LS "Live steam mass flow"
                                                                 annotation(Dialog(group="Live steam"));

   Modelica.SIunits.Pressure p_cRH "Cold reheat pressure"
                                                         annotation(Dialog(group="Cold Reheat"));
   Modelica.SIunits.SpecificEnthalpy h_cRH "Cold reheat specific enthalpy" annotation(Dialog(group="Cold Reheat"));
   Modelica.SIunits.MassFlowRate m_flow_cRH "Cold reheat mass flow"
                                                                   annotation(Dialog(group="Cold Reheat"));

   Modelica.SIunits.Pressure p_hRH "Hot reheat pressure"
                                                        annotation(Dialog(group="Hot Reheat"));
   Modelica.SIunits.SpecificEnthalpy h_hRH "Hot reheat specific enthalpy"
                                                                         annotation(Dialog(group="Hot Reheat"));
   Modelica.SIunits.MassFlowRate m_flow_hRH "Hot reheat mass flow"
                                                                  annotation(Dialog(group="Hot Reheat"));

end BoilerSummary;
