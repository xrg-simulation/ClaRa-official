within ClaRa.Components.Sensors;
model SensorGas_L1_T "Ideal two port temperature sensor"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.0                            //
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

extends ClaRa.Components.Sensors.gasSensorBase;
  outer ClaRa.SimCenter simCenter;
  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog( group="Fundamental Definitions"), choices(choice=1 "Kelvin", choice=2 "Degree Celsius",
                                                                                              choice=3 "Degree Fahrenheit", choice = 4 "per Unit"));
  parameter ClaRa.Basics.Units.Temperature T_ref[2]={0,273.15} "Reference temperature [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 4)));
  Modelica.Blocks.Interfaces.RealOutput temperature "temperature in port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

protected
  ClaRa.Basics.Units.Temperature T;

equation
  if unitOption == 1 then //Kelvin
    temperature = T;
  elseif unitOption == 2 then // Degree Celsius
    temperature = Modelica.SIunits.Conversions.to_degC(T);
  elseif unitOption == 3 then // Degree Fahrenheit
    temperature = Modelica.SIunits.Conversions.to_degF(T);
  elseif unitOption==4 then // per Unit
    temperature =(T-T_ref[1])/(T_ref[2]-T_ref[1]);
  else
    temperature=-1;  //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  if noEvent(outlet.m_flow < 0.0) then
    T = outlet.T_outflow;
  else
    T = inlet.T_outflow;
  end if;
  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="TIT"),
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-96,-100},{100,-100}},
          color={118,106,98},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if temperature > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" T ", String(temperature, format="1.1f"))),
        Text(
          extent={{50,90},{90,60}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if temperature > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect("", if unitOption==1 then "K" elseif unitOption==2 then "°C" elseif unitOption==3 then "°F" else "p.u."),
          horizontalAlignment=TextAlignment.Left)}));
end SensorGas_L1_T;
