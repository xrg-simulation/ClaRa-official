within ClaRa.StaticCycles;
model Triple "Visualise static cycle results"
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
  parameter Integer stacy_id = 0 "Identifier of the static cycle triple";
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Measured mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Measured mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed=false) "Measured mass flow rate";
record DecimalSpaces
  extends ClaRa.Basics.Icons.RecordIcon;
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer h=1 "Accuracy to be displayed for enthalpy";
parameter Integer p=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  Fundamentals.SteamSignal_base steamSignal(Medium=vleMedium) annotation (Placement(transformation(extent={{-108,-10},{-100,10}}),iconTransformation(extent={{-120,-20},{-100,40}})));


initial equation
  m_flow = steamSignal.m_flow;
  p=steamSignal.p;
  h=steamSignal.h;

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1),     graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("p", String(steamSignal.p/1e5,format="1." + String(decimalSpaces.p) + "f") + " bar")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("h", String(steamSignal.h/1e3,format="1." + String(decimalSpaces.h) + "f") + " kJ/kg")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("m", String(steamSignal.m_flow,format="1." + String(decimalSpaces.m_flow) + "f") + " kg/s")),
        Line(
          points={{-100,180},{-100,-100}},
          color=DynamicSelect({164,167,170},{0,131,169}),
          smooth=Smooth.None,thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1),   graphics));
end Triple;
