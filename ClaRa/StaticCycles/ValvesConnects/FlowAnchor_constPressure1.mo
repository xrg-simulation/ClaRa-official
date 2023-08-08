within ClaRa.StaticCycles.ValvesConnects;
model FlowAnchor_constPressure1 "Flow Anchour || par.: m_flow_nom || red | blue"
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
// Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
// Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer parameter Real P_target_ "Target power in p.u.";
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE_a inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE_a outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in,
     rho = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_in, h_in, vleMedium.xi_default)),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out,
     rho=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_out, h_out, vleMedium.xi_default)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_m_flow_P_target_[:,2] = [0,0;1,1] "Pressure drop depending on rel. power in p.u."
                                                                                              annotation(Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.Pressure p_in=p_out "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table1(table=CharLine_m_flow_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_red_a inlet(p=p_in, m_flow=m_flow, Medium=vleMedium) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue_b outlet(h=h_out, m_flow=m_flow, Medium=vleMedium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p_out;
  inlet.h=h_in;
  m_flow = table1.y[1]*m_flow_nom;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-50,-25},{50,25}}),
                   graphics={
        Line(
          points={{-50,0},{50,0}},
          color={0,131,169},
          smooth=Smooth.None),
                             Polygon(
          points={{-40,25},{-40,-25},{40,0},{-40,25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25),
        Text(
          extent={{-20,6},{20,-4}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("m_flow", String(m_flow)))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end FlowAnchor_constPressure1;
