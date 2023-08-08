within ClaRa.Components.VolumesValvesFittings.Pipes;
model PipeFlowGas_L4_Advanced "A 1D tube-shaped control volume considering heat transfer in a straight pipe with dynamic momentum balance and simple energy balance."
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.5.1                            //
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

  extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4_advanced(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        N_tubes=N_tubes,
        N_cv=N_cv,
        diameter=diameter_i,
        length=length,
        Delta_x=Delta_x));

  extends ClaRa.Basics.Icons.Pipe_L4_a;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut_th=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerOut_elMech=0,
    powerAux=0) if  contributeToCycleSummary;

//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
  parameter ClaRa.Basics.Units.Length length=1 "|Geometry|Length of the pipe";
  parameter ClaRa.Basics.Units.Length diameter_i=0.1 "|Geometry|Inner diameter of the pipe";

  parameter Integer N_tubes= 1 "|Geometry|Number Of parallel pipes";

//____Discretisation_____________________________________________________________________________________
    parameter Integer N_cv(min=3)=3 "|Discretisation|Number of finite volumes";
public
  inner parameter ClaRa.Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_cv) "|Discretisation|Discretisation scheme";

//________Summary_________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

protected
  ClaRa.Basics.Interfaces.EyeInGas eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{85,-41},{87,-39}})));
public
  ClaRa.Basics.Interfaces.EyeOutGas eye(each medium=medium) if showData annotation (Placement(transformation(extent={{130,-50},{150,-30}}), iconTransformation(extent={{136,-44},{156,-24}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
equation

  eye_int[1].m_flow=-outlet.m_flow;
  eye_int[1].T= fluidOutlet.T-273.15;
  eye_int[1].s=fluidOutlet.s/1e3;
  eye_int[1].p=outlet.p/1e5;
  eye_int[1].h=fluidOutlet.h/1e3;
  eye_int[1].xi=fluidOutlet.xi;
         //fillColor={0,131,169};//DynamicSelect(if time > 0 then (if not FlowModel==FlowModelStructure.inlet_innerPipe_outlet and not FlowModel==FlowModelStructure.inlet_innerPipe_dp_outlet then {0,131,169} else {255,255,255}) else {255,255,255}),
  connect(eye_int[1],eye)  annotation (Line(
      points={{86,-40},{140,-40}},
      color={255,204,51},
      smooth=Smooth.None,
      thickness=0.5));
annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-50},
            {140,50}}),        graphics={
        Polygon(
          points={{-132,42},{-122,42},{-114,34},{-114,-36},{-122,-42},{-132,-42},{-132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {118,106,98},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{132,42},{122,42},{114,34},{114,-36},{122,-42},{132,-42},{132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {118,106,98},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
</html>"));
end PipeFlowGas_L4_Advanced;
