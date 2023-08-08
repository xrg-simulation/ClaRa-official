within ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency;
model RayCorrelation "Semi-empirical correlation | Shaft speed and isentropic enthalpy drop dependent"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                        //
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

//The model is described in Asok Ray: "Dynamic Modelling of Power Plant Turbines for Controller Design" in Appl. Math. Modelling, 1980, Vol.4, pages 109-112.
  extends ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.EfficiencyModelBase;
 parameter Real eta_nom=0.94 "Isentropic efficiency at nominal load";
 parameter Real C_load=2 "Form factor for load dependency";
  parameter Basics.Units.RPM rpm_nom=3000 "Nominal shaft speed";
  parameter Basics.Units.EnthalpyMassSpecific Delta_h_is_nom=250e3 "Nominal isentropic enthalpy drop";
     Real eta "Efficiency";

equation
    eta=eta_nom-C_load*(iCom.rpm/sqrt(iCom.Delta_h_is)/(rpm_nom/sqrt(Delta_h_is_nom))-1)^2;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end RayCorrelation;
