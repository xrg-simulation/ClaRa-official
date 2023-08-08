within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Ideal_L4 "Medium independent || Ideal HT"
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

  constant ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=Modelica.Constants.inf "Constant nominal heat transfer coefficient";

equation
  T_mean = iCom.T;
  heat.T = T_mean;

  annotation (Diagram(graphics));
end Ideal_L4;
