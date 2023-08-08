within ClaRa_Obsolete.StaticCycles;
connector FuelSignal_black_b "Signal-based fuel connector"
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
  ClaRa.Basics.Media.Fuel.PartialFuel fuelType "Fuel model";

  output ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow";
  output ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value";
  output ClaRa.Basics.Units.MassFraction xi[fuelType.nc-1];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.4.0")}),
                                            Diagram(graphics,
                                                    coordinateSystem(extent={{-40,-100},{40,100}})));
end FuelSignal_black_b;
