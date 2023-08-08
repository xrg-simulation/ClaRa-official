within ClaRa.StaticCycles.Fundamentals;
connector FuelSignal_black_b "Signal-based fuel connector"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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
  ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel "Fuel model";

  output ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow";
  output ClaRa.Basics.Units.MassFraction xi[fuelModel.N_c - 1];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end FuelSignal_black_b;
