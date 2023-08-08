within ClaRa.Components.Adapters;
model FuelFlueGas_join
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
  extends ClaRa.Basics.Icons.Adapter2_bw;
 //__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter TILMedia.GasTypes.BaseGas               flueGas = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.Fuel_inlet fuel_inlet(fuelModel=fuelModel)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  ClaRa.Basics.Interfaces.GasPortIn flueGas_inlet(Medium=flueGas)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  ClaRa.Basics.Interfaces.FuelFlueGas_outlet fuelFlueGas_outlet(flueGas(Medium=flueGas), fuelModel=fuelModel) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  fuelFlueGas_outlet.flueGas.m_flow = -flueGas_inlet.m_flow;
  fuelFlueGas_outlet.flueGas.T_outflow = inStream(flueGas_inlet.T_outflow);
  flueGas_inlet.T_outflow = inStream(fuelFlueGas_outlet.flueGas.T_outflow);
  fuelFlueGas_outlet.flueGas.xi_outflow = inStream(flueGas_inlet.xi_outflow);
  flueGas_inlet.xi_outflow = inStream(fuelFlueGas_outlet.flueGas.xi_outflow);
  fuelFlueGas_outlet.flueGas.p = flueGas_inlet.p;

  fuelFlueGas_outlet.fuel.m_flow = -fuel_inlet.m_flow;
  fuelFlueGas_outlet.fuel.T_outflow = inStream(fuel_inlet.T_outflow);
  fuel_inlet.T_outflow = inStream(fuelFlueGas_outlet.fuel.T_outflow);
  fuelFlueGas_outlet.fuel.xi_outflow = inStream(fuel_inlet.xi_outflow);
  fuel_inlet.xi_outflow = inStream(fuelFlueGas_outlet.fuel.xi_outflow);
  fuelFlueGas_outlet.fuel.p = fuel_inlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics),               Diagram(graphics));
end FuelFlueGas_join;
