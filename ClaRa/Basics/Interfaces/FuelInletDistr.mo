within ClaRa.Basics.Interfaces;
connector FuelInletDistr
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

  extends ClaRa.Basics.Interfaces.Fuel_inlet;
                     // p, m_flow, T_outflow, xi_outflow
  ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification;
  stream ClaRa.Basics.Units.MassFraction classFraction_outflow[classification.N_class-1] "Particle class mass fraction";
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={73,80,85},
          fillColor={73,80,85},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid)}));
end FuelInletDistr;
