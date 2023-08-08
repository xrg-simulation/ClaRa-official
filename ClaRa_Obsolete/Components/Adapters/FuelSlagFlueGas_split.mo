within ClaRa_Obsolete.Components.Adapters;
model FuelSlagFlueGas_split
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends ClaRa.Basics.Icons.Adapter3_fw;
    extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_3;

//__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  inner parameter ClaRa.Basics.Media.Fuel.PartialFuel fuelType=simCenter.fuelModel1 "Fuel elemental composition used for combustion"
                                                     annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
   inner parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties"
                      annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas               flueGas = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  Basics.Interfaces.Fuel_outlet fuel_outlet(fuelType=fuelType) annotation (Placement(transformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.GasPortOut flueGas_outlet(Medium=flueGas)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.Slag_inlet slag_inlet(slagType=slagType) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Basics.Interfaces.FuelSlagFlueGas_inlet fuelSlagFlueGas_inlet(
    flueGas(Medium=flueGas),
    final fuelType=fuelType,
    final slagType=slagType) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-98,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,0})));

equation
  fuelSlagFlueGas_inlet.flueGas.m_flow = -flueGas_outlet.m_flow;
  fuelSlagFlueGas_inlet.flueGas.T_outflow = inStream(flueGas_outlet.T_outflow);
  flueGas_outlet.T_outflow = inStream(fuelSlagFlueGas_inlet.flueGas.T_outflow);
  fuelSlagFlueGas_inlet.flueGas.xi_outflow = inStream(flueGas_outlet.xi_outflow);
  flueGas_outlet.xi_outflow = inStream(fuelSlagFlueGas_inlet.flueGas.xi_outflow);
  fuelSlagFlueGas_inlet.flueGas.p = flueGas_outlet.p;

  fuelSlagFlueGas_inlet.fuel.m_flow = -fuel_outlet.m_flow;
  fuelSlagFlueGas_inlet.fuel.T_outflow = inStream(fuel_outlet.T_outflow);
  fuel_outlet.T_outflow = inStream(fuelSlagFlueGas_inlet.fuel.T_outflow);
  fuelSlagFlueGas_inlet.fuel.xi_outflow = inStream(fuel_outlet.xi_outflow);
  fuel_outlet.xi_outflow = inStream(fuelSlagFlueGas_inlet.fuel.xi_outflow);
  fuelSlagFlueGas_inlet.fuel.LHV_outflow = inStream(fuel_outlet.LHV_outflow);
  fuel_outlet.LHV_outflow = inStream(fuelSlagFlueGas_inlet.fuel.LHV_outflow);
  fuelSlagFlueGas_inlet.fuel.cp_outflow = inStream(fuel_outlet.cp_outflow);
  fuel_outlet.cp_outflow = inStream(fuelSlagFlueGas_inlet.fuel.cp_outflow);
  fuelSlagFlueGas_inlet.fuel.p = fuel_outlet.p;
  fuelSlagFlueGas_inlet.fuel.LHV_calculationType= fuel_outlet.LHV_calculationType;

  fuelSlagFlueGas_inlet.slag.m_flow = -slag_inlet.m_flow;
  fuelSlagFlueGas_inlet.slag.T_outflow = inStream(slag_inlet.T_outflow);
  slag_inlet.T_outflow = inStream(fuelSlagFlueGas_inlet.slag.T_outflow);
  fuelSlagFlueGas_inlet.slag.p = slag_inlet.p;

  annotation (Icon(graphics),
                           Diagram(graphics));
end FuelSlagFlueGas_split;
