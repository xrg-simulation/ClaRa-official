within ClaRa.Components.TurboMachines.Fundamentals;
record IComPump_L1
  extends ClaRa.Basics.Icons.IComIcon;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium "Used medium model" annotation(Dialog(tab= "General"));
  SI.Power P_iso "Power for isentropic flow" annotation(Dialog(tab= "General"));
  SI.Pressure Delta_p "Pressure difference between pressure side and suction side"
                                                                                  annotation(Dialog(tab= "General"));
  SI.VolumeFlowRate V_flow "Volume flow" annotation(Dialog(tab= "General"));
  SI.RPM rpm "Rotational speed"
                               annotation(Dialog(tab= "General"));

  SI.Pressure Delta_p_max "Max. pressure difference at V_flow = 0 and rpm_nom"
                                                                              annotation(Dialog(tab= "Nominal"));
  SI.VolumeFlowRate V_flow_max "Max. flow at Delta_p = 0 and rpm_nom"
                                                                     annotation(Dialog(tab= "Nominal"));
  SI.RPM rpm_nom "nominal rotational speed"
                                           annotation(Dialog(tab= "Nominal"));

//____Inlet_____________________________________________________________________________
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointer fluidPointer_in "Pointer to inlet gas object" annotation(Dialog(tab="Inlet"));
  SI.Pressure p_in "Inlet pressure" annotation(Dialog(tab="Inlet"));
  SI.EnthalpyMassSpecific h_in "Inlet enthalpy" annotation(Dialog(tab="Inlet"));
  SI.MassFraction xi_in[medium.nc - 1] "Inlet medium composition" annotation(Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointer fluidPointer_out "Pointer to outlet gas object" annotation(Dialog(tab="Outlet"));
  SI.Pressure p_out "Outlet pressure" annotation(Dialog(tab="Outlet"));
  SI.EnthalpyMassSpecific h_out "Outlet enthalpy" annotation(Dialog(tab="Outlet"));
  SI.MassFraction xi_out[medium.nc - 1] "Outlet medium composition"  annotation(Dialog(tab="Outlet"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=true)), Diagram(coordinateSystem(preserveAspectRatio=true)));
end IComPump_L1;
