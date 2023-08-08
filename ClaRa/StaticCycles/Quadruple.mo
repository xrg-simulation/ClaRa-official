within ClaRa.StaticCycles;
model Quadruple "Visualise static cycle results"
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

  outer ClaRaPlus.SimCenter simCenter;
  parameter TSMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter Integer stacy_id = 0 "Identifier of the static cycle triple";
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as posible";

  final parameter ClaRaPlus.Basics.Units.MassFlowRate m_flow(fixed=false) "Measured mass flow rate";
  final parameter ClaRaPlus.Basics.Units.Pressure p(fixed=false) "Measured mass flow rate";
  final parameter ClaRaPlus.Basics.Units.EnthalpyMassSpecific h(fixed=false) "Measured mass flow rate";
  final parameter ClaRaPlus.Basics.Units.Temperature T(fixed=false) "Temperature";
record DecimalSpaces
  extends ClaRaPlus.Basics.Icons.RecordIcon;
  parameter Integer T=1 "Accuracy to be displayed for temperature";
  parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
  parameter Integer h=1 "Accuracy to be displayed for enthalpy";
  parameter Integer p=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  Fundamentals.SteamSignal_base steamSignal(Medium=medium) annotation (Placement(transformation(extent={{-108,-10},{-100,10}}),iconTransformation(extent={{-210,-126},{-190,-66}})));


initial equation
  m_flow = steamSignal.m_flow;
  p=steamSignal.p;
  h=steamSignal.h;
  T = TSMedia.VLEFluidFunctions.temperature_phxi(medium, p, h);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,0}},
        initialScale=0.05),    graphics={
        Rectangle(
          extent={{-200,0},{200,-200}},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent=DynamicSelect({{-200,0},{0,-100}},if largeFonts then {{-200,0},{0,-100}} else {{-200,-20},{0,-80}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230}, if m_flow>0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" m ", String(m_flow,format = "1."+String(decimalSpaces.m_flow)+"f") +" kg/s")),
        Text(
          extent=DynamicSelect({{-200,-100},{0,-200}},if largeFonts then {{-200,-100},{0,-200}} else {{-200,-120},{0,-180}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},{0,131,169}),
          textString=DynamicSelect(" h ", String(h/1000,format = "1."+String(decimalSpaces.h)+"f") + " kJ/kg")),
        Text(
          extent=DynamicSelect({{0,0},{200,-100}},if largeFonts then {{0,0},{200,-100}} else {{0,-20},{200,-80}}),
          textString=DynamicSelect(" T ", String(T-273.15, format = "1."+String(decimalSpaces.T)+"f") + "°C"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},{0,131,169})),
        Text(
          extent=DynamicSelect({{0,-100},{200,-200}}, if largeFonts then {{0,-100},{200,-200}} else {{0,-120},{200,-180}}),
          textString=DynamicSelect(" p ", String(p/1e5,format = "1."+String(decimalSpaces.p)+"f") + " bar"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},{0,131,169})),
        Line(
          points={{0,0},{0,-200}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},{0,131,169})),
        Line(
          points={{-200,-100},{200,-100}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},{0,131,169}))}),            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -200},{200,0}},
        initialScale=0.05),  graphics));
end Quadruple;
