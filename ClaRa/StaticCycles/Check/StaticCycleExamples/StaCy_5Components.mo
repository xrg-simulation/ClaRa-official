within ClaRa.StaticCycles.Check.StaticCycleExamples;
model StaCy_5Components "A Static Cycle with only five components!"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
//  inner parameter SI.MassFlowRate m_flow_nom=417 "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_LS_nom=823 "Live steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_RS_nom=833 "Reheated steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
//   parameter SI.HeatFlowRate Q_nom=boiler.m_flow_LS*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_RS*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"

  final parameter Basics.Units.MassFlowRate m_flow_FW=417*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 annotation (Dialog(group="Condenser"));

//____________________boiler parameter_____________________
//  parameter ClaRa.Basics.Units.HeatFlowRate Q_nom = 1150e6 annotation(Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_LS_out_nom=250.2e5 "Live steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_RS_out_nom=51e5 "Reaheated steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure dp_LS_nom=89e5 "Live steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure dp_RS_nom=5e5 "Reheated steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));

  parameter Real CharLine_dpHP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines", tab="Boiler"));
  parameter Real CharLine_dpIP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines",  tab="Boiler"));

//___________________pump parameter________________________
parameter Real efficiency_Pump_FW=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));

//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1 pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-2,-78},{-22,-58}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-2,42},{8,62}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{20,50},{30,70}})));
  Furnace.Boiler_simple boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom,
    m_flow_LS_nom=417,
    m_flow_RS_nom=417) annotation (Placement(transformation(extent={{-82,2},{-62,22}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{78,2},{98,22}})));
equation
  connect(condenser.outlet, pump_fw.inlet) annotation (Line(
      points={{88,1.5},{88,-68},{-1.5,-68}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-72,22.4},{-72,56},{-2.41667,56}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, condenser.inlet) annotation (Line(
      points={{30.4167,52},{88,52},{88,22.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, turbine_LP.inlet) annotation (Line(points={{-66,22.4},{-66,22.4},{-66,64},{19.5833,64}}, color={0,131,169}));
  connect(turbine_HP.outlet, boiler.coldReheat) annotation (Line(points={{8.41667,44},{8,44},{8,-10},{-68,-10},{-68,1.6}}, color={0,131,169}));
  connect(boiler.feedWater, pump_fw.outlet) annotation (Line(points={{-72,1.6},{-72,1.6},{-72,-68},{-22.5,-68}}, color={0,131,169}));
    annotation (Dialog(group="Global parameter"),
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}},
        initialScale=0.1),
                   graphics),      Diagram(graphics,
                                           coordinateSystem(initialScale=0.1)));
end StaCy_5Components;
