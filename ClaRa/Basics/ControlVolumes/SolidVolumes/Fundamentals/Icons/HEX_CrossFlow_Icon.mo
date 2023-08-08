within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons;
model HEX_CrossFlow_Icon
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-102}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-102}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          lineColor={0,0,0}),        Polygon(
          points={{-100,-60},{-70,-60},{-40,-60},{-40,-60},{40,-60},{40,-60},{
              40,-86},{100,-40},{40,6},{40,6},{40,-20},{-100,-20},{-100,-60}},
          smooth=Smooth.None,
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={0,60},
          rotation=0,
          lineColor={0,0,0}),                   Polygon(
          points={{100,20},{-40,20},{-40,48},{-100,0},{-40,-46},{-40,-20},{100,
              -20},{100,20}},
          smooth=Smooth.None,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          origin={-20,0},
          rotation=90)}));
end HEX_CrossFlow_Icon;
