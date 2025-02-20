﻿within ClaRa.Components.Sensors;
model SensorVLE_L3_T
  extends ClaRa.Basics.Icons.Sensor1;

  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_StainlessSteel constrainedby TILMedia.SolidTypes.BaseSolid annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FluidMedium=fluidVolume.simCenter.fluid1 "Medium in the component" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length diameter=0.1 "Diameter of component" annotation (Dialog(group="Component Definition"));
  parameter ClaRa.Basics.Units.Length length=0.1 "Length of component, if considerHeatConduction=true determines length of pipe affected by heat conduction from sensor" annotation (Dialog(group="Component Definition"));
  parameter ClaRa.Basics.Units.Length diameter_o=0.12 "Outer diameter of component" annotation (Dialog(group="Component Definition"));
  parameter Boolean considerHeatConduction=false "True if heat conduction from sensor to pipe wall should be condidered"
                                                                                                                        annotation (Dialog(group="Component Definition"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss in pipe" annotation (choicesAllMatching=true, Dialog(group="Component Definition"));

  parameter ClaRa.Basics.Units.Length thickness_sensor=2e-3 "Thickness of wall between fluid and sensor" annotation (Dialog(group="Sensor Characteristics"));
  parameter ClaRa.Basics.Units.Area A_sensor=2*thickness_sensor*Modelica.Constants.pi*diameter/2 "Surface area" annotation (Dialog(group="Sensor Characteristics"));
  replaceable model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2(alpha_nom=10000) constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2 annotation (choicesAllMatching=true, Dialog(group="Sensor Characteristics"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal Mass Flow Rate" annotation (Dialog(group="Sensor Characteristics"));


  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog( group="Sensor Characteristics"), choices(choice=1 "Kelvin", choice=2 "Degree Celsius",
                                                                                              choice=3 "Degree Fahrenheit"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=1e5 "Start value of fluid's specific enthalpy" annotation (Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of fluid's pressure" annotation (Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[FluidMedium.nc - 1]=fluidVolume.medium.xi_default "Start value for mass fraction" annotation (Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_sensor_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      FluidMedium,
      p_start,
      h_start,
      xi_start) "Start temperature of sensor wall" annotation (Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_wall_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      FluidMedium,
      p_start,
      h_start,
      xi_start) "Start temperature of sensor wall" annotation (Dialog(group="Initialisation"));

  parameter Integer initOptionFluid=0 "Type of initialisation of pipe's fluid" annotation(Dialog(group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed rel.level (for phaseBorder = idealSeparated only)",  choice=205 "Fixed rel.level and steady pressure (for phaseBorder = idealSeparated only)"));

  Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 sensorWall(
    thickness_wall=thickness_sensor,
    redeclare model Material = WallMaterial,
    stateLocation=2,
    CF_area=A_sensor/(sensorWall.length*sensorWall.width),
    mass_struc=A_sensor*thickness_sensor*sensorWall.solid[1].d - sensorWall.length*sensorWall.width*thickness_sensor*sensorWall.solid[1].d,
    T_start=T_sensor_start*ones(sensorWall.N_ax),
    initOption=203) annotation (Placement(transformation(extent={{-10,-4},{10,6}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 fluidVolume(
    redeclare final model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model PressureLoss = PressureLoss,
    h_start=h_start,
    p_start=p_start,
    xi_start=xi_start,
    initOption=initOptionFluid,
    medium=FluidMedium,
    redeclare model HeatTransfer = HeatTransfer,
    m_flow_nom=m_flow_nom,
    heatSurfaceAlloc=2,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinderWithTubes (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        parallelTubes=true,
        diameter=diameter,
        length=length,
        diameter_t=thickness_sensor*2,
        length_tubes=diameter/2,
        z_in={diameter/2},
        z_out={diameter/2},
        CF_geo={1,if considerHeatConduction == true then diameter*length*Modelica.Constants.pi/fluidVolume.geo.A_heat[2] else 1})) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Interfaces.RealOutput T "Temperature in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=FluidMedium) "Inlet port" annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=FluidMedium) "Outlet port" annotation (Placement(transformation(extent={{90,-110},{110,-90}})));

  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 pipeWall(
    N_ax=1,
    T_start=T_sensor_start*ones(sensorWall.N_ax),
    redeclare model Material = WallMaterial,
    diameter_i=diameter,
    length=length,
    diameter_o=diameter_o)
                annotation (Placement(transformation(extent={{-62,-4},{-34,6}})));
equation
  if unitOption == 1 then //Kelvin
    T =sensorWall.outerPhase[1].T;
  elseif unitOption == 2 then // Degree Celsius
    T =Modelica.Units.Conversions.to_degC(sensorWall.outerPhase[1].T);
  elseif unitOption == 3 then // Degree Fahrenheit
    T =Modelica.Units.Conversions.to_degF(sensorWall.outerPhase[1].T);
  else
    T=-1;  //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  connect(fluidVolume.inlet, inlet) annotation (Line(
      points={{-10,-60},{-56,-60},{-56,-100},{-100,-100}},
      color={0,131,169},
      thickness=0.5));
  connect(fluidVolume.outlet, outlet) annotation (Line(
      points={{10,-60},{56,-60},{56,-100},{100,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fluidVolume.heat, sensorWall.innerPhase[1]) annotation (Line(
      points={{0,-50},{0,-4}},
      color={167,25,48},
      thickness=0.5));
  if considerHeatConduction==true then
    connect(sensorWall.innerPhase, pipeWall.innerPhase) annotation (Line(
      points={{0,-4},{-48,-4}},
      color={167,25,48},
      thickness=0.5));
  end if;
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if T > 273.15 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" T ", String(T, format="1.1f"))),
        Text(
          extent={{50,90},{90,60}},
          lineColor=DynamicSelect({230, 230, 230},  if T > 273.15 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect("", if unitOption==1 then "K" elseif unitOption==2 then "°C" else "°F"),
          horizontalAlignment=TextAlignment.Left),                        Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAIwCAYAAACY8VFvAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7d15dFXV+f/xzz43M0OYwpAEDCQEyEWqIoiWKo6t81DnqQ58/Vrbam2106+1ra0d1W+rta2zVetctaK2dcQREbCKSZgCBMgABJIwhQz33v37A0REIAm5+557kvdrrS4g3Ps8j7q6zmfts88+EgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwKeM3wMgMQoKCjJa0/oUKBIbJBMbJKOBnrwcKztIxg6S1UDJG2ikNGvVW8ambv9q/+2/pknqleCxI5I2JbhnIm2R1Or3EI5YI9Po9xBBZ2WzJXkOW/ST2+tA//Y/8jmt2vb/jU807PidsZtlVS+Z9Va23siss1b18rReVvWyZp0XaqusWry4RpLt4uxIcgSYbiS/uDhPMa/ImtBIY+1IKzNSxo6U1ShJw8R/bwA9Q4uklUZ2uTWmUlaV1pjKUFQV0eaMspqaeU1+D4iu44IWRNOmpYyoWjsmKpUYKWxlJ0pmkqQhfo8GAEnPqlbGzjMy86xUFpLKV1aUl4tVm0AhwARAXtGEfKPIEdZqqowOkRTWtls6AID4aLDS+8bYtz3pzVDb1vcrKyub/R4Ke0aASUJ5o8YWW8+bamSOMNKXrOxIv2cCgB6mRUZzZPWWidm3m7y2t+srKjb6PRQ+RYBJAvn5+Zk2s9/RUuxkWXOiZPP8ngkA8Bltkt6WzPMmFptRtWzBEr8H6ukIMD4ZWlSUE7Kpx8uYkyR9RVIfv2cCAHTYMmv1vEJ2Rv9U782ysrLu+kRh0iLAJNDgkeOHpKVEz7XWnCdpsvj3DwDdQb2snrTWPFyzrOwdsRk4IbiAOlZQUJDRmtLrWCN7kaTTJKW29x0AQGCtslbPGM/cX72k7EO/h+nOCDBumLzC8JHyYhfLmjPE7SEA6HGMzDwZ+2BKW9qDlZUfcrBjnBFg4ignHO6d3qzzrbHfkjTe73kAAEmhWTJPmqi5uWp56Xy/h+kuCDBxkD9q3GhrvG/I6BJtO/obAIDded0Yc0dVXs4/NXNmxO9hgowA0wW5xeOOUcx810jHye37SgAA3csqa3VbW4b5a11Z2Wa/hwkiAsw+yC0ed4yJmV9ImuL3LACAQFtvpD+lRNL+wD6ZziHAdML24HKTtj0CDQBAXBhpY0z2LymtKb9dufLjhva/AQJM+0z+6PAZ1tqfSPqC38MAALozs0E2dttW03Yzry7YOwLMXgwfFZ5kjb3FGn3J71kAAD3KemPsL6ryhtzBZt/dI8DsRm7h+OHG2Jske6H4dwQA8M9CSTdUV5Q/6fcgyYaL805ywuHe6S32Oit9X1KG3/MAACBJMnpVMtdxuu+nCDDbmLzCcRfJeDdLNsfvYQAA+DwTlXR7a7p+wqPXBBiNKN5/VCwW+YuVOc7vWQAA6IAaY+03q5YueMbvQfzUcwPMtGkp+dVrvmGtuUlSL7/HAQCgc+zzxoteWbV4cbXfk/ihRwaY/OLwZGtjd8uaCX7P4qdQKKQB/fupf7/t/+vfT/3791evrCylpW17aXa/7G1vRkhNTVVWZqYvc27YtLHbvpy+ta1NTU1Nfo/hjt3+3w+dlpaWpswMd1vxMtLTleGwfnp6mjLSO18/Gotq8+YtO/68ecsWRSIRtbW1qaFxgxobG7f/ukGNGzaoobFRsVgsnqMHTYOVrqupKL/P70ESrWcFmGnTUvJWrblBxvuRZEN+j+Nan969NTw/TyNGDNeI/DwNz8/XiOHbfh2Sk6Ps7L5+jwgAXVa3br2qa2q0qqpaq6qrVVVVo1XV1Vq1qkqVK1cpEukRTyE/F1Xr9NUVFXV+D5IoPSbADB07tiAU9R6S1VS/Z3FhcE6OJowv0YTxYRWPLlJxUaFGFxXKmB7znxgAPicSjWrZsuVaXLFUi5dUaH5pmT4qLVNd3Tq/R3NhrYy9rHrJghf8HiQResTVLa9w3MUy5k+S+vg9Szz07tVLB088UIccPFGTJ03U+JJx6pWV5fdYABAYtavXaPbceZoz9wO9N2eullQs7S63oqxk/piplh9UVFS0+D2MS906wBQUHNCvLbXtL7L2XL9n6YpeWVmaetgUHXrIJE0+eKLC48YqFOr2d8AAIGEaN2zQnHn/1ew5c/XazDe1uGKp3yN1jbHzo9Y7b3VFWbnfo7jSbQNM/sjxE2wo9oykUX7Psi9yBg3U4VO/qJOO/7KOmHqY0tLS/B4JAHqMVdXVevOtd/Xya6/rzXdmqbW11e+R9sVmSZdXV5Q/4fcgLnTLAJM/Ony+tfZuSYG6r1I0aqROPflEHXf0kQqPG+v3OAAAbXsS6o233tGzM17QqzPfDFqYscaam6uWlv1QUtTvYeKpewWYadNScqvW/NLIfN/vUTqqX3a2Tjz+OH311FM0aeKBbLoFgCS2adMm/eeV1/SPZ2fonfdmB2jfjHkjYkNnr1k6f63fk8RLt7laDimcMDjFRJ+Q7BF+z9KelJQUfeXYo3XWGafqiC9NVQr7WQAgcKqqa/TUs8/p4Uef0Oo1a/wep31WldbojJqK8v/6PUo8dIsAkz9q7P7W816QNNzvWfZm0MABOv+cs3Tx+edo6JAhfo8DAIiDSDSqf7/0iu5/6BHNnjPX73Ha02Sl82sqyv/p9yBdFfgAk1cYPkpGT0s22+9Z9mTC/mFddtEFOuXE49mMCwDdWPnCRbr/oUf09D9nqKUlWZ9iNlGr2NU1FQv+7PckXRHoAJNXVHKWpAcluTsPuwsmTTxQV10xXcceNc3vUQAACbRufb3uuu8B3f/Q37V1a7Pf4+yWtbqtZmn5tZKCspHnMwIbYPJHj7vGWnOrJM/vWXY1aeKB+u7V39TUw6b4PQoAwEfr6+v1t4cf1d0PPKRNmzb5Pc7uPJUaabqosrIyOVPWXgQxwITyisK3S/brfg+yqyOmHqbrvv0tHfiFHv2OSADALuobGvSXu+7TvQ8+nIyPYb/WEoqetm7RoqRMWHsStAATyhs97l5Z8zW/B9lZ4ciRuv7ab+mk47/s9ygAgCRWU7tav731j3r6nzNkrfV7nB2s7Fwv3ftyVVlZvd+zdFSQAkwor6jkAUkX+j3IJ/r366dvf/NKfe3C83kUGgDQYR/NL9WNv/6dZs+d5/coO/tAKbHjqhcuXO/3IB0RiAATDofTGptjj8qYM/yeRZJSQiFNv/RiXfONK9Wnd2+/xwEABJC1Vv98/kX97KbfaN36pFn4CEyISfoAEw6H0za02MetdJrfs0hSeNxY/f6mGzVh/7DfowAAuoGNGzfppt/fokcefyopbisZqTwlYo6urCxb7fcse5PUASYcDqc1tthnJR3v9yy9srJ0/bXf0qUXXcCboAEAcffue+/r+z/5mZZXrvB7FEkqVUpsWjKvxCTzlTiUlp3ziKRT/R7kiKmH6aF779S0w6fK85LuqW0AQDcwPD9PF5xzptpa2/TBhx/5vRozWDFzRMawwY811dUl3WNTUvKuwJi80SV/ldUVfg6Rlpam6675pq6cfinBBQCQMO++976uuf4Hql3t+zuWXstU6wkVFRVJd6xwUq7A5BaV/NpI1/g5Q3FRoR66906d+JXjeEM0ACChhufn6byzzlB1dY0WLl7i5ygjowqN3zgh/A9VVibVib1JF2ByC0uuM0Y3+tXfGKNLL75Ad93+fxo2dKhfYwAAerj09HSd8JXjNGzYUL397ixFIhG/Rhnbd9OWoZvq617wa4DdSaoAk1c47mJjzB3y6dZWr6ws3XbLb3Xl5ZcqJSXFjxEAAPiM/cMlOubIaXrj7Xe0YeNGv8aYmD0gx2ysr5vp1wC7SpoAkzsqPNV4elKSL8mhYL8Reuxv9+iwKZP9aA8AwB7lDBqkr552isoWLNSKlav8GuPw7AE5FRvr6z72a4CdJUWAGTp2bIFnzcuSsv3of9S0w/XwvXcqLy/Xj/YAALQrIyNDZ5xykjIzMvTOe7P9eErJSDqh74BBr26qX1eV6Oa78j3AjBo1Ktva1NckFfjR/+qr/le/++XPlZmZ4Ud7AAA6zBijSRMPUuGokXr5tZmKRqOJHiHFypzUp/+QJzY1rPXtfpYk+f1scKjFS3/YSiUJbxwK6dc33qDvXXs1j0gDAALllBOP15MP368B/fsnvLeRhhoTey4nHPb1XTq+XrlzC0tulcxJie7bKytL9//1T7rovHMS3RoAgLiYeOABeuqRvynfn+0PB6Q1x/4mH8+T8+0WUl5RydnG6OZE983JGaRHHrhbUyZPSnRrAADiauCAATr1xBM0a/YcrVlbl9jmxozrO2Dwhk31de8ltvH29n40zR0zZoyJhuZI6pPIvvl5uXriofs1Ynh+ItsCAODUpk2bdNH0KzX3gw8T3bpNih1RXbFwVqIbJ/wWUkFBQYaJhh5VgsPL8Lw8wgsAoFvq06ePHnngHn3x0EMS3TpV8p7ILS4elOjGCQ8wbSlZf5Z0YCJ7jhpZoKcfe4jwAgDotrIyM/XAnX/Wlw47NNGt841NeUwJ3paS0GZ5o8OXSPpZInuOLhylJx++X0OHDE5kWwAAEi41NUUnHX+cPvq4NNEH3o3qOyCnZVN93VuJapiwPTDDi8YXxhT7UFLCHrsq2G+Ennn0IeXkJHxlCwAA3zQ3N+uCS6/Q7LnzEtm2LWZjh9YuXZiQpom6heRFFbtPCQwvQwYP1iMP3E14AQD0OBkZGXrg7j9r/3BCj1lL9Yz3UH5+fmYimiUkwOQXhb9npMMT0UvatpnpwXv+ohH57HkBAPRMfXr31sP33anCkSMT2Xaczej7y0Q0cn4LaURRSTgqzZWUkLP6MzMz9Pf77tbkgw9KRDsAAJJaTe1qnX7uhaquqU1Uy5iRd3RVRelMl02crsCEw+G0qLGPKEHhJRQK6c7b/o/wAgDAdrnDhur+O+9Qr6ysRLX0rI3dP2jMGKfHpTgNMI3N+omsmeCyx85u+OH1Ompawu5UAQAQCCVjx+j2W3+XuHf/GRWkR1N+67KFs8eo80aNLZZnHpaU4qrHzs4766v6/ne/nYhWAAAETuGokUrPSNdb7yTs0NyJfQcMfHlT/boqF8VdBRjTd+DgJySNdlT/M6ZMnqS//PFmhUK+vdoJAICkN2niQVq9dq0+LitPRDsjeZOLR464p7a2Nhbv4k6u+LmjSy41UkKWQ0aNLNDjD96nrKyEPLUFAECgTfvSVL31zizVrl6TiHZDNrdEGzfV18V92SfuTyHljR07UJHQAsnmxLv2rtLT0/XPJ/6u8SXjXLcCAKDbqKldra+ceqbqGxoS0a4pmhILr164sDKeReO/myfi/T4R4UWSfvnT/0d4AQCgk3KHDdUffverRG3qzfKioVvjXTSut5Byi8YdZGTuUALOlzntpBP0/e9c47oNAADd0siC/dTS2qr3537gvJeRxvUZOOjdTfXrlsWrZlwDzPaNu/vFs+buFI8u0v133aHU1FTXrQAA6LamHDJJ770/V1XVNc57GZnxm+rr7pZk41EvbmtHeUXhM2U1NV719iQtLU133Pp7ZWWyaRcAgK5ICYX0p1t/q+zsvolod2BeYfiieBWLywpMOBxOa47af0gaGI96e/OD676t4487xnUbAAB6hN69e2vwoBz955VX3TczZlJW/rA7t6xZ09bVUnFZgWlotlcrAWe+TJp4oK649Guu2wAA0KOcdcapOvErxyWgk81L2Rr9TjwqdXmzbX44PMC22ApJ/eMwzx717tVLL814WiOG84ZpAADibd36eh1z4qlat77edavNbVGvaO3y0i4dRNPlFRjbqu/IcXiRpJ/84HrCCwAAjgwaOEC/+vkNiWjVOzUUu76rRboUYAoKDugna7/R1SHaM/ngg3T+OWe6bgMAQI92wpeP1bFHTUtEq68PHjl+SFcKdCnAtKW2XSepX1dqtCclFNIvf/pjGeP8aBkAAHq8X/70x+qVleW6TVZaSuy6rhTY56eQ8sPhASZiH5GU3pUB2nPV/07X6aec5LIFAADYrm+fPgqFQnrrXedvrT4gM3vIvVsa127Zly/v8wqMbdV3rOT0wfH8vFxdfdX/umwBAAB2ccXll6hk7BjXbbq0CrNPAaag4IB+xtpv7WvTjvrFDf+PA+sAAEiwlFBIN/7kh877WKurcouLB+3Ld/cpwERS2v7X9erLYVMmJ2ojEQAA2MWUyZP05WOOct0my9jQlfvyxU7vjJ04cWLq6g1bl0oavi8NO8LzPD3/j8c0YXzYVQsAANCOFStXadpXTlZbW5cPzt2btamRpv0qKyubO/OlTq/ArNmw9Ww5DC+SdPYZpxFeAADw2X4jhuvC88523WZwW2qvczv7pX24hWSu7fx3Oi4rM1PXX+t8ew0AAOiAa7/5dfXt28dxl1ins0WnAkx+0dgjrOzEzjbpjMsvuUhDBg922QIAAHTQgP79dcVll7htYs2E3OJxnXpTc6cCTMyEruncRJ3Tu1cvXXEZL2sEACCZXH7xBcrOdvrsjkzMXN2Zz3c4wBQUhIcaa52eKHfZ1y5U/35OD/YFAACd1KdPH02/5GLHXcwJuYXjO7zHtsMBpi3FXiopdZ9m6oBeWVm6/GsXuioPAAC6YPolF6lfdrbDDjZkvGiHb8N0NMAYSZfv20Adc9nXLtTAAQNctgAAAPuoT+/emn6p41WYmLlcHcwmHToHJm9UydHy9EqXhtqL9PR0vTfzZeUMGuiqBQAA6KINGzZq8uFHa0tTk7MeVt6XaypKX2rvcx1bgQmZ6V2eaC/OOv1UwgsAAEkuO7uvzv7qaU57GMU6lDnaXYEZMWL//tG0aK0cvXXaGKPX/z1DRaNGuigPAADiqHLFSh1+3ImKxWKuWrQqJZZbvXDh+r19qN0VmEha5Aw5Ci+SdPS0wwkvAAAERMF+I3Tc0Ue6bJFm2kJfbe9D7QYYY02nj/ftjP+5lHNfAAAIkv9xvJnXGntOe5/Za4AZUjhhsIymxW2iXRSNGqnDpkx2VR4AADhwyKSDVTJ2jMsW04aPGZO7tw/sNcCkKnKOpJS4jrSTC849W8Z0+oXYAADAZ+eedYbL8p6Nhc7c6wf29pfWmPPiO8+nUlNTdcapTg/2BQAAjpx52qnKzMxwVt/avd9G2mOA2Xacr50S/5G2Of64Yzi4DgCAgOrbt4+OP+5Yhx3MoXt7tcCeV2BM9GR18KC7fXH+2XtdGQIAAEnu/LPbfVioK4wx0T3eqtljgDHGnOhmHikvd5i+eOghrsoDAIAEOGTSwRqRn++ugfX2mEV2G2Dy8/MzZd09fXTqiSeweRcAgIAzxujkE7/isIGOys2dmLW7v9ptgIllZB8rabdfiIdTTjreVWkAAJBAp5zo8ppuM02vlqN29ze7DTDGWGe3jwpHjtT4knGuygMAgAQKjxur0YWj3DWIxXabSXa/B8bKWZw6xeVSEwAASLiTT3B6G+mE3f34cwEmb9TYYkl7fGypq046/suuSgMAAB+c+JXjXJYfkV8YLtr1h58LMMaEprmbIF9jike7Kg8AAHwwpni006eRYiZ2xK4/+1yAiRn7uQ/Fy9FHOSsNAAB8dPSRhzurbeS1H2CMjLOUccw0AgwAAN3R0U6v8fbIXX/ymQCzbf+LzXPROiszU1MmH+yiNAAA8NlhUyard69ersrnDy8aX7jzDz4TYIwJOYtPUw+bovT0dFflAQCAj9LS0nTYlMnO6kcVnbbznz8TYKyxh7pqzKsDAADo3g49xF2AkfSZILHLHhjj7B6P438oAADgs0MPmeSsttklo+wIMNveNWCdHJHbLztbY3l8GgCAbq1k7Bj179fPVfnx+fn5mZ/84dMVmMyWAySluOg45ZBJ8rw9vvgaAAB0A57nafLBB7kqn6rMvhN29Pr059ZZxymTJroqDQAAksiUye5uI8Xsp7eRdgQY48Wc7X856IAvuCoNAACSyIFfmND+h/aRkd2xIvLpCow1TjqmhEIqGTvGRWkAAJBkwuPGKiUUclV+x4qIt9OvTlLGmOLRysjIcFEaAAAkmczMDI0eXdj+B/fNGElG2h5ghowZs5+kLBedJuw/3kVZAACQpL4w3tm1v1fuqPBwaXuASY2ExrrqNGF8iavSAAAgCe3v8trvmbHS9gBjjXFy/oskjRvD/hcAAHoSl9d+z0THSZ8EGMWcrcAUjipwVRoAACSh0UWjnNW2sZ1WYIzk5JjcQQMHuDyRDwAAJKH+/fpp4IABboobFUs7Aoy3n4seRYXOdiEDAIAk5vAOzAhpW4AxVjbXRYfRhe6WkAAAQPIqcpcB8iUZb/DI8YMlpbvoMLLAycIOAABIcg4zQMbQoqJBXrqxI1x1yMsd5qo0AABIYnnD3GUAT6nDPRsyw101yB021FVpAACQxHIdBhjJDPcUi+W5Kj9s6BBXpQEAQBJzu4hh8j0ZDXRROiUlRTmDBrkoDQAAktyQwTkuX+o40ItZ9XdRecjgHIXcDQ4AAJJYKBRSTo6bhQwj9feMkZOTZgb0d5KLAABAQDg7zNbE+ntyFGCys/u6KAsAAAKiX79sN4WtGeDJGidLJf2yHQ0NAAACIbuvo8UMo/6eZJ2s7/Tt28dFWQAAEBCuFjOsVX9PVpkuivfrywoMAAA9mavtJJ5MlidHrxHIyMxwURYAAAREZoabLGBlUz0ZpboonpqS4qIsAAAIiJRUZ1kgzTNSmovKqalOchEAAAgIh1kgzbOOAkxaGgEGAICeLM1lgBErMAAAwIG0NCcRQ5JJ9xxVBgAAcMaT1OqicFtbm4uyAAAgIFpbnUQMSbbFM44CTGsrAQYAgJ6s1d1iRqtnWYEBAAAOOMwCrZ6snFRvi0RclAUAAAERaXOWBVo9SS0uKjdvbXZRFgAABMTWZjdZwMi0eTLa6qJ448YNLsoCAICA2LBho5O6MdkmT7INLoo3NhJgAADoyRoaG53U9azqPVnPSYDZsNFN6gIAAMHQ6GgFxho1eDKqd1GcFRgAAHq2Da62k1jVe9a6uYXkatkIAAAEg7PFDGMaPc/ISYBZu7ZO0WjURWkAAJDkItGo1tatc1PcqN6T1XoXtSPRqOrWORocAAAktTVr1jpbyLA2tt6TbJWT6pJqale7Kg0AAJJYdU2tw+pelWdsaJWr8gQYAAB6pprV7jKAMVrptVg5CzBu0xcAAEhWNbXuMkDUtlR7a5eXrpWj1wksr1zhoiwAAEhyyytXuirdtLqios6TZCVVu+hQsWy5i7IAACDJVSxd6qp0lSR5235vncQkh8MDAIAktnRZpZvCZtvWF0+SrLTERY916+s50A4AgB5mfX296hucHDMnWbNY2h5gjLyFbro4TGAAACApudxCYoxdKH0SYKxd4KpR+UJn2QgAACSh8nJ31/6Y9T4NMJHUmLMA83FpuavSAAAgCc0vK3NX3GqBtD3ArF64cKWkJhd9Pvq41EVZAACQpD6a7+zav7lmaenOTyEpJmmRi06Ll1SoubnZRWkAAJBktjQ1aenySie1jcwibTv+ZUeAkaw+ctEsEo2qbAH7YAAA6AlKy8qdvcRR0oef/GZHgLEy81x1++9H812VBgAASeS/H33srLZVbEdW2RFgjInNddXwvfedlQYAAElk1uw5zmp7sdCO4jsCTGpk64eS2lw0fO/9uYrFYi5KAwCAJBGNRjXngw9clW9N95p3LO/sCDCVlZXNkpw899S4YYMWLFrsojQAAEgSpWULtHHjJie1rez8ioqKHS+f9j77l8bZvZ5Zs993VRoAACSBd993d6039rMZxfvsH2KzXTV+Z5az0gAAIAm43P8iz3wmSHwmwCimN1z1fWfWbLW0tLT/QQAAEDjNzc1O77ZEvMhnMspnAkzVsgVLJFPtonHT1q169z1uIwEA0B29+c4sbd3q7ODaVWsWLfrMGyK9XT9hZZ2twrw601lpAADgI6fXeGNf2/VHnwswnjXOJnj5tZmuSgMAAJ9Ya/XazDfd1dfns8nnAoxs7HVXA1TX1GrR4iWuygMAAB+Uli9Q7eo1zupHvejMXX/2uQCzbR+MVrkaYsaL/3ZVGgAA+OD5f/3HWW0js3zX/S/S7lZgJMnqBVeDPDPDWWkAAOADlwEmZuzzu/v57gOM5zlLGStWrtL8UicH/gIAgAT74MOPtGKlsxs3Clmz20yy2wBjtja+KqnJ1TDPvfAvV6UBAEACPfeC060hW0KRLbt9uGi3Aaaqqmqr9PlHluLluRf+xcsdAQAIuFgs5nj/i17e/q7Gz9n9LSRJMrtfsomHmtrVeuc9Xi0AAECQvfXOLK1e4+7po5h2v/9F2luAsSnPS7IuBpKkRx5/ylVpAACQAH9//EmX5WOpqXpxT3+5xwBTXTG/SkbvuJlJ+vfLr2p9fb2r8gAAwKG6dev1sGuxJgAAF5VJREFU0qvOjo6TpDdWLFhQu6e/3PMKjCQbM4/Hf55t2tra9I9nZ7gqDwAAHHry6WcViUTcNTDaawbZa4CJxMyTkonGd6JPPfoEt5EAAAgaa60effIfLltEorb16b19YK8BZu3y0jWSnD2NtGTpMr397nuuygMAAAdmvvm2lleucNni5dUVFXV7+8BeA4wkWcWc3UaSpLvu/5vL8gAAIM7uus/xtdu2v4Wl3QCT0prytKSWuAy0G6+/8ZYWVyx1VR4AAMTRgoWL9fYsp3dPmlOjqf9s70PtBpiVKz9ukDHPxGemz7PW6p4HHnRVHgAAxNFd9z8ga52dsiJJT1VWftjY3ofaDTCSpJju7vI4e/HUM8+prm6dyxYAAKCL6tatd/3qAHnGdihzdCjAVC8te13Ski5NtBetra2698GHXZUHAABxcOe996ulxdmuEklavGrJgrc68sGOrcBI1sjc14WB2nXf3x7mYDsAAJJUfUODHnrE6XM9slZ3q4NvAehogFFr1NwvqW1fh2pP09atuvt+9sIAAJCM7rjzHm1panLZojWqlA4HgQ4HmLXLS9fIWqdH5z7w0COqb2hw2QIAAHRS3br1evCRxxx3Mc+sWTp/bUc/3eEAI0mepz92fqCO27xli+689wGXLQAAQCf99Z77tHVrs+Mu0U5lDNPZ8nlFJe9JOqSz3+uojIwMvfnSC8odNtRVCwAA0EG1q9fo8ONOcBxg7LvVFQu+2JlvdGoFRpKsMU5XYZqbm3XzH2532QIAAHTQTb+7JQGrL97/dfobnf1CTV7Ok5JWdvZ7nfHUs89p/sdlLlsAAIB2fDj/Y/3z+RfdNrGqrM7PebazX+t0gNHMmRFr5XSJJBaL6cbf/N5lCwAA0I5f/Pr3rk/dlfHsHzRzZqSz3+t8gJGUYZvvlsyGffluR733/hz95xVnL8IGAAB78a+XXtHsufNct2lo9mL7dM7cPgWYZcuWbZCN3bYv3+2MG37xKzVt3eq6DQAA2MnWrc36xa/d3wmxMn9Yt2jRpn357j4FGElKjabfKqndly11RXVNrf7wp7+4bAEAAHZx8x9v18qqKsddzIa0SOo+L4bsc4CprPywUdY6f1zornsfUPnCRa7bAAAASQsXLda9f0vA+wmNbunIW6f3ZJ8DjCSl25Zb5HgVJhKN6vs//plisZjLNgAA9HixWEzf/8nPFYl0ek9tZzWmtqV2aREk1JUvNzQ0tGQPyMmSdERX6rRn9Zo1Gjw4R1/Yf7zLNgAA9GgPPPyo/v74k+4bGfOrVcs+fqlLJbo6Q0HBAf3aUlqXShrQ1Vp70ysrSy/NeFr7jRjusg0AAD3SsuWV+vKpX03AoXVat1WthfUVFRu7UqRLt5Ck7XthZH/R1Trt2dLUpKuv+4Gi0ajrVgAA9CiRaFTf/t6PEhFeZGV+1tXwIsUhwEjS0OysOyQtiUetvZn33w/113vud90GAIAe5Y4779YHH37kvpE1i4ZlZ9wVj1JdvoX0ifzR48+wNvaPeNXbk9TUVL3w9OMqGTvGdSsAALq90vIFOvnM89TW1ua8l5U5paaibEY8asUtwEhSfmHJm9boS/GsuTvFRYV6/unHlZWZ6boVAADd1pamJp14+tmqWLY8Ee1er64oPypexeJyC+kTMaNrJDl/3nlxxVJd/6MbXLcBAKBb+9FPf5Go8BKL2dj18SzYpceod7Wpvm519oCc/SQdGM+6u7No8RINHTJE+48vcd0KAIBu529/f1R/+uvdCellZe+pXbowLntfPhHXW0iSlB8OD7AtWijZnHjX3lV6erqeffxh7R8mxAAA0FHlCxfplLPOV3Oz+6eOJK2zXmRczeLF6+JZNK63kCSpqqysXlZxXSbak5aWFn39mu9qw4YuP40FAECP0NDYqOlfvzpR4UVGujbe4UVyEGAkqXpp2YOSXnNRe1eVK1bqsq9/KyG7pwEACLJIJKIrr/5OAl7U+AnzRlVF+d9dVHYSYCRZxWJfl5SQeDd7zlz98IYbE9EKAIDA+vHPb9I7s2Ynql2L9bwrJVkXxeO6iXdnmxrWrc8ekJMmx+9J+kRp+QL17dtHBx3whUS0AwAgUO6672+6/a9x3Ue7d8bcWLOk9GlX5Z0FGEkaPmzwu81RnSxpqMs+n3jr3fc0YXyJRhUUJKIdAACB8Mrrb+i6H/1E1jpZDPkcIzNvaHbGpbW1tc6OVon7U0i7GloULgnJzpOU4bqXJGVmZujv992tyQcflIh2AAAktQ8+/EjnXny5mrZuTVTLFs/ag1ctXVDqsonTFRhJ2lxfV9dn4KBWI3Os617Stg1KL770io48fKoG5wxKREsAAJLSwkWLde4l07V585YEdjXfq1pa/pzzLq4bbOflFYVfk2xC9sNI0qCBA/T0ow9p1MiCRLUEACBprFi5Sqede6Hq6uL+BPOeGb1dvaT8CCXgVH5XTyHtKhbyvMskbUpQP61bX6+Lpl+ptXV1iWoJAEBSWL1mjc69+PKEhhcjbYyGYhcpAeFFSlyA0crFHy+Ttd9MVD9pW/o864JLtWbt2kS2BQDANzW1q3XWhZdqVXV1oltftXrhwspENUtYgJGk6qULHjQy9yay59Lly3Xa2Rcm8NAeAAD8UV1Tq7MuvETLK1cktrHVna4OrNuThAYYSUqJbPmmpA8S2XNVdbXOuuASrVi5KpFtAQBImKrqGp11oQ/XOmPnm5aN1ya2qQ8BprKystlYc46REvoCo+qaWp190aWqXLEykW0BAHBu2fJKnX7uhVq5KuF3Gxo9GzqjqqoqYc9ofyLhAUaSqpaWVcSki+XoeOE9qa6p1clnnqc58/6byLYAADjz4fyPdcZ5F6l29ZpEt7bGmOmrKkqXJrqxlIBzYPZkU33dor4DcvpKOjSRfZubmzXjhX9p7JhiFY4sSGRrAADi6t8vv6pLr/yGNm5M2EO+Oxhrbq6qKLst4Y238y3ASNKm+rpX+g7IOUjSmET2bYtE9Py//qP+/frpgAn7J7I1AABx8egTT+na7/1Ira1tCe9tpX9XLy2/XAm+k7IzXwOMJJs6IPuFFIVOMdLghDa2Vq+98aaaW1r0xUMPkTGJOtMPAIB9F41GddPvbtGvb/6DYgl6t9FnmY9bQ9Hjm9avb/ah+adT+Nn8E0PHji0IRbzZSnCI+cS0w6fqT7f+Tv2ys/1oDwBAhzRu2KBvfPs6vfH2u36NsM6TN8WvfS87S4oAI0m5heMPMyb2mqR0P/rn5Q7T3Xf8URPGh/1oDwDAXpUvXKTpV13tx5NGn2g1ih1XVbHwDb8G2Jnft5B22NSwdlX2gJxKSafLh2C1adNmPfPc8xoxPF9ji0cnuj0AAHv0zHPP6/Kvf0vr19f7NYI10qVVFQtm+DXArpImwEjSxvq6+X0HDN4k6ct+9G+LRPTif17WuvX1+uKhhyglJcWPMQAAkCRt3dqsn9x4k3576x8ViUR8nMR+p7piwV0+DvA5SRVgJGlTfd2svgMHp0o63K8ZPvq4VC/+52VNPOgADRmc49cYAIAebH5pmS649Aq98fY7vs5hpBurKxb8xtchdiPpAowkbaqve61v/8H9ZTTFrxnqGxr1+FPPKBaL6ZBJB/OUEgAgIay1uu/Bh3XVt6/TuvXrfZ7G/Lm6ovx6n4fYraQMMJK0qaHupb4DB4+RNN6vGWKxmGa9P0fvz/tAhxw8UdnZff0aBQDQA1SuWKnpV12jhx97QrFYzNdZrPRITUX5/8jHs172JmkDjCQ7YtjgGc0Rc5CMiv0cZFVVtR554imlpqbqwC9MkOf58gYGAEA3FYlE9Oe77tVV116vFSuT4p19zw3Lzjy/trY26vcge5L090XC4XBaQ6seM9ae7vcskjRubLF+f9ONnOALAIiL0vIF+t7/+6nml5b5Pcp29vlMtZ1ZUVHR4vcke5PMKzCSpLq6umjxyBFPb26JjJNU4vc869at1+P/eEYbNmzUQQd8QenpvhxbAwAIuA0bNuqm39+i7//4Z1q9JuEvYtyTJ4ZmZ51TVlbW6vcg7Un6FZidhPKKwvdL9iK/B/lEv+xsXXXF5Zp+yUVKS0vzexwAQABEIhE9/tQz+v0fbtM6/851+TxjHqvOy7lIM2f6+bx2hwUpwEhSKK+w5B4ZXeL3IDsbNbJA37v2ap10vC/H1wAAAuKtd2fpp7/8jRYvqfB7lM+w0iM1+YO/FpTwIgUvwEiSl19U8kcrfdPvQXZ12JTJuu6ab2nywQf5PQoAIInMnjNXv/u/2zV7zly/R/kca3VbzdLyayX5+9hTJwUxwEiS8kePu8Zac6ukpHskaNLEA3XVFdN17FHT/B4FAOCj9+d+oD/fdY9eeT0pXh+0K2ukG6sqyn/m9yD7IrABRpLyR4e/aq19WFKG37PsDkEGAHqm9+d+oFtu+5PemTXb71H2pMVae0nN0gWP+T3Ivgp0gJGkvKKxh0rec5IG+T3LnowvGaeLzjtHZ5x6sjIzkzJrAQC6qLW1VS+9+rruvv9Bzfvvh36PszcNnrGnrVqy4E2/B+mKwAcYSRpaFC4JWfuCjAr8nmVvBvTvr/PO/qouPv9c5eUO83scAEAcVFXX6MFHHtNjTz6t+oYGv8fZKyOzPGrMibVLShf4PUtXdYsAI0m5xcWDjE15TFZH+z1Le0KhkI49+kidfcZpOvLwqUpNTfV7JABAJ7S1tem1N97SE/94Rq+8/oai0aQ9sHYn5mWlRM+rXrjQ7xcsxUW3CTDbhXKLxt1kZL6ngPyzZWf31TFHTtOZp5+iqYdO4aWRAJDE5peW6alnntNzL7yYXGe47J21VrfXDB/83SA9Jt2ebnm1zCsqOVvSfZJ6+T1LZ4ws2E+nnXSCjj36SO0fLiHMAIDPrLX6uLRcL736mp59/kVVrkiK9xR1xmZJl1VXlD/p9yDx1m2vkLnF+481sejTksb5Pcu+GDhggKYdPlXHHjVN0w6fqt69ApXFACCwmpubNeeD/+rlV2fqXy+9rNrVSXPMf2dVeNaevmrpglK/B3Gh2wYYSRo1alR2s5dxh5Eu8HuWrsjIyNBhUybr0EMm6ZCDJ2rC/uOVEkr611gBQCBEolHN/7hU782Zq1mz52jW7Dlqbm72e6wuMg9tVcs36ysqNvo9iSvdOsB8In90+Hxr9WfJZvs9SzxkZWbq4IMO1ORJEzVl0kSFS8apT+/efo8FAIGwafNmlS9YqFnvz9X7c+Zp7gf/VdPWrX6PFS+N1tqvB/l8l47qEQFGknJHhUfIsw8Z6XC/Z3FhcE6OJowvUfHoIhUXFWrC+LBGFxWyjwZAj7Zm7VrNLy3XkoqlWrSkQh+Xlqli2XLFYoE6Nb+DzKyQ5124cvHHy/yeJBF62tUtlDd63A9lzU8lpfg9jGuZmRkaMXy4RuTnbft1eN6OP+fkDFL/fv0IOAACy1qrhsZG1dWt04pVVVpVVaUVK7f/uv3PW7cG/VZQh7RJ+ml1RfnvJAXhee646JFXr9yikgM9mbut7ES/Z/GT53nq36+f+vfL1oAB/bf/vp+ysrKUkZEuSerbp488z1NqaqqyMjN9nhhAd7elqUmRSETRaFSbNm+WJDU1Nam5uUX1DQ1qaGxUQ0OjGho3qL6hQdZanyf2mdEcGfM/1YvLPvJ7lETrkQFmOy+/MDzdGnuzpD5+DwMAQCc0GZkbqyrKblYPWnXZWU8OMJKk/OLivJhNvd1Ye7rfswAA0C6jF2MRe1Xt8gUr/B7FTz0+wHwid3T4PFl7q5GG+j0LAACfY1VrZa+tWbrgcb9HSQYcJrLdpvq60qz8YX8NtdmNkqZISvN7JgAAJDVZ2VubTds5a5cu/sDvYZIFKzC7kV9cnGdtyg2ymi7J83seAECPZCU9FU2JfW/1woWVfg+TbAgwezGscOxEz4RukewRfs8CAOhR3pNi36muWDjL70GSFQGmA3KLwqd40g09/bFrAIBjRnMk78bqJaXP+z1KsiPAdEJu8bhjTMz8Qtv2yAAAEC/vWZlf1VSUPa9tt47QDgLMPsgdFZ5qPPtzSUf5PQsAIMjsu1beb2oqymb4PUnQEGC6IK8wfJSk78jY48VmXwBAx8Qk+6Ksd2v10rLX/R4mqAgwcTC8aHxhTLGrJF0mqZ/f8wAAklKDMbrXM6G/9JQXLrpEgImjgoKCjLZQ5tny9F1ZM8HveQAASWGhMfavbZmp96yZP3+L38N0FwQYR4aPHne4td7FVjpTstl+zwMASKhGK/ukYt6DNcvK3vZ7mO6IAONYUVFRepPSjzOyF0k6VZzwCwDdlInK2tcl+5DdmvVUTc28Jr8n6s4IMAmUW1w8SNHUc42JnSeZKWLjLwAEXUzSLCvzqEmJPla9cOF6vwfqKQgwPskbO3agIt5RkjnZyJ5qpb5+zwQA6JAmyb5mrDcjlBabsWLBglq/B+qJCDBJoKioKL1F6dOsYidba06UUYHfMwEAPmVklkv2hZi8GVlqfqOioqLF75l6OgJMEho+ZkxuLBr6ooyOMVZTrTRO/LcCgERaJpl3jNXbnrHvrKwoL/N7IHwWF8UAGD5mTG404h1ujPclIx1iZcOSMvyeCwC6iWYrW+pJs63Mmymp9i1uCyU/AkwQTZuWMqJm/YhILBb2ZCdue8mkKZE0yu/RACDJNUgqt1bzjOy8mGxZLxMp5ZZQ8BBgupEhhRMGhxQdbUxslJU30pjYKGvNSCONlJQnnnoC0P3FJFVbabkxdrm13jKj2HJrvWVRhZasWTp/rd8DIj4IMD1EUVFRenMsdUTMeINlNFDGDpTsIC/m5VhjB0kaKGmgkcmwUppke23/al9JIUmpknr7NT+AHmOzpDZtCyIbJMlKWz2ZZqtYi2TWSVpvjNbHZNdKZp2sWS+r9Z6Nrc3w2laymtIzEGAAdNiwwrETPePNdVE7ZmMH1y5dOM9FbQDdD7cUAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4BBgAABA4Px/kXkADj3Q2R4AAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/Resources/Images/Components/Sensor1.png"),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="TIT"),
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-98,-100},{100,-100}},
          color={0,131,169},
          thickness=0.5)}),                                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end SensorVLE_L3_T;
