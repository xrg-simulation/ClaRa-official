within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Constant_L4 "Medium independent || Constant HTC"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.0                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4;
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv];


equation

  T_mean = iCom.T;
  heat.Q_flow = alpha .* A_heat .* (heat.T - T_mean);
  for i in 1:iCom.N_cv loop
    alpha[i] = alpha_nom;
  end for;

end Constant_L4;
