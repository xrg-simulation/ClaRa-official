within ClaRa.StaticCycles.Fundamentals;
connector FlueGasSignal_base "Signal-based flue gas connector || basic||"
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

  TILMedia.GasTypes.BaseGas                 flueGas "Medium model";

  ClaRa.Basics.Units.Pressure p;
  ClaRa.Basics.Units.MassFlowRate m_flow;
  ClaRa.Basics.Units.Temperature T;
  ClaRa.Basics.Units.MassFraction xi[flueGas.nc - 1];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={118,106,98},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end FlueGasSignal_base;
