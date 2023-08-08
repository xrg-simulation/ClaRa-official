within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Adiabat_L3 "All geo || L3 || Adiabat"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L3;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  constant ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom[iCom.N_cv]=zeros(iCom.N_cv) "Constant nominal heat transfer coefficient || [1]:= liq | [2]:= vap ";
  constant ClaRa.Basics.Units.ThermalResistance HR_nom[iCom.N_cv]=ones(iCom.N_cv)*Modelica.Constants.inf "Nominal convective heat resistance";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv] "Heat transfer coefficient || [1]:= liq | [2]:= vap ";
  ClaRa.Basics.Units.ThermalResistance HR[iCom.N_cv] "Convective heat resistance";


equation
  heat.Q_flow = zeros(iCom.N_cv);
  alpha = ones(iCom.N_cv)*Modelica.Constants.small;
  HR = ones(iCom.N_cv)*Modelica.Constants.inf;
end Adiabat_L3;
