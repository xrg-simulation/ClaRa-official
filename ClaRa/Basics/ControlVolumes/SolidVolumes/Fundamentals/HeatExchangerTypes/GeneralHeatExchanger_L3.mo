within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
partial model GeneralHeatExchanger_L3
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

  import Modelica.Constants.eps;
  input Real NTU_1[3] "Number of Transfer Units at limiting side";
  input Real R_1[3] "Ratio of heat capacity flows at limiting side";
  output Real CF_NTU[3](start={1,1,1}) "Correction factor for heat flow based on the NTU method";

  parameter Real a "Geometry fitting factor";
  parameter Real b "Geometry fitting exponent";
  parameter Real c "Geometry fitting exponent";
  parameter Real d "Geometry fitting exponent";

  outer ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3 iCom;
  outer Boolean outerPhaseChange;
  outer Real yps_2ph;
  outer Real yps_1ph;

  Real yps[3] "Area fraction of the three zones";

  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_in[3] "Spec. enthalpy at the zone borders - inner side";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_in[3] "Spec. enthalpy at the zone borders - outer side";

  ClaRa.Basics.Units.Temperature T_in2out_o[6] "Temperatures at the zone borders - outer side";
  ClaRa.Basics.Units.Temperature T_in2out_i[6] "Temperatures at the zone borders - inner side";
  Real ff_i[3] "Mass Flow Fraction for the three zones at inner side";
  Real ff_o[3] "Mass Flow Fraction for the three zones at outer side";
  Real z_i[6] "Position of the zones at the inner side of the heat exchanger";
  Real z_o[6] "Position of the zones at the outer side of the heat exchanger";

equation
  CF_NTU = {1/(1+a*R_1[i]^(d*b)*max(eps,NTU_1[i])^b)^c for i in 1:3};

  annotation (Icon(graphics={        Polygon(
          points={{100,-34},{100,-36},{46,-24},{46,-24},{10,-46},{-40,6},{-48,
              16},{-22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={153,205,211},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,6},
          rotation=180,
          lineColor={0,0,0}),        Polygon(
          points={{100,-34},{100,-36},{66,4},{66,4},{10,-46},{-40,6},{-48,16},{
              -22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,-14},
          rotation=0,
          lineColor={0,0,0})}));
end GeneralHeatExchanger_L3;
