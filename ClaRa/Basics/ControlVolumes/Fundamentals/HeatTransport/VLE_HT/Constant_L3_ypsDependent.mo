within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model Constant_L3_ypsDependent "All geo || L3 || HTC || depending on volume fraction || 2ph"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.4.0                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3;

  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransferVLE_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L3;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom[iCom.N_cv]=ones(iCom.N_cv)*10 "Constant heat transfer coefficient || [1]:= liq | [2]:= vap " annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom[iCom.N_cv]=1 ./ (alpha_nom .* geo.A_heat_CF[heatSurfaceAlloc]) "Nominal convective heat resistance";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv];
  ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Sum of zonal heat flows";
  ClaRa.Basics.Units.ThermalResistance HR[iCom.N_cv] "Convective heat resistance";


equation
  heat.Q_flow = alpha .* geo.A_heat_CF[heatSurfaceAlloc] .* iCom.volume ./ geo.volume .* (heat.T - iCom.T);
  Q_flow_tot = sum(heat.Q_flow);
  alpha = alpha_nom;
  HR[1] = 1 / max(Modelica.Constants.eps,alpha[1]* geo.A_heat_CF[heatSurfaceAlloc]);
  HR[2] = 1 / max(Modelica.Constants.eps,alpha[2]* geo.A_heat_CF[heatSurfaceAlloc]);
end Constant_L3_ypsDependent;
