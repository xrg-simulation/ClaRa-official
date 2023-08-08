within ClaRa.Visualisation;
model StatePoint_ph "Pressure and Enthalpy for ph-Diagram visualisation"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
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

  outer SimCenter simCenter;

  ClaRa.Basics.Interfaces.FluidPortIn port(Medium=medium)
    annotation (Placement(transformation(extent={{-110,-114},{-90,-94}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer stateViewerIndex=0 "Index for StateViewer" annotation(Dialog(group="StateViewer Index"));
  Real p;
  Real h;
equation
  h=inStream(port.h_outflow);
  p=port.p;
  port.m_flow=0;
  port.h_outflow=0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}},
        initialScale=0.04),    graphics={
        Text(
          extent={{-90,80},{250,10}},
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
        Line(
          points={{-100,100},{-100,-100}},
          color=DynamicSelect({164,167,170},{0,131,169}),
          smooth=Smooth.None,
          thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}},
        initialScale=0.04),  graphics));
end StatePoint_ph;
