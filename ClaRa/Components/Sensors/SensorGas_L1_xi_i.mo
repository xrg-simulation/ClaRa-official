within ClaRa.Components.Sensors;
model SensorGas_L1_xi_i "Ideal one port gas composition sensor"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
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

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "kg/kg", choice=2 "m^3/m^3"));


  Modelica.Blocks.Interfaces.RealOutput fraction[simCenter.flueGasModel.nc-1] "fraction (volume or mass) in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

//parameter Integer compositionDefinedBy "output gives mass or volume fraction"  annotation(choices(choice = 1 "mass", choice = 2 "volume"));

  TILMedia.Gas_pT gas(p = inlet.p, T = noEvent(actualStream(inlet.T_outflow)), xi = noEvent(actualStream(inlet.xi_outflow)), gasType= medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  if unitOption == 1 then
    fraction = {gas.xi[i] for i in 1:medium.nc-1};
  else
    fraction = {gas.x[i] for i in 1:medium.nc-1};
  end if;

  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
        Line(
          points={{-98,-100},{96,-100}},
          color={118,106,98},
          smooth=Smooth.None,
          thickness=0.5)}));
end SensorGas_L1_xi_i;
