within ClaRa.Visualisation;
model QuadrupleGas " Cross-shaped dynamic display of variables by users choice"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
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

//  parameter String unit="C" "Variable unit";
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel;
  parameter Integer identifier= 0 "Identifier of the quadruple";
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as possible";

  parameter Integer value1=1 "Value 1 to display" annotation (Dialog(group="Values to display"), choices(
      choice=1 "Temperature",
      choice=2 "Mass flow",
      choice=3 "Specific enthalpy",
      choice=4 "Pressure",
      choice=5 "Specific entropy",
      choice=6 "Mass concentration of medium component [1]",
      choice=7 "Mass concentration of medium component [2]",
      choice=8 "Mass concentration of medium component [3]",
      choice=9 "Mass concentration of medium component [4]",
      choice=10 "Mass concentration of medium component [5]",
      choice=11 "Mass concentration of medium component [6]",
      choice=12 "Mass concentration of medium component [7]",
      choice=13 "Mass concentration of medium component [8]",
      choice=14 "Mass concentration of medium component [9]",
      choice=15 "Mass concentration of medium component [10]"));

  parameter Integer value2=2 "Value 2 to display" annotation (Dialog(group="Values to display"), choices(
      choice=1 "Temperature",
      choice=2 "Mass flow",
      choice=3 "Specific enthalpy",
      choice=4 "Pressure",
      choice=5 "Specific entropy",
      choice=6 "Mass concentration of medium component [1]",
      choice=7 "Mass concentration of medium component [2]",
      choice=8 "Mass concentration of medium component [3]",
      choice=9 "Mass concentration of medium component [4]",
      choice=10 "Mass concentration of medium component [5]",
      choice=11 "Mass concentration of medium component [6]",
      choice=12 "Mass concentration of medium component [7]",
      choice=13 "Mass concentration of medium component [8]",
      choice=14 "Mass concentration of medium component [9]",
      choice=15 "Mass concentration of medium component [10]"));

  parameter Integer value3=3 "Value 3 to display" annotation (Dialog(group="Values to display"), choices(
      choice=1 "Temperature",
      choice=2 "Mass flow",
      choice=3 "Specific enthalpy",
      choice=4 "Pressure",
      choice=5 "Specific entropy",
      choice=6 "Mass concentration of medium component [1]",
      choice=7 "Mass concentration of medium component [2]",
      choice=8 "Mass concentration of medium component [3]",
      choice=9 "Mass concentration of medium component [4]",
      choice=10 "Mass concentration of medium component [5]",
      choice=11 "Mass concentration of medium component [6]",
      choice=12 "Mass concentration of medium component [7]",
      choice=13 "Mass concentration of medium component [8]",
      choice=14 "Mass concentration of medium component [9]",
      choice=15 "Mass concentration of medium component [10]"));

  parameter Integer value4=4 "Value 4 to display" annotation (Dialog(group="Values to display"), choices(
      choice=1 "Temperature",
      choice=2 "Mass flow",
      choice=3 "Specific enthalpy",
      choice=4 "Pressure",
      choice=5 "Specific entropy",
      choice=6 "Mass concentration of medium component [1]",
      choice=7 "Mass concentration of medium component [2]",
      choice=8 "Mass concentration of medium component [3]",
      choice=9 "Mass concentration of medium component [4]",
      choice=10 "Mass concentration of medium component [5]",
      choice=11 "Mass concentration of medium component [6]",
      choice=12 "Mass concentration of medium component [7]",
      choice=13 "Mass concentration of medium component [8]",
      choice=14 "Mass concentration of medium component [9]",
      choice=15 "Mass concentration of medium component [10]"));

  Real x1= if value1==1 then eye.T elseif value1==2 then eye.m_flow elseif value1==3 then eye.h elseif value1==4 then eye.p elseif value1==5 then eye.s elseif value1==6 then xi[1] elseif value1==7 then xi[2] elseif value1==8 then xi[3] elseif value1==9 then xi[4] elseif value1==10 then xi[5] elseif value1==11 then xi[6] elseif value1==12 then xi[7] elseif value1==13 then xi[8] elseif value1==14 then xi[9] elseif value1==15 then xi[10] else 0 "Display value 1";
  Real x2= if value2==1 then eye.T elseif value2==2 then eye.m_flow elseif value2==3 then eye.h elseif value2==4 then eye.p elseif value2==5 then eye.s elseif value2==6 then xi[1] elseif value2==7 then xi[2] elseif value2==8 then xi[3] elseif value2==9 then xi[4] elseif value2==10 then xi[5] elseif value2==11 then xi[6] elseif value2==12 then xi[7] elseif value2==13 then xi[8] elseif value2==14 then xi[9] elseif value2==15 then xi[10] else 0 "Display value 2";
  Real x3= if value3==1 then eye.T elseif value3==2 then eye.m_flow elseif value3==3 then eye.h elseif value3==4 then eye.p elseif value3==5 then eye.s elseif value3==6 then xi[1] elseif value3==7 then xi[2] elseif value3==8 then xi[3] elseif value3==9 then xi[4] elseif value3==10 then xi[5] elseif value3==11 then xi[6] elseif value3==12 then xi[7] elseif value3==13 then xi[8] elseif value3==14 then xi[9] elseif value3==15 then xi[10] else 0 "Display value 3";
  Real x4= if value4==1 then eye.T elseif value4==2 then eye.m_flow elseif value4==3 then eye.h elseif value4==4 then eye.p elseif value4==5 then eye.s elseif value4==6 then xi[1] elseif value4==7 then xi[2] elseif value4==8 then xi[3] elseif value4==9 then xi[4] elseif value4==10 then xi[5] elseif value4==11 then xi[6] elseif value4==12 then xi[7] elseif value4==13 then xi[8] elseif value4==14 then xi[9] elseif value4==15 then xi[10] else 0 "Display value 4";

  Real xi[10];

  record DecimalSpaces
  extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer x1=1 "Accuracy to be displayed for value x1";
    parameter Integer x2=1 "Accuracy to be displayed for value x2";
    parameter Integer x3=1 "Accuracy to be displayed value x3";
    parameter Integer x4=1 "Accuracy to be displayed value x4";
  end DecimalSpaces;


  Basics.Interfaces.EyeInGas    eye(medium=medium)  annotation (Placement(
        transformation(extent={{-210,-110},{-190,-90}}), iconTransformation(
          extent={{-210,-110},{-190,-90}})));

equation
   for i in 1:10 loop
     if i<=medium.nc-1 then
       xi[i] = eye.xi[i];
      else if i == medium.nc then
        xi[i] = 1-sum(eye.xi);
     else
        xi[i] = -1;
     end if; end if;
   end for;

  assert(value1-5<=medium.nc,"QuadrupelGas: value1 is outside the range of the medium component vector length");
  assert(value2-5<=medium.nc,"QuadrupelGas: value2 is outside the range of the medium component vector length");
  assert(value3-5<=medium.nc,"QuadrupelGas: value3 is outside the range of the medium component vector length");
  assert(value4-5<=medium.nc,"QuadrupelGas: value4 is outside the range of the medium component vector length");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,0}},
        initialScale=0.05),    graphics={
        Rectangle(
          extent={{-200,0},{200,-200}},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent=DynamicSelect({{-200,0},{0,-100}},if largeFonts then {{-200,0},{0,-100}} else {{-200,-20},{0,-80}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230}, if time> 0 then if eye.m_flow>0 then {118,106,98} else {167,25,48} else {230,230,230}),
          textString=DynamicSelect(if value1 ==1 then " T " elseif value1==2 then " m " elseif value1==3 then " h " elseif value1==4 then " p " elseif value1==5 then " s " elseif value1==6 then " xi " elseif value1==7 then " xi " elseif value1==8 then " xi " elseif value1==9 then " xi " elseif value1==10 then " xi " elseif value1==11 then " xi " elseif value1==12 then " xi " elseif value1==13 then " xi " elseif value1==14 then " xi " elseif value1==5 then " xi " else " 0", String(x1,format = "1."+String(decimalSpaces.x1)+"f") +(if value1==1 then "°C" elseif value1==2 then " kg/s" elseif value1==3 then " kJ/kg" elseif value1==4 then " bar" elseif value1==5 then " kJ/K" elseif value1==6 then " kg_x/kg" elseif value1==7 then " kg_x/kg" elseif value1==8 then " kg_x/kg" elseif value1==9 then " kg_x/kg" elseif value1==10 then " kg_x/kg" elseif value1==11 then " kg_x/kg" elseif value1==12 then " kg_x/kg" elseif value1==13 then " kg_x/kg" elseif value1==14 then " kg_x/kg" elseif value1==15 then " kg_x/kg" else " 0"))),
        Text(
          extent=DynamicSelect({{-200,-100},{0,-200}},if largeFonts then {{-200,-100},{0,-200}} else {{-200,-120},{0,-180}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {118,106,98} else {230,230,230}),
          textString=DynamicSelect(if value3 ==1 then " T " elseif value3==2 then " m " elseif value3==3 then " h " elseif value3==4 then " p " elseif value3==5 then " s " elseif value3==6 then " xi " elseif value3==7 then " xi " elseif value3==8 then " xi " elseif value3==9 then " xi " elseif value3==10 then " xi " elseif value3==11 then " xi " elseif value3==12 then " xi " elseif value3==13 then " xi " elseif value3==14 then " xi " elseif value3==5 then " xi " else " 0", String(x3,format = "1."+String(decimalSpaces.x3)+"f") + (if value3==1 then "°C" elseif value3==2 then " kg/s" elseif value3==3 then " kJ/kg" elseif value3==4 then " bar" elseif value3==5 then " kJ/K" elseif value3==6 then " kg_x/kg" elseif value3==7 then " kg_x/kg" elseif value3==8 then " kg_x/kg" elseif value3==9 then " kg_x/kg" elseif value3==10 then " kg_x/kg" elseif value3==11 then " kg_x/kg" elseif value3==12 then " kg_x/kg" elseif value3==13 then " kg_x/kg" elseif value3==14 then " kg_x/kg" elseif value3==15 then " kg_x/kg" else " 0"))),
        Text(
          extent=DynamicSelect({{0,0},{200,-100}},if largeFonts then {{0,0},{200,-100}} else {{0,-20},{200,-80}}),
          textString=DynamicSelect(if value2 ==1 then " T " elseif value2==2 then " m " elseif value2==3 then " h " elseif value2==4 then " p " elseif value2==5 then " s " elseif value2==6 then " xi " elseif value2==7 then " xi " elseif value2==8 then " xi " elseif value2==9 then " xi " elseif value2==10 then " xi " elseif value2==11 then " xi " elseif value2==12 then " xi " elseif value2==13 then " xi " elseif value2==14 then " xi " elseif value2==5 then " xi " else " 0", String(x2, format = "1."+String(decimalSpaces.x2)+"f") + (if value2==1 then "°C" elseif value2==2 then " kg/s" elseif value2==3 then " kJ/kg" elseif value2==4 then " bar" elseif value2==5 then " kJ/K" elseif value2==6 then " kg_x/kg" elseif value2==7 then " kg_x/kg" elseif value2==8 then " kg_x/kg" elseif value2==9 then " kg_x/kg" elseif value2==10 then " kg_x/kg" elseif value2==11 then " kg_x/kg" elseif value2==12 then " kg_x/kg" elseif value2==13 then " kg_x/kg" elseif value2==14 then " kg_x/kg" elseif value2==15 then " kg_x/kg" else " 0")),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {118,106,98} else {230,230,230})),
        Text(
          extent=DynamicSelect({{0,-100},{200,-200}}, if largeFonts then {{0,-100},{200,-200}} else {{0,-120},{200,-180}}),
          textString=DynamicSelect(if value4 ==1 then " T " elseif value4==2 then " m " elseif value4==3 then " h " elseif value4==4 then " p " elseif value4==5 then " s " elseif value4==6 then " xi " elseif value4==7 then " xi " elseif value4==8 then " xi " elseif value4==9 then " xi " elseif value4==10 then " xi " elseif value4==11 then " xi " elseif value4==12 then " xi " elseif value4==13 then " xi " elseif value4==14 then " xi " elseif value4==5 then " xi " else " 0", String(x4,format = "1."+String(decimalSpaces.x4)+"f") + (if value4==1 then "°C" elseif value4==2 then " kg/s" elseif value4==3 then " kJ/kg" elseif value4==4 then " bar" elseif value4==5 then " kJ/K" elseif value4==6 then " kg_x/kg" elseif value4==7 then " kg_x/kg" elseif value4==8 then " kg_x/kg" elseif value4==9 then " kg_x/kg" elseif value4==10 then " kg_x/kg" elseif value4==11 then " kg_x/kg" elseif value4==12 then " kg_x/kg" elseif value4==13 then " kg_x/kg" elseif value4==14 then " kg_x/kg" elseif value4==15 then " kg_x/kg" else " 0")),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {118,106,98} else {230,230,230})),
        Line(
          points={{0,0},{0,-200}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},if time>0 then {118,106,98} else {190,190,190})),
        Line(
          points={{-200,-100},{200,-100}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},if time>0 then {118,106,98} else {190,190,190}))}),            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -200},{200,0}},
        initialScale=0.05),  graphics));
end QuadrupleGas;
