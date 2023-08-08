within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
model TubeBundle "(1,2) - Tube bundle heatexchanger | one external and two internal passes with epsilon = 1/2"
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

extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger(
    final a=0.317,
    final b=2.09,
    final c=0.543,
    final d=0.5);

extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons.HEX_TubeBundle_Icon;

  annotation (Icon(graphics),   Documentation(info="<html>
<p>VDI-Waermeatlas Chapter Ca5, 9th edition, VDI-Verlag, 2006</p>
</html>"));
end TubeBundle;
