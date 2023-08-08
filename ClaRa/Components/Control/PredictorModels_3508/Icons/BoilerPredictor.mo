within ClaRa.Components.Control.PredictorModels_3508.Icons;
model BoilerPredictor "An icon for a boiler model - relative units ('p.u.')"
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

  annotation (Icon(graphics={   Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid), Rectangle(extent={{-80,80},{80,-80}}, lineColor={221,222,223}),
                             Polygon(
          points={{32,-46},{10,-70},{-16,-70},{-40,-48},{-40,68},{30,68},{62,30},{52,10},{32,36},{32,-46}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-34},{-24,-24},{-8,-18},{6,6},{6,6},{12,-40},{-22,-44},{-40,-34}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier)}));
end BoilerPredictor;
