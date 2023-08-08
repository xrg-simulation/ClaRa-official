within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Gas_L2 "All Geo || L2 || Radiation Between Gas Volumes"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  extends ClaRa.Basics.Icons.Epsilon;

  parameter Real emissivity_top=0.8 "Emissivity of the gas volume above";
  parameter Real emissivity_flame=0.9 "Emissivity of the flame";

  //ClaRa.Basics.Units.Area A_eff "Effective heat transfer area";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;
equation
  //Nach VDI Waermeatlas fuer zwei sehr grosse parallele ebene Flaechen
  heat.Q_flow = geo.A_front*Modelica.Constants.sigma/(1.0/emissivity_top + 1.0/emissivity_flame - 1.0)*(heat.T^4 - iCom.T_out^4);

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A simple correlation for radiant heat transfer between gases inside furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>Emissivities of flue gases are constant values</li>
<li>Heat transfer area is calculated from geometry</li>
</ul></p>
</html>"));
end Radiation_gas2Gas_L2;
