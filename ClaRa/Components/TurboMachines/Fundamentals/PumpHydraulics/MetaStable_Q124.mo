within ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics;
model MetaStable_Q124 "Metastable(d Delta_p/d V_flow) = 0 at V_flow = 0 | normal pumping, rev. turbining, dissipation mode "
  extends ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics;

  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  import szt = ClaRa.Basics.Functions.SmoothZeroTransition;

  parameter Real exp_hyd= 0.5 "Exponent for affinity law"
                                                         annotation(Dialog(group = "Characteristic Field",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpHydraulicsMetaStable124.png"));
  parameter Real drp_exp= 0 "Droop of exp_hyd w.r.t. rpm" annotation(Dialog(group = "Characteristic Field"));

  parameter Real K_rev = 0.75 "Correction term for reverse flow" annotation (Dialog(tab="Expert Settings", group = "Reverse Flow"));
  parameter Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));



  Basics.Units.Pressure Delta_p_zeroflowrpm "Maximum pressure difference at current speed";

protected
  Real K_ "=K_rev if revcerse flow, else 1";
//  Basics.Units.VolumeFlowRate V_flow_maxrpm "Max. volume flow at current rpm (deprecated)";
equation
//____________________ Affinity Laws _______________________

//  V_flow_maxrpm = iCom.V_flow_max*iCom.rpm/iCom.rpm_nom;
  Delta_p_zeroflowrpm = iCom.Delta_p_zeroflow*(iCom.rpm/iCom.rpm_nom)^2;
  K_ = szt(1, K_rev, (Delta_p_zeroflowrpm - iCom.Delta_p), Delta_p_eps);


  V_flow = K_*pow((Delta_p_zeroflowrpm - iCom.Delta_p)/iCom.Delta_p_zeroflow, Delta_p_eps/iCom.Delta_p_zeroflow, exp_hyd+drp_exp*(iCom.rpm-iCom.rpm_nom)) *(iCom.V_flow_zerohead);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end MetaStable_Q124;
