within ClaRa_Obsolete.Components.MechanicalSeparation;
model FeedWaterTank_L3 "Feedwater tank : separated volume approach | level-dependent phase separation"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends ClaRa.Components.MechanicalSeparation.FeedWaterTank_base;
extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_2;
  parameter ClaRa.Basics.Units.Length thickness_wall=0.005*diameter "Thickness of the cylinder wall"  annotation(Dialog(group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/FeedWaterTank_L3.png"));
  parameter ClaRa.Basics.Units.Length thickness_insulation= 0.02 "Thickness of the insulation"
                                                                                              annotation(Dialog(group="Geometry", enable=includeInsulation));
  replaceable model material = TILMedia.SolidTypes.TILMedia_Steel constrainedby TILMedia.SolidTypes.TILMedia_Aluminum "Material of the walls"  annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean includeInsulation=false  "True, if insulation is included" annotation(Dialog(group="Fundamental Definitions"));
  replaceable model insulationMaterial=TILMedia.SolidTypes.TILMedia_StainlessSteel constrainedby TILMedia.SolidTypes.BaseSolid "Insulation material" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions", enable=(includeInsulation==true)));
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  parameter Modelica.Units.SI.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Time Tau_cond=10 "Time constant of condensation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter ClaRa.Basics.Units.Time Tau_evap=Tau_cond*1000 "Time constant of evaporation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"                                                                                              annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of internal structure addtional to feedwater tank wall"
                                                                                                              annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Area A_phaseBorder=volume.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=500 "HTC of the phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  //  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation for calculation of filling level" annotation(Dialog(tab="Phase Separation", group="Numerical Robustness"));
  parameter Modelica.Units.SI.Length z_in=1 "Height of inlet ports" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length z_out=1 "Height of outlet ports" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_liq_start=TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start) "|Initialisation||Initial liquid specific enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_vap_start=TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p_start) "|Initialisation||Initial vapour specific enthalpy";
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (                      alpha_nom={3000,3000}) constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3                        "Heat transfer to the walls"
                                                                                              annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching=true);
  inner parameter Integer initOption = 0 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));
  parameter Modelica.Units.SI.Temperature T_wall_start[wall.N_rad]=ones(wall.N_rad)*293.15 "Start values of wall temperature inner --> outer" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter Integer initOptionWall=1 "Initialisation option for wall" annotation(Dialog(tab="Initialisation", group="Wall"),choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));

  parameter Integer initOptionInsulation=0 "Type of initialisation" annotation (Dialog(tab="Initialisation",group="Insulation", enable=includeInsulation), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));
  parameter ClaRa.Basics.Units.Temperature T_startInsulation=293.15 "Start values of wall temperature" annotation (Dialog(tab="Initialisation",group="Insulation", enable=includeInsulation));

  parameter Boolean enableAmbientLosses=false "Include heat losses to environment "
                                                                                   annotation(Dialog(tab="Heat Losses"));
  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_prescribed=8 "Prescribed heat transfer coefficient" annotation(Dialog(tab="Heat Losses", enable=(enableAmbientLosses==true)));
  input ClaRa.Basics.Units.Temperature T_amb=simCenter.T_amb "Temperature of surrounding medium"
                                                                                                annotation(Dialog(tab="Heat Losses", enable=(enableAmbientLosses==true)));

 model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
   input ClaRa.Basics.Units.Length level_abs "Absolute filling level";
   input Real level_rel "Relative filling level";
   input ClaRa.Basics.Units.HeatFlowRate Q_loss "Heat flow rate from metal wall to insulation/ambient";
 end Outline;

 model Wall
   extends ClaRa.Basics.Icons.RecordIcon;
   input ClaRa.Basics.Units.Temperature T_wall[3] "Temperatures";
 end Wall;

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   Wall wall;
   ClaRa.Basics.Records.FlangeVLE condensate;
   ClaRa.Basics.Records.FlangeVLE tapping;
   ClaRa.Basics.Records.FlangeVLE feedwater;
 end Summary;

  Summary summary(
    outline(level_abs=volume.phaseBorder.level_abs, level_rel=volume.phaseBorder.level_rel,Q_loss = wall.outerPhase.Q_flow),
    wall(T_wall=wall.T),
    tapping(
      showExpertSummary=showExpertSummary,
      m_flow=heatingSteam.m_flow,
      p=heatingSteam.p,
      h=actualStream(heatingSteam.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=heatingSteam.m_flow*actualStream(heatingSteam.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    condensate(
      showExpertSummary=showExpertSummary,
      m_flow=condensate.m_flow,
      p=condensate.p,
      h=actualStream(condensate.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=condensate.m_flow*actualStream(condensate.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      p=outlet.p,
      h=actualStream(outlet.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=-outlet.m_flow*actualStream(outlet.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_3_TwoZones volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_cond_nom + m_flow_heat_nom,
    p_nom=p_nom,
    p_start=p_start,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    showExpertSummary=showExpertSummary,
    redeclare model HeatTransfer = HeatTransfer,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        smoothness=smoothness,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (
        orientation=orientation,
        diameter=diameter,
        length=length,
        z_in={z_in},
        z_out={z_out}),
    equalPressures=equalPressures,
    initOption=initOption) annotation (Placement(transformation(extent={{12,-30},{-8,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    sizefunc=+1,
    N_tubes=1,
    length=length,
    N_rad=3,
    diameter_i=diameter,
    redeclare replaceable model Material = material,
    diameter_o=diameter + 2*thickness_wall,
    T_start=T_wall_start,
    mass_struc=mass_struc + 2*diameter^2/4*Modelica.Constants.pi*thickness_wall*wall.solid[1].d,
    initOption=if ((if ((initOptionWall) == 0) then 213 else (initOptionWall)) == 0) then 213 else (if ((initOptionWall) == 0) then 213 else (initOptionWall))) annotation (Placement(transformation(extent={{-8,6},{12,26}})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={240,-110})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 insulation(
    redeclare model Material = insulationMaterial,
    diameter_o=diameter + 2*thickness_wall + 2*thickness_insulation,
    diameter_i=diameter + 2*thickness_wall,
    length=length,
    N_tubes=1,
    N_ax=1,
    stateLocation=2,
    T_start=T_startInsulation*ones(1),
    initOption=if ((if ((initOptionInsulation) == 0) then 213 else (initOptionInsulation)) == 0) then 213 else (if ((initOptionInsulation) == 0) then 213 else (initOptionInsulation))) if includeInsulation annotation (Placement(transformation(extent={{-8,32},{12,40}})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlow prescribedHeatFlow(
    length=length,
    N_axial=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        length,
        1)) if enableAmbientLosses == true annotation (Placement(transformation(extent={{-56,28},{-36,48}})));
  Modelica.Blocks.Sources.RealExpression heatFlowRatePrescribedAlpha(y=if includeInsulation then -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation) + Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb) else -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall) + Modelica.Constants.pi*(diameter + 2*thickness_wall)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb))
                    if enableAmbientLosses==true annotation (Placement(transformation(extent={{-88,28},{-68,48}})));
equation
  eye_int[1].m_flow=-outlet.m_flow;
  eye_int[1].T=volume.summary.outlet.T-273.15;
  eye_int[1].s=volume.fluidOut.s/1000;
  eye_int[1].h=volume.summary.outlet.h/1000;
  eye_int[1].p=volume.summary.outlet.p/100000;

  connect(volume.inlet, condensate) annotation (Line(
      points={{12,-20},{106,-20},{106,60},{200,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatingSteam, volume.inlet) annotation (Line(
      points={{-200,80},{-200,52},{28,52},{28,-20},{12,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet, outlet) annotation (Line(
      points={{-8,-20},{-134,-20},{-134,-100},{-260,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, volume.heat) annotation (Line(
      points={{1.8,6.4},{2,6.4},{2,-10}},
      color={191,0,0},
      smooth=Smooth.None));
    if includeInsulation then
      connect(wall.outerPhase,insulation.innerPhase[1]);
      if enableAmbientLosses then
         connect(insulation.outerPhase[1],prescribedHeatFlow.port[1]);
         connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    else
      if enableAmbientLosses then
         connect(wall.outerPhase,prescribedHeatFlow.port[1]);
         connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    end if;
   annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                   graphics={
                     Rectangle(extent={{220,-8},{260,-92}}, lineColor={27,36,42},
                               fillColor={153,205,221},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
                     Rectangle(extent=DynamicSelect({{220,-50},{260,-92}}, {{220,summary.outline.level_rel*84-92},{260,-92}}),
                               lineColor={27,36,42},
                               fillColor={0,131,169},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-150,-13},
          rotation=180),
        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-120,-13},
          rotation=180),
        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-90,-13},
          rotation=180),
        Polygon(
          points={{-156,60},{-144,60},{-150,72},{-156,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-126,60},{-114,60},{-120,72},{-126,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,60},{-84,60},{-90,72},{-96,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid)}),
                                         Diagram(graphics,
                                                 coordinateSystem(
          preserveAspectRatio=true, extent={{-220,-120},{120,100}})));
end FeedWaterTank_L3;
