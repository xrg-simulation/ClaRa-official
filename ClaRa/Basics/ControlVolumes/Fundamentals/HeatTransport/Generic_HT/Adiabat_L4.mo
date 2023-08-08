within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Adiabat_L4 "Medium independent || No HT"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4;

  constant ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha=Modelica.Constants.small "Heat transfer coefficient";
  constant ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=0 "Constant nominal heat transfer coefficient";

equation
  T_mean = iCom.T;
  heat.Q_flow = zeros(iCom.N_cv);

  annotation (Diagram(graphics));
end Adiabat_L4;
