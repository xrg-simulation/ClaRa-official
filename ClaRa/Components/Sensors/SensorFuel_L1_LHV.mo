within ClaRa.Components.Sensors;
model SensorFuel_L1_LHV "Ideal one port LHV sensor"
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

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog( group="Fundamental Definitions"), choices(choice=1 "MJ/kg", choice=2 "kJ/kg",
                                                                                              choice=3 "J/kg"));
  parameter ClaRa.Basics.Units.Temperature LHV_ref[2]={0,30e6} "Reference LHV [min,max]" annotation(Dialog(group="Fundamental Definitions", enable = (unitOption==4)));

  Modelica.Blocks.Interfaces.RealOutput LHV "Temperature in port medium" annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=0), iconTransformation(extent={{100,-10},{120,10}})));
  ClaRa.Basics.Interfaces.Fuel_inlet port(fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));


protected
   Basics.Media.FuelObject       fuel(
     fuelModel=fuelModel,
     p=port.p,
     T=inStream(port.T_outflow),
     xi_c=inStream(port.xi_outflow)) annotation (Placement(transformation(extent={{-10,-12},{10,8}}), iconTransformation(extent={{-10,-110},{10,-90}})));
equation
  if unitOption == 1 then //MJ/kg
    LHV = fuel.LHV/1.e6;
  elseif unitOption == 2 then // kJ/kg
    LHV = fuel.LHV/1.e3;
  elseif unitOption == 3 then // J/kg
    LHV = fuel.LHV;
  else
    LHV = -1;
           //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(fuelModel.N_c-1);

  annotation (                   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="LHV"),
        Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if T_celsius > 0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect(" T ", String(T, format="1.1f"))),
        Text(
          extent={{50,90},{90,60}},
          lineColor=DynamicSelect({230, 230, 230},  if T_celsius>0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect("", if unitOption==1 then "K" elseif unitOption==2 then "C" elseif unitOption==3 then "F" else "p.u."),
          horizontalAlignment=TextAlignment.Left)}));
end SensorFuel_L1_LHV;
