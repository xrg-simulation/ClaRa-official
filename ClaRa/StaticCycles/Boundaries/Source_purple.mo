within ClaRa.StaticCycles.Boundaries;
model Source_purple
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

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  parameter ClaRa.Basics.Units.Temperature T_fg_nom;
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_nom;
  parameter ClaRa.Basics.Units.MassFraction xi_fg_nom[flueGas.nc - 1]=flueGas.xi_default;
  final parameter ClaRa.Basics.Units.Pressure p_fg_nom(fixed=false);

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_purple_b outlet(
    flueGas=flueGas,
    T=T_fg_nom,
    m_flow=m_flow_fg_nom,
    xi=xi_fg_nom) annotation (Placement(transformation(extent={{100,-10},{108,10}})));

initial equation
  p_fg_nom=outlet.p;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow_fg_nom"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%T_fg_nom"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi_fg_nom"),
        Line(points={{60,100},{100,0},{60,-100}}, color={168,88,171})}),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Source_purple;
