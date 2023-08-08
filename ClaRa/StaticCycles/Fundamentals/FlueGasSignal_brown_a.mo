within ClaRa.StaticCycles.Fundamentals;
connector FlueGasSignal_brown_a "Signal-based flue gas connector"
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
 // extends ClaRa_Dev.StaticCycles.Fundamentals.FlueGasSignal_basic;

  TILMedia.GasTypes.BaseGas                 flueGas "Medium model";

  output ClaRa.Basics.Units.Pressure p;
  output ClaRa.Basics.Units.MassFlowRate m_flow;
  output ClaRa.Basics.Units.Temperature T;
  input ClaRa.Basics.Units.MassFraction xi[flueGas.nc - 1];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={118,106,98},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end FlueGasSignal_brown_a;
