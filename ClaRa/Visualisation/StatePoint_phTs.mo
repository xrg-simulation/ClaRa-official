within ClaRa.Visualisation;
model StatePoint_phTs "Complete state definition for visualisation in ph, TS, hs-diagrams"
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

  outer SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer stateViewerIndex=0 "Index for StateViewer" annotation(Dialog(group="StateViewer Index"));
  ClaRa.Basics.Units.Pressure p "Pressure of state";
  ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy of state";
  ClaRa.Basics.Units.EntropyMassSpecific s=state.s "Specific enthalpy of state";
  ClaRa.Basics.Units.Temperature T=state.T "Temperature of state";
  ClaRa.Basics.Units.VolumeMassSpecific v=1/state.d "Specific volume of state";

  ClaRa.Basics.Interfaces.FluidPortIn port(Medium=medium)
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph state(p=p,h=h,
    vleFluidType =    medium)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

equation
  h=inStream(port.h_outflow);
  p=port.p;
  port.m_flow=0;
  port.h_outflow=0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{220,260}},
        initialScale=0.04),    graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("p", String(p/1e5,format="1.1f") + " bar")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("h", String(h/1e3,format="1.1f") + " kJ/kg")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("T", String(T-273.15,format="1.1f") + "°C")),
        Text(
          extent={{-90,260},{250,190}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("s", String(s/1e3,format="1.1f") + " kJ/(kgK)")),
        Line(
          points={{-100,258},{-100,-100}},
          color=DynamicSelect({164,167,170},{0,131,169}),
          smooth=Smooth.None,thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{220,260}},
        initialScale=0.08),  graphics));
end StatePoint_phTs;
