within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Wall_L2 "All Geo || L2 || Radiation Between Gas and Wall"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  extends ClaRa.Basics.Icons.Epsilon;

  input Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall"
                                                                                   annotation (Dialog(group="Heat Transfer"));
  parameter Real emissivity_wall=0.8 "Emissivity of the wall";
  parameter Real emissivity_flame=0.9 "Emissivity of the flame";
  parameter Real absorbance_flame=0.9 "Absorbance of the flame";
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;

equation
  //According to VDI Waermeatlas for a wall surrounding a gas volume chapter Kc5.
  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*CF_fouling*Modelica.Constants.sigma*emissivity_wall/(absorbance_flame + emissivity_wall - absorbance_flame*emissivity_wall)*(absorbance_flame*heat.T^4 - emissivity_flame*iCom.T_out^4);

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A simple correlation for radiant heat transfer between gas and wall inside furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>Emissivities of flue gas and wall are constant values</li>
<li>Heat transfer area is calculated from geometry</li>
</ul></p>
</html>"));
end Radiation_gas2Wall_L2;
