within ClaRa.StaticCycles.HeatExchanger;
model Reboiler "Reboiler || par.: p_reb, m_flow_reb || red | green"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_reb,
     h=h_in,
     p=p_reb),
  outlet(
     m_flow=m_flow_reb,
     h=h_out,
     p=p_reb));
  //---------Summary Definition---------
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

parameter ClaRa.Basics.Units.Pressure p_reb=3.5e5 "|Fundamental Definitions|Reboiler pressure";
parameter ClaRa.Basics.Units.MassFlowRate m_flow_reb=150 "|Fundamental Definitions|Reboiler mass flow rate";
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Spec. enthalpy at reboiler steam inlet";
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_reb) "Spec. enthalpy at reboiler condensed steam";
  Fundamentals.SteamSignal_red_a inlet(p=p_reb, m_flow=m_flow_reb) annotation (Placement(transformation(extent={{-114,-10},{-94,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
  Fundamentals.SteamSignal_green_b outlet(
    p=p_reb,
    m_flow=m_flow_reb,
    h=h_out) annotation (Placement(transformation(extent={{94,-10},{114,10}}), iconTransformation(extent={{100,-10},{108,10}})));
initial equation
  inlet.h=h_in;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{0,-40},{0,40},{100,0}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Reboiler;
