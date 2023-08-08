within ClaRa.Components.Control.PredictorModels_3508;
model TurbinesAndReheat_00_XRG "A predictor for the generator power including the HP and IP/LP turbines as well as the energy storage in the reheater - unmodified"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.1                            //
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

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="00");

 parameter Real eta_Gen= 0.98 "Generator efficiency" annotation(Dialog(group="Nominal Values"));
 parameter Real turbineRatio= 0.33 "Aspect ratio of HP turbine output to total power output"
                                                                annotation(Dialog(group="Nominal Values"));
parameter Modelica.SIunits.Time Tau_HP= (0.2+0.5)/2 "Time Constant for Energy Storage in HP turbine"
                                                                                         annotation(Dialog(group="Time Response Definition"));
parameter Modelica.SIunits.Time Tau_IP= (10+25)/2 "Time Constant for Energy Storage in IP/LP turbine"
                                                                                            annotation(Dialog(group="Time Response Definition"));

  parameter Real m_flow_start_=1 "Initial mass flow rate in p.u." annotation(Dialog(group="Initialisation"));
  Modelica.Blocks.Continuous.FirstOrder energyStorage_HP_turbine(        T=Tau_HP,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    k=turbineRatio,
    y_start=m_flow_start_*turbineRatio)
    annotation (Placement(transformation(extent={{-62,24},{-42,44}})));
  Modelica.Blocks.Continuous.FirstOrder energyStroage_RH_IPLP_turbine(
               T=Tau_IP,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    k=1 - turbineRatio,
    y_start=m_flow_start_*(1 - turbineRatio))
    annotation (Placement(transformation(extent={{-62,-36},{-42,-16}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  input Basics.Interfaces.SteamSignal      inlet       annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,80})));
  Modelica.Blocks.Interfaces.RealOutput P_gen_ "Generator power in p.u."
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Gain gain2(k=eta_Gen)
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
equation

assert(Tau_HP>0 and Tau_IP>0, "Time constants must be greater than zero!");
  connect(energyStorage_HP_turbine.y, add.u1) annotation (Line(
      points={{-41,34},{-36,34},{-36,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(energyStroage_RH_IPLP_turbine.y, add.u2) annotation (Line(
      points={{-41,-26},{-35.5,-26},{-35.5,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.y, P_gen_) annotation (Line(
      points={{69,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inlet.m_flow_, energyStroage_RH_IPLP_turbine.u) annotation (Line(
      points={{-98.1,0.1},{-78,0.1},{-78,-26},{-64,-26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(inlet.m_flow_, energyStorage_HP_turbine.u) annotation (Line(
      points={{-98.1,0.1},{-78,0.1},{-78,34},{-64,34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(add.y, gain2.u) annotation (Line(
      points={{1,0},{46,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Polygon(
          points={{-94,10},{-74,18},{-74,-18},{-94,-10},{-94,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,80},{-94,80},{-94,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-46,100},{6,62}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,18},{-74,80},{-34,80},{-20,92},{-20,68},{-6,80},{20,80},{
              20,18}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{20,20},{40,40},{40,-40},{20,-20},{20,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,40},{100,60},{100,-60},{80,-40},{80,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,40},{60,60},{60,-60},{80,-40},{80,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,40},{40,80},{80,80},{80,40}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-74,2},{20,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,2},{60,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{-94,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(graphics),
    Documentation(info="<html>

</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-07-11: Initial implementation. Friedrich Gottelt, XRG Simulation GmbH</li>
</ul></p>
</html>"));
end TurbinesAndReheat_00_XRG;
