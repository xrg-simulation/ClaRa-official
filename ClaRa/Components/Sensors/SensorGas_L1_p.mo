within ClaRa.Components.Sensors;
model SensorGas_L1_p "Ideal one port pressure sensor"
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
  extends ClaRa.Basics.Icons.Sensor1;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"),Placement(transformation(extent={{42,-2},{62,18}})));

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching,  Dialog(group="Fundamental Definitions"), choices(choice=1 "Pa", choice=2 "bar", choice=3 "mbar", choice=4 "MPa", choice = 5 "per Unit"));

  Modelica.Blocks.Interfaces.RealOutput p(final quantity="Pressure", displayUnit = "bar",final unit="Pa") "pressure in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

  parameter ClaRa.Basics.Units.Pressure p_ref[2]={0,1e5} "Reference pressure [min,max]" annotation(Dialog(group="Fundamental Definitions", enable = (unitOption==5)));

  Basics.Interfaces.GasPortIn port(Medium = medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));


equation

  if unitOption==1 then
    p = port.p;
  elseif unitOption==2 then
    p=port.p/1e5;
  elseif unitOption==3 then
    p=port.p/100;
  elseif unitOption==4 then
    p=port.p/1e6;
  elseif unitOption==5 then
    p = (port.p- p_ref[1])/(p_ref[2]-p_ref[1]);
  else
    p=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(medium.nc - 1);

  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
                Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" p ", String(p,format="1.1f"))),
        Text(
          extent={{40,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {0,131,169} else {167,25,48}),
textString=DynamicSelect("", if unitOption==1 then "Pa" elseif unitOption==2 then "bar" elseif unitOption == 3 then "mbar" elseif initOption==4 then "MPa" else "p.u.")),
        Text(
          extent={{-98,36},{102,-4}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="PIT")}));
end SensorGas_L1_p;
