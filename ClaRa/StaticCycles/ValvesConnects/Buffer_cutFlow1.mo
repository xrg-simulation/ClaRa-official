within ClaRa.StaticCycles.ValvesConnects;
model Buffer_cutFlow1 "Buffer || blue | red"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
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
   // Blue input: Values of p and h are unknown and provided BY neighbor component, value of m_flow is known and provided FOR neighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
    //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE_a inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE_a outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     h=h_in,
     p=p_in,
     rho = TILMedia.VLEFluidFunctions.density_phxi(vleMedium, p_in, h_in, vleMedium.xi_default)),
  outlet(
     m_flow=m_flow_out,
     h=h_out,
     p=p_out,
     rho=TILMedia.VLEFluidFunctions.density_phxi(vleMedium, p_out, h_out, vleMedium.xi_default)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.Pressure p_in = p_out "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow rate";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_out(fixed=false) "Inlet mass flow rate";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_diff = m_flow_in - m_flow_out "Rprt: Mass flow difference";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(p=p_in, Medium=vleMedium) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_b outlet(h=h_out, Medium=vleMedium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p_out;

  inlet.m_flow = m_flow_in;
  outlet.m_flow=m_flow_out;

  inlet.h=h_in;
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}), graphics={
        Line(points={{-50,0},{-25,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Line(points={{25,0},{50,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Ellipse(
          extent={{-25,25},{25,-25}},
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_diff) > 1e-1 then FillPattern.Forward else FillPattern.Solid),
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end Buffer_cutFlow1;
