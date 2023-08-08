within ClaRa.StaticCycles.Fittings;
model Split2 "Split || blue | green | yellow"
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
   // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet1;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet2;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  outlet1(
     m_flow=m_flow_2,
     h=h1,
     p=p),
  outlet2(
     m_flow=m_flow_3,
     h=h1,
     p=p));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal split pressure" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_p_P_target_[:,:]=[0,1;1,1] "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Split pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2=m_flow_1 - m_flow_3 "Mass flow rate of outlet 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3(fixed=false) "Mass flow rate of outlet 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Spec. enthalpy at inlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of inlet";

  outer parameter Real P_target_;
protected
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table(table=CharLine_p_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_blue_a inlet(p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{-50,10},{-60,30}}), iconTransformation(extent={{-50,10},{-60,30}})));
  Fundamentals.SteamSignal_green_b outlet_1(
    m_flow=m_flow_2,
    h=h1,
    p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{60,10},{50,30}}), iconTransformation(extent={{60,10},{50,30}})));
  Fundamentals.SteamSignal_yellow_b outlet_2(h=h1, p=p, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0})));
initial equation
  p=table.y[1]*p_nom;
  inlet.m_flow=m_flow_1;
  inlet.h=h1;
  outlet_2.m_flow=m_flow_3;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                   graphics={
          Polygon(
            points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
            lineColor={0,131,169},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-20,20},{20,10}},
            lineColor={0,131,169},
            textString=DynamicSelect("p", String(p)))}),        Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-30},{50,30}}),     graphics));
end Split2;
