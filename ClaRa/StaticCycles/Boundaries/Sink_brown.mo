within ClaRa.StaticCycles.Boundaries;
model Sink_brown
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
  // Brown input:   Value of xi is known in component and provided FOR neighbor component, values of p, T and m_flow are unknown and provided BY neighbor component.

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  parameter ClaRa.Basics.Units.Temperature T_fg_nom "Temperature at the sink";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_nom "Mass flow into the sink";
  parameter ClaRa.Basics.Units.Pressure p_fg_nom "Temperature at the sink";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_nom[flueGas.nc - 1](fixed=false) "Flue gas composition at the sink";


  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_out=m_flow_fg_nom;

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_a inlet(
    flueGas=flueGas,
    m_flow=m_flow_fg_out,
    T=T_fg_nom,
    p=p_fg_nom) annotation (Placement(transformation(extent={{-108,-10},{-100,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));

initial equation
  xi_fg_nom=inlet.xi;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow_fg_nom"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%T_fg_nom"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p_fg_nom"),
        Line(points={{-100,100},{-60,0},{-100,-100}},
                                                  color={118,106,98})}),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Sink_brown;
