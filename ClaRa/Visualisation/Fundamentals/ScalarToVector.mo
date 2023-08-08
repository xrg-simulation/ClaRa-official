within ClaRa.Visualisation.Fundamentals;
model ScalarToVector
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

 parameter Modelica.SIunits.Time SampleTime=1 "Time interval| can be choiced as hour or second interval. Altogether you can give in all values.";
 parameter Modelica.SIunits.Time simulationTime=200 "Set here the simulation time";
 parameter Integer N=integer((simulationTime) /SampleTime+1) "number of components of the z vector";
public
output Real[N] z "The components of this vector contains the values at each sample time of input variable y";

  Modelica.Blocks.Interfaces.RealInput u "Input signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

protected
  parameter Modelica.SIunits.Time startTime(fixed=false);

initial equation

  startTime = time;

equation
for i in 1:N loop
when  time < (i)*SampleTime+startTime and time >= (i-1)*SampleTime+startTime and sample(startTime,SampleTime) then
  z[i] = u;
end when;
end for;
  annotation (version="0.1",uses(Modelica(version="3.1")),
    experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-104,100},{100,-100}},
          lineColor={27,36,42},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid), Line(
          points={{-98,-100},{-50,-90},{-14,-70},{16,-42},{36,-8},{48,24},{60,
              60},{66,84},{68,100}},
          color={27,36,42},
          smooth=Smooth.Bezier)}));
end ScalarToVector;
