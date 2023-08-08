within ClaRa.StaticCycles.HeatExchanger;
model Condenser "Condenser || par.: pressure, level_abs || blue |green"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow_in,
     h=h_out,
     p=p_out));
  //---------Summary Definition---------
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Pressure p_condenser=4000 "|Fundamental Definitions|Condenser pressure";
  parameter ClaRa.Basics.Units.Length level_abs(min=0) = 0 "|Fundamental Definitions|Filling level in hotwell";

  final parameter ClaRa.Basics.Units.Pressure p_in=p_condenser "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out=p_condenser + Modelica.Constants.g_n*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleDensity_pxi(medium, p_condenser)*level_abs "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_condenser) "Outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow";
//    final parameter ClaRa.Basics.Units.MassFlowRate    m_flow_out=m_flow_cond;
protected
  final parameter Boolean isFilled = level_abs > 0 "Reprt: True if vessel is filled";
public
  Fundamentals.SteamSignal_blue_a inlet(p=p_condenser, Medium=medium) annotation (Placement(transformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_green_b outlet(
    h=h_out,
    p=p_out,
    m_flow=m_flow_in, Medium=medium) annotation (Placement(transformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,-0}), iconTransformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,0})));

initial equation

 inlet.m_flow=m_flow_in;
 inlet.h=h_in;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                               graphics={
                             Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{100,58},{-36,58},{38,-2},{-30,-62},{100,-62}},
          color={0,131,169},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,-80},{100,-100}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible = DynamicSelect(false, isFilled))}));
end Condenser;
