within ClaRa.Components.Sensors;
model SensorFuel_L1_xi "Ideal one port fuel composition sensor"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
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

//  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "kg/kg", choice=2 "m^3/m^3"));
  parameter Integer component=1 "component" annotation(choices(choice = 1 "C", choice = 2 "H2", choice = 3 "O2", choice = 4 "N2", choice = 5 "S", choice = 6 "ash", choice = 7 "water"));


  Modelica.Blocks.Interfaces.RealOutput fraction "fraction (volume or mass) in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));


  ClaRa.Basics.Interfaces.Fuel_inlet port(fuelModel = fuelModel) annotation (Placement(transformation(extent={{-10,-112},{10,-92}}), iconTransformation(extent={{-10,-112},{10,-92}})));
protected
   ClaRa.Basics.Media.FuelObject fuel(
     fuelModel=fuelModel,
     p=port.p,
     T=inStream(port.T_outflow),
     xi_c=inStream(port.xi_outflow)) annotation (Placement(transformation(extent={{-10,-12},{10,8}}), iconTransformation(extent={{-10,-110},{10,-90}})));
equation
  if component == fuelModel.N_e then
    fraction = 1-sum(fuel.xi_e);
  else
    fraction = fuel.xi_e[component];
  end if;

  port.m_flow=0;
  port.T_outflow=0;
  port.xi_outflow=zeros(fuelModel.N_c-1);

  annotation (                   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="QIT"),
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if fuel.T > 273.15 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect(" xi ", String(fraction,significantDigits=integer(3))))}));
end SensorFuel_L1_xi;
