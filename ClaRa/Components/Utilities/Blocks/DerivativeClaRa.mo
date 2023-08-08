within ClaRa.Components.Utilities.Blocks;
block DerivativeClaRa "Derivative block ( can be adjusted to behave as ideal or approximated)"
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
  import Modelica.Blocks.Types.Init;
  parameter Real k(unit="1")=1 "Gain";
  parameter Modelica.SIunits.Time Tau(min=Modelica.Constants.small)=0.01 "Time constant (Tau>0 for approxomated derivative; Tau=0 is ideal derivative block)";
  parameter Integer initOption = 501 "Initialisation option" annotation(choicesAllMatching,Dialog( group="Initialisation"), choices(choice = 501 "No init (y_start and x_start as guess values)",
                                                                                                    choice=502 "Steady state",
                                                                                                    choice=504 "Force y_start at output"));

  parameter Real x_start=0 "Initial or guess value of state"
    annotation (Dialog(tab="Obsolete Settings", group="Initialization"));
  parameter Real y_start=0 "Initial value of output (= state)"
    annotation(Dialog(enable=initOption == 504, group=
          "Initialization"));
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start));

  output Real x(start=x_start) "State of block";

protected
  parameter Boolean zeroGain = abs(k) < Modelica.Constants.eps;
initial equation
  if initOption == 502 then
    der(x) = 0;
  elseif initOption == 799 then //initialisation with initial state
    x = x_start;
  elseif initOption == 504 then
    if zeroGain then
       x = u;
    else
       y = y_start;
    end if;
  elseif initOption == 501 then
      //Do nothing, use x_start and y_start as guess values
  else
    assert(false, "Unknown init option in derivative instance " + getInstanceName());
  end if;

equation
  der(x) = if zeroGain or Tau < Modelica.Constants.eps then 0 else (u - x)/Tau;
  if zeroGain then
    y=0;
  elseif Tau < Modelica.Constants.eps then
    y=k*der(u);
  else
    y =(k/Tau)*(u - x);
  end if;
  annotation (
    Documentation(info="
<HTML>

</HTML>
"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={221,222,223}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={221,222,223}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,60},{-70,17.95},{-60,-11.46},{-50,-32.05},
              {-40,-46.45},{-30,-56.53},{-20,-63.58},{-10,-68.51},{0,-71.96},
              {10,-74.37},{20,-76.06},{30,-77.25},{40,-78.07},{50,-78.65},{60,
              -79.06}}, color={27,36,42}),
        Text(
          extent={{-30,14},{86,60}},
          lineColor={221,222,223},
          textString="DT1"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="k=%k")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-54,52},{50,10}},
          lineColor={0,0,0},
          textString="k s"),
        Text(
          extent={{-54,-6},{52,-52}},
          lineColor={0,0,0},
          textString="T s + 1"),
        Line(points={{-50,0},{50,0}}, color={0,0,0}),
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255})}));
end DerivativeClaRa;
