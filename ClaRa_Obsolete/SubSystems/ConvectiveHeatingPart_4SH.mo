within ClaRa_Obsolete.SubSystems;
model ConvectiveHeatingPart_4SH "A set of convective heat exchangers including 3 HP superheaters and the spray injectors"
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

  inner outer ClaRa.SimCenter simCenter;
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple superheater1(
    N_cv=N_ax,
    length=length_SH1,
    diameter_i=diameter_i_SH1,
    N_tubes=N_tubes_SH1,
    m_flow_nom=m_flow_nom,
    medium=medium,
    h_start=linspace(
        h_startSH1_in,
        h_startSH1_out,
        superheater1.N_cv),
    p_start=linspace(
        p_startSH1_in,
        p_startSH1_out,
        superheater1.N_cv),
    initOption=initOptionSH1,
    useHomotopy=useHomotopy,
    p_nom=linspace(
        p_nomSH1_in,
        p_nomSH1_out,
        superheater1.N_cv),
    h_nom=linspace(
        h_nomSH1_in,
        h_nomSH1_out,
        superheater1.N_cv),
    showData=true,
    redeclare model HeatTransfer = HeatTransfer_SH1,
    redeclare model PressureLoss = PressureLoss_SH1) "Comprehending the supporting tubes section" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-190})));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder" annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

    parameter Integer N_ax=3 "Number of axial cells in flow direction" annotation(Dialog(group="Fundamental Definitions"));
    parameter Integer N_rad=3 "Number of axial cells in radial direction" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                             annotation(Dialog(group="Fundamental Definitions"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet"
                                       annotation(Dialog(group="Nominal Values"));

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  replaceable model HeatTransfer_SH1 =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4     annotation(Dialog(tab= "Superheater 1", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_SH1 =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4  annotation(Dialog(tab= "Superheater 1", group="Fundamental Definitions"), choicesAllMatching);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH1_in=0.3 "Inner diameter of the superheater1 inlet header"
                                                       annotation(Dialog(tab= "Superheater 1", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH1_in=0.4 "Outer diameter of the superheater1 inlet header"
                                                       annotation(Dialog(tab= "Superheater 1", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH1_in=2 "Length of the  SH1 outlet header"
                                       annotation(Dialog(tab= "Superheater 1", group="Geometry"));
 parameter Integer N_tubes_SH1_in=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 1", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length length_SH1=10 "Total length of SH1 pipes" annotation(Dialog(tab= "Superheater 1", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SH1=0.05 "Inner diameter of the SH1 pipes"
                                      annotation(Dialog(tab= "Superheater 1", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH1=0.06 "Outer diameter of the SH1 pipes"
                                      annotation(Dialog(tab= "Superheater 1", group="Geometry"));
  parameter Integer N_tubes_SH1=300 "Number Of parallel pipes in SH1" annotation(Dialog(tab= "Superheater 1", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH1_out=0.3 "Inner Diameter of SH1 outlet header"
                                          annotation(Dialog(tab= "Superheater 1", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH1_out=0.4 "Outer Diameter of SH1 outlet header"
                                          annotation(Dialog(tab= "Superheater 1", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH1_out=2 "Length of the  SH1 outlet header"
                                       annotation(Dialog(tab= "Superheater 1", group="Geometry"));
 parameter Integer N_tubes_SH1_out=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 1", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Pressure p_nomSH1_in=300e5 "Nominal pressure at inlet of SH1"
                                      annotation(Dialog(tab= "Superheater 1", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH1_in=2700e3 "Nominal specific enthalpy at inlet of SH1"
                                                annotation(Dialog(tab= "Superheater 1", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure p_nomSH1_out=300e5 "Nominal pressure at SH1 outlet"
                                     annotation(Dialog(tab= "Superheater 1", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH1_out=3050e3 "Nominal specific enthalpy at SH1 outlet"
                                              annotation(Dialog(tab= "Superheater 1", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSH1=2e5 "Nominal pressure drop at SH1"
                                     annotation(Dialog(tab= "Superheater 1", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH1_in=2700e3 "Start value of sytsem specific enthalpy at SH1 inlet"
                                                           annotation(Dialog(tab= "Superheater 1", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH1_in=1e5 "Start value of sytsem pressure at SH1 inlet"
                                                  annotation(Dialog(tab= "Superheater 1", group="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH1_out=3050e3 "Start value of specific enthalpy at SH1 outlet"
                                                     annotation(Dialog(tab= "Superheater 1", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH1_out=300e5 "Start value of pressure at SH1 outlet"
                                            annotation(Dialog(tab= "Superheater 1", group="Initialisation"));
  parameter Integer initOptionSH1=0 "Type of initialisation of SH1"
    annotation (Dialog(tab="Superheater 1", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  replaceable model HeatTransfer_SH2 =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4
                                                                                            annotation(Dialog(tab= "Superheater 2", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_SH2 =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4 annotation(Dialog(tab= "Superheater 2", group="Fundamental Definitions"), choicesAllMatching);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH2_in=0.3 "Inner diameter of the SH2 inlet header"
                                              annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH2_in=0.4 "Outer diameter of the SH2 inlet header"
                                              annotation(Dialog(tab= "Superheater 2", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH2_in=2 "Length of the  SH2 outlet header"
                                       annotation(Dialog(tab= "Superheater 2", group="Geometry"));
 parameter Integer N_tubes_SH2_in=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 2", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length length_SH2= 10 "Total length of SH2 pipes" annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SH2= 0.05 "Inner diameter of the SH2 pipes"
                                      annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH2= 0.06 "Inner diameter of the SH2 pipes"
                                      annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Integer N_tubes_SH2= 300 "Number Of parallel pipes in SH2" annotation(Dialog(tab= "Superheater 2", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH2_out=0.3 "Inner Diameter of SH2 outlet header"
                                          annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH2_out=0.4 "Outer Diameter of SH2 outlet header"
                                          annotation(Dialog(tab= "Superheater 2", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH2_out=2 "Length of the  SH2 outlet header"
                                       annotation(Dialog(tab= "Superheater 2", group="Geometry"));
  parameter Integer N_tubes_SH2_out=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 2", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Pressure p_nomSH2_in=300e5 "Nominal pressure at inlet of SH2"
                                      annotation(Dialog(tab= "Superheater 2", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH2_in=3000e3 "Nominal specific enthalpy at inlet of SH1"
                                                annotation(Dialog(tab= "Superheater 2", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure p_nomSH2_out=300e5 "Nominal pressure at SH1 outlet"
                                     annotation(Dialog(tab= "Superheater 2", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH2_out= 3300e3 "Nominal specific enthalpy at SH1 outlet"
                                              annotation(Dialog(tab= "Superheater 2", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSH2=2.8e5 "Nominal pressure drop at SH2"
                                     annotation(Dialog(tab= "Superheater 2", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH2_in=3000e3 "Start value of sytsem specific enthalpy at SH2 inlet"
                                                           annotation(Dialog(tab= "Superheater 2", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH2_in=1e5 "Start value of sytsem pressure at SH2 inlet"
                                                  annotation(Dialog(tab= "Superheater 2", group="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH2_out=3300e3 "Start value of specific enthalpy at SH2 outlet"
                                                     annotation(Dialog(tab= "Superheater 2", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH2_out=300e5 "Start value of pressure at SH2 outlet"
                                            annotation(Dialog(tab= "Superheater 2", group="Initialisation"));
  parameter Integer initOptionSH2=0 "Type of initialisation of SH2"
    annotation (Dialog(tab="Superheater 2", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  replaceable model HeatTransfer_SH3 =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4
                                                                                            annotation(Dialog(tab= "Superheater 3", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_SH3 =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4 annotation(Dialog(tab= "Superheater 3", group="Fundamental Definitions"), choicesAllMatching);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH3_in=0.3 "Inner diameter of the SH3 inlet header"
                                              annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH3_in=0.4 "Outer diameter of the SH3 inlet header"
                                              annotation(Dialog(tab= "Superheater 3", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH3_in=2 "Length of the  SH3 outlet header"
                                       annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Integer N_tubes_SH3_in=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 3", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length length_SH3= 10 "Total length of SH3 pipes" annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SH3= 0.05 "Inner diameter of the SH3 pipes"
                                      annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH3= 0.06 "Inner diameter of the SH3 pipes"
                                      annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Integer N_tubes_SH3= 300 "Number Of parallel pipes in SH3" annotation(Dialog(tab= "Superheater 3", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH3_out=0.3 "Inner Diameter of SH3 outlet header"
                                          annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH3_out=0.4 "Outer Diameter of SH3 outlet header"
                                          annotation(Dialog(tab= "Superheater 3", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH3_out=2 "Length of the  SH3 outlet header"
                                       annotation(Dialog(tab= "Superheater 3", group="Geometry"));
  parameter Integer N_tubes_SH3_out=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 3", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Pressure p_nomSH3_in=300e5 "Nominal pressure at inlet of SH3"
                                      annotation(Dialog(tab= "Superheater 3", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH3_in=3250e3 "Nominal specific enthalpy at inlet of SH3"
                                                annotation(Dialog(tab= "Superheater 3", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure p_nomSH3_out=300e5 "Nominal pressure at SH1 outlet"
                                     annotation(Dialog(tab= "Superheater 3", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH3_out= 3450e3 "Nominal specific enthalpy at SH3 outlet"
                                              annotation(Dialog(tab= "Superheater 3", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSH3=4.1e5 "Nominal pressure drop at SH3"
                                     annotation(Dialog(tab= "Superheater 3", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH3_in=3250e3 "Start value of sytsem specific enthalpy at SH3 inlet"
                                                           annotation(Dialog(tab= "Superheater 3", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH3_in=1e5 "Start value of sytsem pressure at SH3 inlet"
                                                  annotation(Dialog(tab= "Superheater 3", group="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH3_out=3450e3 "Start value of specific enthalpy at SH3 outlet"
                                                     annotation(Dialog(tab= "Superheater 3", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH3_out=300e5 "Start value of pressure at SH3 outlet"
                                            annotation(Dialog(tab= "Superheater 3", group="Initialisation"));
  parameter Integer initOptionSH3=0 "Type of initialisation of SH3"
    annotation (Dialog(tab="Superheater 3", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  replaceable model HeatTransfer_SH4 =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4
                                                                                            annotation(Dialog(tab= "Superheater 4", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_SH4 =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4 annotation(Dialog(tab= "Superheater 4", group="Fundamental Definitions"), choicesAllMatching);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH4_in=0.3 "Inner diameter of the SH3 inlet header"
                                              annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH4_in=0.4 "Outer diameter of the SH3 inlet header"
                                              annotation(Dialog(tab= "Superheater 4", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH4_in=2 "Length of the  SH3 outlet header"
                                       annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Integer N_tubes_SH4_in=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 4", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length length_SH4= 10 "Total length of SH4 pipes" annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SH4= 0.05 "Inner diameter of the SH4 pipes"
                                      annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH4= 0.06 "Inner diameter of the SH4 pipes"
                                      annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Integer N_tubes_SH4= 300 "Number Of parallel pipes in SH4" annotation(Dialog(tab= "Superheater 4", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_i_SH4_out=0.3 "Inner Diameter of SH3 outlet header"
                                          annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_o_SH4_out=0.4 "Outer Diameter of SH3 outlet header"
                                          annotation(Dialog(tab= "Superheater 4", group="Geometry"));
   parameter Modelica.SIunits.Length length_SH4_out=2 "Length of the  SH3 outlet header"
                                       annotation(Dialog(tab= "Superheater 4", group="Geometry"));
  parameter Integer N_tubes_SH4_out=1 "Number of parallel headers" annotation(Dialog(tab= "Superheater 4", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Pressure p_nomSH4_in=300e5 "Nominal pressure at inlet of SH4"
                                      annotation(Dialog(tab= "Superheater 4", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH4_in=3250e3 "Nominal specific enthalpy at inlet of SH4"
                                                annotation(Dialog(tab= "Superheater 4", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure p_nomSH4_out=300e5 "Nominal pressure at SH4 outlet"
                                     annotation(Dialog(tab= "Superheater 4", group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nomSH4_out= 3450e3 "Nominal specific enthalpy at SH4 outlet"
                                              annotation(Dialog(tab= "Superheater 4", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSH4=4e5 "Nominal pressure drop at SH4"
                                     annotation(Dialog(tab= "Superheater 4", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH4_in=3250e3 "Start value of sytsem specific enthalpy at SH4 inlet"
                                                           annotation(Dialog(tab= "Superheater 4", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH4_in=1e5 "Start value of sytsem pressure at SH4 inlet"
                                                  annotation(Dialog(tab= "Superheater 4", group="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy h_startSH4_out=3450e3 "Start value of specific enthalpy at SH4 outlet"
                                                     annotation(Dialog(tab= "Superheater 4", group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_startSH4_out=300e5 "Start value of pressure at SH4 outlet"
                                            annotation(Dialog(tab= "Superheater 4", group="Initialisation"));
  parameter Integer initOptionSH4=0 "Type of initialisation of SH4"
    annotation (Dialog(tab="Superheater 4", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_o_SI1=0.5 "Outer diameter of spray injector 1"
                                         annotation(Dialog(tab="Spray Injector 1", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SI1=0.45 "Inner diameter of spray injector 1"
                                         annotation(Dialog(tab="Spray Injector 1", group="Geometry"));
  parameter Modelica.SIunits.Length length_SI1=3 "Length of spray injector 1" annotation(Dialog(tab="Spray Injector 1", group="Geometry"));
  parameter Integer N_SI1=1 "Number of identical injectors in parallel"  annotation(Dialog(tab="Spray Injector 1", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_nom_Spray1=1000e3 "Nominal specific enthalpy of spray1"
                                          annotation(Dialog(tab="Spray Injector 1", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nom_SI1=1000 "Nominal pressure loss over spray injector 1"
                                                   annotation(Dialog(tab="Spray Injector 1", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSpray1=20e5 "Nominal pressure loss over spray valve 1"
                                               annotation(Dialog(tab="Spray Injector 1", group="Nominal Values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nomSpray1=10 "Nominal injection mass flow rate od injector 1"
                                                     annotation(Dialog(tab="Spray Injector 1", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_start_Spray1=1000e3 "Initial specific enthalpy of spray 1"
                                           annotation(Dialog(tab="Spray Injector 1", group="Initialisation"));
  parameter Integer initOption_Spray1=0 "Type of initialisation" annotation (Dialog(tab="Spray Injector 1", group="Initialisation"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length diameter_o_SI2=0.5 "Outer diameter of spray injector 2"
                                         annotation(Dialog(tab="Spray Injector 2", group="Geometry"));
  parameter Modelica.SIunits.Length diameter_i_SI2=0.45 "Inner diameter of spray injector 2"
                                         annotation(Dialog(tab="Spray Injector 2", group="Geometry"));
  parameter Modelica.SIunits.Length length_SI2=3 "Length of spray injector 2" annotation(Dialog(tab="Spray Injector 2", group="Geometry"));
  parameter Integer N_SI2=1 "Number of identical injectors in parallel" annotation(Dialog(tab="Spray Injector 2", group="Geometry"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_nom_Spray2=1000e3 "Nominal specific enthalpy of spray2"
                                          annotation(Dialog(tab="Spray Injector 2", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nom_SI2=1000 "Nominal pressure loss over spray injector 2"
                                                   annotation(Dialog(tab="Spray Injector 2", group="Nominal Values"));
  parameter Modelica.SIunits.Pressure Delta_p_nomSpray2=20e5 "Nominal pressure loss over spray valve 2"
                                               annotation(Dialog(tab="Spray Injector 2", group="Nominal Values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nomSpray2=10 "Nominal injection mass flow rate od injector 2"
                                                     annotation(Dialog(tab="Spray Injector 2", group="Nominal Values"));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.SpecificEnthalpy h_start_Spray2=1000e3 "Initial specific enthalpy of spray 2"
                                           annotation(Dialog(tab="Spray Injector 2", group="Initialisation"));
  parameter Integer initOption_Spray2=0 "Type of initialisation" annotation (Dialog(tab="Spray Injector 2", group="Initialisation"));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH3_InletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    p_nom=p_nomSH3_in,
    h_nom=h_nomSH3_in,
    h_start=h_startSH3_in,
    p_start=p_startSH3_in,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH3_in,
        length=length_SH3_in,
        Nt=N_tubes_SH3_in),
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    initOption=initOptionSH3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,10})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH2_OutletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH2_out,
        length=length_SH2_out,
        Nt=N_tubes_SH2_out),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    h_nom=h_nomSH2_out,
    h_start=h_startSH2_out,
    p_start=p_startSH2_out,
    p_nom=p_nomSH2_out,
    m_flow_nom=m_flow_nom + m_flow_nomSpray1,
    initOption=initOptionSH2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-26})));

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-10,-260},{10,-240}}),
        iconTransformation(extent={{-4,-282},{16,-262}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{-10,240},{10,260}}),
        iconTransformation(extent={{-4,260},{16,280}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heatSH1[N_ax]
    annotation (Placement(transformation(extent={{-114,-200},{-94,-180}}),
        iconTransformation(extent={{-130,-210},{-110,-190}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple superheater2(
    N_cv=N_ax,
    medium=medium,
    redeclare model HeatTransfer = HeatTransfer_SH2,
    length=length_SH2,
    diameter_i=diameter_i_SH2,
    N_tubes=N_tubes_SH2,
    redeclare model PressureLoss = PressureLoss_SH2,
    p_nom=linspace(
        p_nomSH2_in,
        p_nomSH2_out,
        superheater2.N_cv),
    h_nom=linspace(
        h_nomSH2_in,
        h_nomSH2_out,
        superheater2.N_cv),
    p_start=linspace(
        p_startSH2_in,
        p_startSH2_out,
        superheater2.N_cv),
    initOption=initOptionSH2,
    useHomotopy=useHomotopy,
    h_start=linspace(
        h_startSH2_in,
        h_startSH2_out,
        superheater2.N_cv),
    m_flow_nom=m_flow_nom + m_flow_nomSpray1,
    showData=true) "Comprehending the supporting tubes section" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-56})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple superheater3(
    N_cv=N_ax,
    medium=medium,
    redeclare model HeatTransfer = HeatTransfer_SH3,
    length=length_SH3,
    diameter_i=diameter_i_SH3,
    N_tubes=N_tubes_SH3,
    redeclare model PressureLoss = PressureLoss_SH3,
    p_nom=linspace(
        p_nomSH3_in,
        p_nomSH3_out,
        superheater3.N_cv),
    h_nom=linspace(
        h_nomSH3_in,
        h_nomSH3_out,
        superheater3.N_cv),
    p_start=linspace(
        p_startSH3_in,
        p_startSH3_out,
        superheater3.N_cv),
    initOption=initOptionSH3,
    useHomotopy=useHomotopy,
    h_start=linspace(
        h_startSH3_in,
        h_startSH3_out,
        superheater3.N_cv),
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    showData=true) "Comprehending the supporting tubes section" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,34})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heatSH2[N_ax]
    annotation (Placement(transformation(extent={{-120,-66},{-100,-46}}),
        iconTransformation(extent={{-134,-50},{-114,-30}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heatSH3[N_ax]
    annotation (Placement(transformation(extent={{-120,24},{-100,44}}),
        iconTransformation(extent={{-134,42},{-114,62}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH1_InletHeader(
    medium=medium,
    redeclare final model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    m_flow_nom=m_flow_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    p_nom=p_nomSH1_in,
    h_nom=h_nomSH1_in,
    h_start=h_startSH1_in,
    p_start=p_startSH1_in,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH1_in,
        length=length_SH1_in,
        Nt=N_tubes_SH1_in),
    initOption=initOptionSH1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-219})));

  ClaRa.Components.VolumesValvesFittings.Fittings.SprayInjectorVLE_L3 sprayInjector1(
    medium=medium,
    length=length_SI1,
    diameter_o=diameter_o_SI1,
    diameter_i=diameter_i_SI1,
    useHomotopy=useHomotopy,
    h_nom_Main=h_nomSH1_out,
    h_nom_Spray=h_nom_Spray1,
    m_flow_nom_spray=m_flow_nomSpray1,
    h_start_Main=h_startSH1_out,
    h_start_Spray=h_start_Spray1,
    initOption=initOption_Spray1,
    N=N_SI1,
    m_flow_nom_main=m_flow_nom,
    Delta_p_nom=Delta_p_nom_SI1,
    p_nom=p_nomSH1_out,
    p_start=p_startSH1_out,
    showData=true,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{13,16},{-13,-16}},
        rotation=270,
        origin={0,-120})));

  ClaRa.Basics.Interfaces.FluidPortIn spray1(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{94,-132},{114,-112}}),
        iconTransformation(extent={{116,-110},{136,-90}})));
  Modelica.Blocks.Interfaces.RealInput opening1 "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-154}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={112,-160})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH1_OutletHeader(
    medium=medium,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH1_out,
        length=length_SH1_out,
        Nt=N_tubes_SH1_out),
    m_flow_nom=m_flow_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    p_nom=p_nomSH1_out,
    h_nom=h_nomSH1_out,
    h_start=h_startSH1_out,
    p_start=p_startSH1_out,
    initOption=initOptionSH1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-162})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH2_InletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH2_in,
        length=length_SH2_in,
        Nt=N_tubes_SH2_in),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    p_nom=p_nomSH2_in,
    h_nom=h_nomSH2_in,
    h_start=h_startSH2_in,
    p_start=p_startSH2_in,
    m_flow_nom=m_flow_nom + m_flow_nomSpray1,
    initOption=initOptionSH2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-80})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH3_OutletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH3_out,
        length=length_SH3_out,
        Nt=N_tubes_SH3_out),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    p_nom=p_nomSH3_out,
    h_nom=h_nomSH3_out,
    h_start=h_startSH3_out,
    p_start=p_startSH3_out,
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    initOption=initOptionSH3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,64})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 SH3_wall(
    N_ax=N_ax,
    diameter_o=diameter_o_SH3,
    diameter_i=diameter_i_SH3,
    length=length_SH3,
    N_tubes=N_tubes_SH3,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,34})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 SH2_wall(
    N_ax=N_ax,
    diameter_o=diameter_o_SH2,
    diameter_i=diameter_i_SH2,
    length=length_SH2,
    N_tubes=N_tubes_SH2,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,-56})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 SH1_wall(
    N_ax=N_ax,
    diameter_o=diameter_o_SH1,
    diameter_i=diameter_i_SH1,
    length=length_SH1,
    N_tubes=N_tubes_SH1,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,-190})));

public
  ClaRa.Basics.Interfaces.Bus Sensors annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={128,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={122,180})));
  Modelica.Blocks.Sources.RealExpression realExpression[4](y={sprayInjector1.eye.T,
        superheater3.eye.T,sprayInjector2.eye.T,superheater4.eye.T})
    annotation (Placement(transformation(extent={{26,-88},{46,-68}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH1_inWall(
    diameter_o=diameter_o_SH1_in,
    diameter_i=diameter_i_SH1_in,
    length=length_SH1_in,
    N_tubes=N_tubes_SH1_in,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-210})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH1_outWall(
    diameter_o=diameter_o_SH1_out,
    diameter_i=diameter_i_SH1_out,
    length=length_SH1_out,
    N_tubes=N_tubes_SH1_out,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-156})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH2_inWall(
    diameter_o=diameter_o_SH2_in,
    diameter_i=diameter_i_SH2_in,
    length=length_SH2_in,
    N_tubes=N_tubes_SH2_in,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,-74})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH2_outWall(
    diameter_o=diameter_o_SH2_out,
    diameter_i=diameter_i_SH2_out,
    length=length_SH2_out,
    N_tubes=N_tubes_SH2_out,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,-22})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH3_inWall(
    diameter_o=diameter_o_SH3_in,
    diameter_i=diameter_i_SH3_in,
    length=length_SH3_in,
    N_tubes=N_tubes_SH3_in,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,14})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH3_outWall(
    diameter_o=diameter_o_SH3_out,
    diameter_i=diameter_i_SH3_out,
    length=length_SH3_out,
    N_tubes=N_tubes_SH3_out,
    N_rad=N_rad,
    sizefunc=+1,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,68})));

  ClaRa.Components.VolumesValvesFittings.Fittings.SprayInjectorVLE_L3 sprayInjector2(
    medium=medium,
    diameter_o=diameter_o_SI2,
    diameter_i=diameter_i_SI2,
    length=length_SI2,
    h_nom_Main=h_nomSH2_out,
    h_nom_Spray=h_nom_Spray2,
    m_flow_nom_spray=m_flow_nomSpray2,
    h_start_Main=h_startSH2_out,
    initOption=initOption_Spray2,
    h_start_Spray=h_start_Spray2,
    useHomotopy=useHomotopy,
    N=N_SI2,
    m_flow_nom_main=m_flow_nom + m_flow_nomSpray1,
    Delta_p_nom=Delta_p_nom_SI2,
    p_nom=p_nomSH2_out,
    p_start=p_startSH2_out,
    showData=true,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{13,16},{-13,-16}},
        rotation=270,
        origin={-2,102})));
  ClaRa.Basics.Interfaces.FluidPortIn spray2(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{88,92},{108,112}}),
        iconTransformation(extent={{116,90},{136,110}})));
  Modelica.Blocks.Interfaces.RealInput opening2 "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={98,52}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={112,40})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH4_InletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH3_in,
        length=length_SH3_in,
        Nt=N_tubes_SH3_in),
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    p_nom=p_nomSH4_in,
    h_nom=h_nomSH4_in,
    h_start=h_startSH4_in,
    p_start=p_startSH4_in,
    initOption=initOptionSH4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,154})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple superheater4(
    N_cv=N_ax,
    medium=medium,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    showData=true,
    length=length_SH4,
    diameter_i=diameter_i_SH4,
    N_tubes=N_tubes_SH4,
    h_start=linspace(
        h_startSH4_in,
        h_startSH4_out,
        superheater4.N_cv),
    p_start=linspace(
        p_startSH4_in,
        p_startSH4_out,
        superheater4.N_cv),
    initOption=initOptionSH4,
    p_nom=linspace(
        p_nomSH4_in,
        p_nomSH4_out,
        superheater4.N_cv),
    h_nom=linspace(
        h_nomSH4_in,
        h_nomSH4_out,
        superheater4.N_cv),
    redeclare model HeatTransfer = HeatTransfer_SH4,
    redeclare model PressureLoss = PressureLoss_SH4) "Comprehending the supporting tubes section" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,178})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 SH4_OutletHeader(
    medium=medium,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_i_SH3_out,
        length=length_SH3_out,
        Nt=N_tubes_SH3_out),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom + m_flow_nomSpray1 + m_flow_nomSpray2,
    p_nom=p_nomSH4_out,
    h_nom=h_nomSH4_out,
    h_start=h_startSH4_out,
    p_start=p_startSH4_out,
    initOption=initOptionSH4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,208})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 SH4_wall(
    N_ax=N_ax,
    diameter_o=diameter_o_SH4,
    diameter_i=diameter_i_SH4,
    length=length_SH4,
    N_tubes=N_tubes_SH4,
    redeclare model Material = Material) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,178})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH4_inWall(
    N_rad=N_rad,
    sizefunc=+1,
    diameter_o=diameter_o_SH4_in,
    diameter_i=diameter_i_SH4_in,
    length=length_SH4_in,
    N_tubes=N_tubes_SH4_in,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,158})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 SH4_outWall(
    N_rad=N_rad,
    sizefunc=+1,
    diameter_o=diameter_o_SH4_out,
    diameter_i=diameter_i_SH4_out,
    length=length_SH4_out,
    N_tubes=N_tubes_SH4_out,
    redeclare model Material = Material,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,212})));

  ClaRa.Basics.Interfaces.HeatPort_a
                                   heatSH4[N_ax]
    annotation (Placement(transformation(extent={{-118,168},{-98,188}}),
        iconTransformation(extent={{-132,182},{-112,202}})));
equation
  connect(sprayInjector1.opening, opening1)
                                           annotation (Line(
      points={{16,-130.4},{64,-130.4},{64,-154},{100,-154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH1_OutletHeader.inlet, superheater1.outlet) annotation (Line(
      points={{-6.12323e-016,-172},{6.12323e-016,-172},{6.12323e-016,-180}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(superheater1.inlet, SH1_InletHeader.outlet) annotation (Line(
      points={{-6.12323e-016,-200},{6.12323e-016,-200},{6.12323e-016,-209}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH1_InletHeader.inlet, inlet) annotation (Line(
      points={{-6.12323e-016,-229},{0,-229},{0,-250}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH2_InletHeader.outlet, superheater2.inlet) annotation (Line(
      points={{-4,-70},{-4,-69},{-4,-69},{-4,-68},{-4,-66},{-4,-66}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(superheater3.outlet, SH3_OutletHeader.inlet) annotation (Line(
      points={{-4,44},{-4,46.5},{-4,46.5},{-4,49},{-4,54},{-4,54}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH2_OutletHeader.inlet, superheater2.outlet) annotation (Line(
      points={{-4,-36},{-4,-38.5},{-4,-38.5},{-4,-41},{-4,-46},{-4,-46}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(superheater3.inlet, SH3_InletHeader.outlet) annotation (Line(
      points={{-4,24},{-4,23},{-4,23},{-4,22},{-4,20},{-4,20}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH3_wall.innerPhase, superheater3.heat)  annotation (Line(
      points={{-46,34},{-12,34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH3_wall.outerPhase, heatSH3)  annotation (Line(
      points={{-66,34},{-110,34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH2_wall.innerPhase, superheater2.heat)  annotation (Line(
      points={{-46,-56},{-12,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH2_wall.outerPhase, heatSH2)  annotation (Line(
      points={{-66,-56},{-110,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH1_wall.innerPhase, superheater1.heat)  annotation (Line(
      points={{-46,-190},{-8,-190}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH1_wall.outerPhase, heatSH1)  annotation (Line(
      points={{-66,-190},{-104,-190}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression[1].y, Sensors.T_e1) annotation (Line(
      points={{47,-78},{88.5,-78},{88.5,-50},{128,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression[2].y, Sensors.T_a1) annotation (Line(
      points={{47,-78},{100,-78},{100,-50},{128,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression[3].y, Sensors.T_e2) annotation (Line(
      points={{47,-78},{70,-78},{70,-50},{128,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression[4].y, Sensors.T_a2) annotation (Line(
      points={{47,-78},{60,-78},{60,-50},{128,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SH1_inWall.innerPhase, SH1_InletHeader.heat) annotation (Line(
      points={{-20.4,-210.2},{-28,-219},{-10,-219}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH1_outWall.innerPhase, SH1_OutletHeader.heat) annotation (Line(
      points={{-20.4,-156.2},{-26,-156.2},{-26,-162},{-10,-162}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH2_outWall.innerPhase, SH2_OutletHeader.heat) annotation (Line(
      points={{-26.4,-22.2},{-26.3,-22.2},{-26.3,-26},{-14,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH2_inWall.innerPhase, SH2_InletHeader.heat) annotation (Line(
      points={{-24.4,-74.2},{-26,-74.2},{-26,-80},{-14,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH3_inWall.innerPhase, SH3_InletHeader.heat) annotation (Line(
      points={{-22.4,13.8},{-26,13.8},{-26,10},{-14,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH3_outWall.innerPhase, SH3_OutletHeader.heat) annotation (Line(
      points={{-24.4,67.8},{-26.5,67.8},{-26.5,64},{-14,64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH3_InletHeader.inlet, SH2_OutletHeader.outlet) annotation (Line(
      points={{-4,0},{-4,-4},{-4,-4},{-4,-8},{-4,-16},{-4,-16}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sprayInjector2.opening,opening2)  annotation (Line(
      points={{14,91.6},{68,91.6},{68,52},{98,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(superheater4.outlet, SH4_OutletHeader.inlet) annotation (Line(
      points={{-2,188},{-2,190.5},{-2,190.5},{-2,193},{-2,198},{-2,198}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(superheater4.inlet, SH4_InletHeader.outlet) annotation (Line(
      points={{-2,168},{-2,167},{-2,167},{-2,166},{-2,164},{-2,164}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SH4_wall.innerPhase, superheater4.heat)  annotation (Line(
      points={{-44,178},{-10,178}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH4_wall.outerPhase, heatSH4)  annotation (Line(
      points={{-64,178},{-108,178}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH4_inWall.innerPhase, SH4_InletHeader.heat) annotation (Line(
      points={{-20.4,157.8},{-24,157.8},{-24,154},{-12,154}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH4_outWall.innerPhase, SH4_OutletHeader.heat) annotation (Line(
      points={{-22.4,211.8},{-24.5,211.8},{-24.5,208},{-12,208}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SH4_OutletHeader.outlet, outlet) annotation (Line(
      points={{-2,218},{-2,223.5},{0,223.5},{0,250}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(spray2, sprayInjector2.inlet2) annotation (Line(
      points={{98,102},{56,102},{56,99.4},{14,99.4}},
      color={0,131,169},
      thickness=0.5));
  connect(sprayInjector2.outlet, SH4_InletHeader.inlet) annotation (Line(
      points={{-5.2,115},{-5.2,128.5},{-2,128.5},{-2,144}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(SH3_OutletHeader.outlet, sprayInjector2.inlet1) annotation (Line(
      points={{-4,74},{-6,74},{-6,89},{-5.2,89}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(SH1_OutletHeader.outlet, sprayInjector1.inlet1) annotation (Line(
      points={{6.66134e-016,-152},{6.66134e-016,-143},{-3.2,-143},{-3.2,-133}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector1.inlet2, spray1) annotation (Line(
      points={{16,-122.6},{54,-122.6},{54,-122},{104,-122}},
      color={0,131,169},
      thickness=0.5));
  connect(sprayInjector1.outlet, SH2_InletHeader.inlet) annotation (Line(
      points={{-3.2,-107},{-3.2,-99.5},{-4,-99.5},{-4,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -250},{100,250}})),     Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-120,-270},{120,270}}), graphics={Bitmap(extent={{-124,-278},{128,278}},
          imageSource=
              "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",
          fileName=
              "modelica://ClaRa/../../DYNCAPpublications/FiguresForDocu/Components/SuperheaterIcon.png"),
                                          Polygon(
          points={{-96,-88},{104,112},{-96,-88}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-96,112},{104,-88},{-96,112}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-76,-48},{84,-88}},
          lineColor={238,46,47},
          textString="Supported until ClaRa 1.3.0")}));
end ConvectiveHeatingPart_4SH;
