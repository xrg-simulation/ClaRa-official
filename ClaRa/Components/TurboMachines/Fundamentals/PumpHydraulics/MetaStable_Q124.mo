within ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics;
model MetaStable_Q124 "Metastable(d Delta_p/d V_flow) = 0 at V_flow = 0 | normal pumping, rev. turbining, dissipation mode "
  extends ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics;

  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;

  parameter Real exp_hyd= 0.5 "Exponent for affinity law"
                                                         annotation(Dialog(group = "Characteristic Field",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpHydraulicsMetaStable124.png"));
  parameter Real drp_exp= 0 "Droop of exp_hyd w.r.t. rpm" annotation(Dialog(group = "Characteristic Field"));

  parameter Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

  Basics.Units.VolumeFlowRate V_flow_maxrpm "Max. volume flow at current rpm";
  Basics.Units.Pressure Delta_p_maxrpm "Maximum pressure difference at current speed";
equation
//____________________ Affinity Laws _______________________

  V_flow_maxrpm = iCom.V_flow_max*iCom.rpm/iCom.rpm_nom;
  Delta_p_maxrpm = iCom.Delta_p_max*(iCom.rpm/iCom.rpm_nom)^2;

  V_flow = pow((Delta_p_maxrpm - iCom.Delta_p)/iCom.Delta_p_max, Delta_p_eps/iCom.Delta_p_max, exp_hyd+drp_exp*(iCom.rpm-iCom.rpm_nom))*(iCom.V_flow_max);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end MetaStable_Q124;
