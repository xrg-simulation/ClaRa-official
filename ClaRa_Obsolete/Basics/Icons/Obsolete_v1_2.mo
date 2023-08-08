within ClaRa_Obsolete.Basics.Icons;
model Obsolete_v1_2 "This model will be not longer supported than Version 1.4!"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={ Polygon(
          points={{-100,-100},{100,100},{-100,-100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-100,100},{100,-100},{-100,100}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-60},{80,-100}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.4.0")}),
                                            Diagram(coordinateSystem(extent={{
            -100,-100},{100,100}})));
end Obsolete_v1_2;
