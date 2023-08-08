within ClaRa_Obsolete.StaticCycles;
model Source_black
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
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
  parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation(Dialog(group="Parameters"));

// parameter ClaRa.Basics.Units.Temperature T_FG_nom;
// parameter ClaRa.Basics.Units.MassFlowRate m_flow_FG_nom;
parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel;
parameter ClaRa.Basics.Units.MassFraction xi_fuel[fuelType.nc-1];
parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV;
// final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_FG_out=TILMedia.GasFunctions.specificEnthalpy_pTxi(
//       flueGas,
//       1e5,
//       T_FG_nom,
//       xi_nom) "Outlet specific enthalpy";
//final parameter ClaRa.Basics.Units.MassFlowRate m_flow_FG_out=m_flow_FG_nom;

  //  h=h_FG_out,
  FuelSignal_black_b fuelSignal_black(
    fuelType=fuelType,
    m_flow=m_flow_fuel,
    xi=xi_fuel,
    LHV=LHV) annotation (Placement(transformation(extent={{100,-10},{108,10}}), iconTransformation(extent={{100,-10},{108,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow_fuel"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi_fuel"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%LHV"),
        Line(points={{60,100},{100,0},{60,-100}}, color={0,0,0}),
                                          Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.4.0")}),           Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Source_black;
