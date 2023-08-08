within ClaRa.StaticCycles.Boundaries;
model Source_brown
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
  // Brown output:  Value of p, T and m_flow are known in component and provided FOR neighbor component, value of xi is unknown and provided BY neighbor component.

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  final parameter ClaRa.Basics.Units.Temperature T_fg_nom(fixed=false) "Temperature at the source";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_nom(fixed=false) "Mass flow from the source";
  final parameter ClaRa.Basics.Units.Pressure p_fg_nom(fixed=false) "Pressure at the source";
  parameter ClaRa.Basics.Units.MassFraction xi_fg_nom[flueGas.nc - 1]=flueGas.xi_default "Flue gas composition at the source";

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outlet(flueGas=flueGas, xi=xi_fg_nom) annotation (Placement(transformation(extent={{100,-10},{108,10}}), iconTransformation(extent={{100,-10},{108,10}})));

initial equation
  T_fg_nom=outlet.T;
  m_flow_fg_nom=outlet.m_flow;
  p_fg_nom=outlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,22},{60,-18}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi"),
        Line(points={{60,100},{100,0},{60,-100}}, color={118,106,98})}),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Source_brown;
