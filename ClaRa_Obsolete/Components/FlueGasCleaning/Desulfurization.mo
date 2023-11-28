within ClaRa_Obsolete.Components.FlueGasCleaning;
package Desulfurization
      extends ClaRa.Basics.Icons.PackageIcons.Components60;

  model Desulfurization_L1_ideal_old "Model for an idealised desulfurization with chalk washing"
  //___________________________________________________________________________//
  // Package of the ClaRa library, version: 1.2.0                              //
  // Models of the ClaRa library are tested under DYMOLA v2016 FD01.           //
  // It is planned to support alternative Simulators like SimulationX in the   //
  // future                                                                    //
  //___________________________________________________________________________//
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
  //___________________________________________________________________________//
  // This Modelica package is free software and the use is completely at your  //
  // own risk; it can be redistributed and/or modified under the terms of the  //
  // Modelica License 2. For license conditions (including the disclaimer of   //
  // warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
  // http://www.modelica.org/licenses/ModelicaLicense2                         //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//
    outer ClaRa.SimCenter simCenter;
    extends ClaRa.Basics.Icons.Separator;

    ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
      powerIn=0,
      powerOut_elMech=-P_el,
      powerAux=0) if contributeToCycleSummary;

    ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=simCenter.flueGasModel) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=simCenter.flueGasModel) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  //## S U M M A R Y   D E F I N I T I O N ###################################################################
     model Outline
      extends ClaRa.Basics.Icons.RecordIcon;
      input Modelica.Units.SI.Volume volume "System volume" annotation (Dialog(show));
      input Modelica.Units.SI.Mass m "System mass" annotation (Dialog(show));
      input Modelica.Units.SI.Enthalpy H "System enthalpy" annotation (Dialog(show));
      input Modelica.Units.SI.Pressure p "System pressure" annotation (Dialog(show));
      input Modelica.Units.SI.Pressure Delta_p "Pressure loss" annotation (Dialog(show));
      input Modelica.Units.SI.SpecificEnthalpy h "System specific enthalpy" annotation (Dialog(show));

      input Modelica.Units.SI.Temperature T "System temperature" annotation (Dialog(show));
      input Modelica.Units.SI.Power P_el "Electric power consumption" annotation (Dialog(show));
      input Modelica.Units.SI.MassFlowRate m_flow_SOx "Separated SOx flow rate" annotation (Dialog(show));
      input Real SOx_separationRate "NOx separation rate"
        annotation (Dialog(show));
      input Modelica.Units.SI.MassFlowRate m_flow_CaCO3 "Required CaCO3 flow rate" annotation (Dialog(show));
      input Modelica.Units.SI.MassFlowRate m_flow_CaSO4_H2O "Outlet CaSO4_H2O flow rate" annotation (Dialog(show));
      input Modelica.Units.SI.MassFlowRate m_flow_H2O "Required H2O flow rate" annotation (Dialog(show));

     end Outline;

   model Summary
       extends ClaRa.Basics.Icons.RecordIcon;
       Outline outline;
       ClaRa.Basics.Records.FlangeGas  inlet;
       ClaRa.Basics.Records.FlangeGas  outlet;
   end Summary;

  //_____________defintion of medium used in cell__________________________________________________________
    inner parameter TILMedia.GasTypes.BaseGas      medium = simCenter.flueGasModel "Medium to be used in tubes"
                                   annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

    parameter Real SOx_separationRate = 0.95 "Sulphur separation rate" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
    parameter ClaRa.Basics.Units.Temperature T_in_H2O = 313.15 "Temperature of water inlet" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
    parameter Real specificPowerConsumption(unit="J/m3") = 9000 "Specific power consumption per standard m^3" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

    replaceable model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose geometry definition | 2nd: edit corresponding record"
      annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

    replaceable model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder(diameter=4,length=10,z_in={0},z_out={10},orientation = ClaRa.Basics.Choices.GeometryOrientation.vertical,flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical)
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
      annotation (Dialog(group="Geometry"), choicesAllMatching=true);

    inner parameter Modelica.Units.SI.MassFlowRate m_flow_nom=200 "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));
    inner parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
    inner parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"
                                                                                                 annotation(Dialog(group="Nominal Values"));

  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
        choice=0 "Use guess values",
        choice=1 "Steady state",
        choice=201 "Steady pressure",
        choice=202 "Steady enthalpy",
        choice=208 "Steady pressure and enthalpy",
        choice=210 "Steady density"));
    parameter ClaRa.Basics.Units.Temperature T_start= 273.15 + 100.0 "Start value of system temperature"   annotation(Dialog(tab="Initialisation"));

    parameter ClaRa.Basics.Units.Pressure p_start= 1.013e5 "Start value of sytsem pressure" annotation(Dialog(tab="Initialisation"));
    parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc-1]={0.01,0,0.25,0,0.7,0,0,0.04,0} "Start value of system mass fraction" annotation(Dialog(tab="Initialisation"));
    inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation"));

    parameter Boolean allow_reverseFlow = true "True if simulation shall stop at reverse flow conditions" annotation(Dialog(tab="Expert Settings", group="General"));
    parameter Boolean use_dynamicMassbalance = true "True if species balance shall be dynamic"  annotation(Dialog(tab="Expert Settings", group="General"));

    parameter Boolean useStabilisedMassFlow=false "True if the outlet mass flow shall be low-pass filtered" annotation(Dialog(tab="Expert Settings", group="Numerical Robustness"));
    parameter ClaRa.Basics.Units.Time Tau=0.001 "Time Constant of Stabilisation" annotation (Dialog(
        tab="Expert Settings",
        group="Numerical Robustness",
        enable=useStabilisedMassFlow));

    parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

  ClaRa.Basics.Units.Power P_el "Electric power consumption";
  ClaRa.Basics.Units.VolumeFlowRate V_flow_std "Standardized volume flow rate";



    Fundamentals.Desulfurisation_controlVolume_ideal deSO_controlVolume(
      useStabilisedMassFlow=useStabilisedMassFlow,
      Tau=Tau,
      SOx_separationRate=SOx_separationRate,
      T_in_H2O=T_in_H2O,
      xi_start=xi_start) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-34,0})));

    ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell(
      redeclare model Geometry = Geometry,
      redeclare model PressureLoss = PressureLoss,
      T_start=T_start,
      p_start=p_start,
      xi_start=xi_start,
      m_flow_nom=m_flow_nom,
      p_nom=p_nom,
      h_nom=h_nom,
      useHomotopy=useHomotopy,
      allow_reverseFlow=allow_reverseFlow,
      use_dynamicMassbalance=use_dynamicMassbalance,
      redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
      initOption=initOption) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={26,0})));

  inner Summary summary(outline(
      volume=flueGasCell.summary.outline.volume_tot,
      m=flueGasCell.summary.outline.mass,
      H=flueGasCell.summary.outline.H,
      h=flueGasCell.summary.outline.h,
      T=flueGasCell.summary.outline.T,
      p=flueGasCell.summary.outline.p,
      Delta_p=flueGasCell.pressureLoss.Delta_p,
      P_el = P_el,
      SOx_separationRate = SOx_separationRate,
      m_flow_SOx = deSO_controlVolume.m_flow_SOx_sep,
      m_flow_CaCO3 = deSO_controlVolume.m_flow_CaCO3_req,
      m_flow_CaSO4_H2O = deSO_controlVolume.m_flow_CaSO4_H2O_out,
      m_flow_H2O = deSO_controlVolume.m_flow_H2O_req),
      inlet(mediumModel=medium, m_flow = inlet.m_flow,
            T = inStream(inlet.T_outflow),
            p = inlet.p,
            h = deSO_controlVolume.flueGasInlet.h,
            xi = inStream(inlet.xi_outflow),
            H_flow = inlet.m_flow*deSO_controlVolume.flueGasInlet.h),
      outlet(mediumModel=medium, m_flow = -outlet.m_flow,
            T = outlet.T_outflow,
            p = inlet.p,
            h = flueGasCell.flueGasOutlet.h,
            xi = outlet.xi_outflow,
            H_flow = -outlet.m_flow*flueGasCell.flueGasOutlet.h)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  public
    ClaRa.Basics.Interfaces.EyeOut eyeOut annotation (Placement(transformation(extent={{80,-78},{120,-42}}), iconTransformation(extent={{90,-50},{110,-30}})));
  protected
    ClaRa.Basics.Interfaces.EyeIn eye_int annotation (Placement(transformation(extent={{32,-68},{48,-52}}), iconTransformation(extent={{90,-84},{84,-78}})));
  public
    TILMedia.Gas GasPointer(gasType=medium) annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  equation
    V_flow_std = inlet.m_flow / TILMedia.GasObjectFunctions.density_pTxi(1.01325e5,273.15,inStream(inlet.xi_outflow),GasPointer.gasPointer);
    P_el = specificPowerConsumption * V_flow_std;

    //______________Eye port variable definition________________________
    eye_int.m_flow = -outlet.m_flow;
    eye_int.T = flueGasCell.bulk.T-273.15;
    eye_int.s = flueGasCell.bulk.s/1e3;
    eye_int.p = flueGasCell.bulk.p/1e5;
    eye_int.h = flueGasCell.bulk.h/1e3;

    connect(inlet, deSO_controlVolume.inlet) annotation (Line(
        points={{-100,0},{-44,0}},
        color={118,106,98},
        thickness=0.5,
        smooth=Smooth.None));
    connect(deSO_controlVolume.outlet, flueGasCell.inlet) annotation (Line(
        points={{-24,0},{16,0}},
        color={118,106,98},
        thickness=0.5,
        smooth=Smooth.None));
    connect(flueGasCell.outlet, outlet) annotation (Line(
        points={{36,0},{100,0}},
        color={118,106,98},
        thickness=0.5,
        smooth=Smooth.None));
    connect(eye_int,eyeOut)  annotation (Line(
        points={{40,-60},{100,-60}},
        color={190,190,190},
        smooth=Smooth.None));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                           graphics={                  Text(
            extent={{-84,72},{-12,28}},
            lineColor={27,36,42},
            textString="SOx"),             Polygon(
            points={{-100,100},{100,-100},{-100,100}},
            lineColor={255,0,0},
            smooth=Smooth.None,
            fillColor={102,198,0},
            fillPattern=FillPattern.Solid), Polygon(
            points={{-100,-100},{100,100},{-100,-100}},
            lineColor={255,0,0},
            smooth=Smooth.None,
            fillColor={102,198,0},
            fillPattern=FillPattern.Solid)}),
                                   Diagram(coordinateSystem(preserveAspectRatio=false,
                     extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
<p><b>Information</b></p>
<p><b>Model description: </b>An ideal desulfurization model</p>
<p><b>Contact:</b> Andre Th&uuml;ring, Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Calculates the separated SO2 with a given separation rate</li>
<li>Power consumption is calculated with a given specific power consumption </li>
<li>Stationary mass and energy balance inside the ideal control volume</li>
<li>Dwelltime is regarded by upstream flue gas cell</li>
<li>The model is adiabatic</li>
<li>The flue gas leaves the control volume saturated with water</li>
<li>Outlet temperature is calculated with evaporation heat of spray water needed to saturate the flue gas</li>
</ul></p>
</html>"));
  end Desulfurization_L1_ideal_old;

  package Fundamentals
  //___________________________________________________________________________//
  // Package of the ClaRa library, version: 1.2.0                              //
  // Models of the ClaRa library are tested under DYMOLA v2016 FD01.           //
  // It is planned to support alternative Simulators like SimulationX in the   //
  // future                                                                    //
  //___________________________________________________________________________//
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
  //___________________________________________________________________________//
  // This Modelica package is free software and the use is completely at your  //
  // own risk; it can be redistributed and/or modified under the terms of the  //
  // Modelica License 2. For license conditions (including the disclaimer of   //
  // warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
  // http://www.modelica.org/licenses/ModelicaLicense2                         //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

      extends ClaRa.Basics.Icons.PackageIcons.Components50;

    model Desulfurisation_controlVolume_ideal
    //___________________________________________________________________________//
    // Package of the ClaRa library, version: 1.2.0                              //
    // Models of the ClaRa library are tested under DYMOLA v2016 FD01.           //
    // It is planned to support alternative Simulators like SimulationX in the   //
    // future                                                                    //
    //___________________________________________________________________________//
    // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
    // Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
    //___________________________________________________________________________//
    // This Modelica package is free software and the use is completely at your  //
    // own risk; it can be redistributed and/or modified under the terms of the  //
    // Modelica License 2. For license conditions (including the disclaimer of   //
    // warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
    // http://www.modelica.org/licenses/ModelicaLicense2                         //
    //___________________________________________________________________________//
    // DYNCAP and DYNSTART are research projects supported by the German Federal //
    // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
    // The research team consists of the following project partners:             //
    // Institute of Energy Systems (Hamburg University of Technology),           //
    // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
    // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
    // XRG Simulation GmbH (Hamburg, Germany).                                   //
    //___________________________________________________________________________//
        extends ClaRa.Basics.Icons.Box;

      outer ClaRa.SimCenter simCenter;

      inner parameter TILMedia.GasTypes.BaseGas  medium = simCenter.flueGasModel "Medium to be used in tubes"
                                     annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

      ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
      ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

    //  final parameter Modelica.SIunits.MolarInternalEnergy delta_f_H_CaCO3 = -1207.1e3;
    //  final parameter Modelica.SIunits.MolarInternalEnergy delta_f_H_CaSO4_H2O = -2023e3;

      final parameter Modelica.Units.SI.MolarMass M_CaSO4_H2O=0.172141 "Molar mass of gypsum";
      final parameter Modelica.Units.SI.MolarMass M_CaCO3=0.10009 "Molar mass of calcium carbonate";

    Real m_flow_aux;
    parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
        parameter ClaRa.Basics.Units.Time Tau=0.001 "Time Constant of Stabilisation" annotation (Dialog(
          tab="Expert Settings",
          group="Numerical Robustness",
          enable=useStabilisedMassFlow));

    parameter Real SOx_separationRate = 0.95 "Efficiency of SOx separation";
      parameter Modelica.Units.SI.Temperature T_in_H2O=313.15 "Inlet Temperature of water";
      parameter Modelica.Units.SI.MassFraction xi_start[medium.nc - 1]=zeros(medium.nc - 1) "Start value of system mass fraction" annotation (Dialog(tab="Initialisation"));

    //required molar flow rates of reaction educts
      Modelica.Units.SI.MolarFlowRate n_flow_CaCO3_req "Required molar flow of calcium carbonate";
      Modelica.Units.SI.MolarFlowRate n_flow_O2_req "Additional required molar flow of oxygen";
      Modelica.Units.SI.MolarFlowRate n_flow_H2O_req "Required molar flow of water";

    //molar flow rates of reaction educts inside flue gas
      Modelica.Units.SI.MolarFlowRate n_flow_SO2_in "Molar flow rate of sulfur dioxide at inlet";
      Modelica.Units.SI.MolarFlowRate n_flow_O2_in "Molar flow rate of oxygen at inlet";
      Modelica.Units.SI.MolarFlowRate n_flow_H2O_in "Molar flow rate of water at inlet";

    //molar flow rates of products
      Modelica.Units.SI.MolarFlowRate n_flow_CaSO4_H2O_out "Molar flow rate of gypsum outlet (no connector)";
      Modelica.Units.SI.MolarFlowRate n_flow_CO2_out "Molar flow rate of carbon dioxide at outlet";
      Modelica.Units.SI.MolarFlowRate n_flow_H2O_out(start=1) "Molar flow rate of water at outlet";
      Modelica.Units.SI.MolarFlowRate n_flow_H2O_sep "Molar flow rate of separated water (no connector)";

      Modelica.Units.SI.MassFlowRate m_flow_SOx_sep "Mass flow of separated sulfur dioxide";
      Modelica.Units.SI.MassFlowRate m_flow_CaSO4_H2O_out "Mass flow of gypsum (no connector)";
      Modelica.Units.SI.MassFlowRate m_flow_H2O_req "Mass flow of required water";
      Modelica.Units.SI.MassFlowRate m_flow_O2_req "Mass flow of required oxygen";
      Modelica.Units.SI.MassFlowRate m_flow_CaCO3_req "Mass flow of required calcium carbonate";
      Modelica.Units.SI.MassFlowRate m_flow_O2_sep "Mass flow of separated oxygen";
      Modelica.Units.SI.MassFlowRate m_flow_H2O_sep "Mass flow of separated water";
      Modelica.Units.SI.MassFlowRate m_flow_CO2_prod "Mass flow of produced carbon dioxide";

    ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Specific enthalpy at outlet";
    //ClaRa.Basics.Units.EnthalpyMassSpecific h_out_del "Pseudo state for specific enthalpy at outlet";

      TILMedia.Gas_pT     flueGasInlet(p=inlet.p,
      T=inStream(inlet.T_outflow),
      xi=inStream(inlet.xi_outflow),
      gasType = medium)
        annotation (Placement(transformation(extent={{-78,-12},{-58,8}})));

      TILMedia.Gas_ph     flueGasOutlet(
      gasType = medium,
        p=inlet.p,
        h=h_out,
        xi(start= xi_start)=outlet.xi_outflow)
        annotation (Placement(transformation(extent={{62,-12},{82,8}})));

    initial equation
      - m_flow_aux= inlet.m_flow - m_flow_SOx_sep + m_flow_O2_req - m_flow_O2_sep + m_flow_H2O_req + m_flow_CO2_prod + m_flow_CaCO3_req - m_flow_CaSO4_H2O_out;
     // h_out_del = h_out;

    equation

    n_flow_SO2_in =inlet.m_flow*inStream(inlet.xi_outflow[4])/flueGasInlet.M_i[4];
    n_flow_O2_in =inlet.m_flow*inStream(inlet.xi_outflow[6])/flueGasInlet.M_i[6];
    n_flow_H2O_in =inlet.m_flow*inStream(inlet.xi_outflow[8])/flueGasInlet.M_i[8];
    n_flow_H2O_out = - outlet.m_flow * flueGasOutlet.xi_s/flueGasInlet.M_i[8];
    n_flow_H2O_sep = 2 * SOx_separationRate * n_flow_SO2_in;

    n_flow_CaCO3_req = SOx_separationRate * n_flow_SO2_in;

    n_flow_O2_req =
    if n_flow_O2_in > 0.5 * SOx_separationRate * n_flow_SO2_in then
     0 else
         0.5 * SOx_separationRate * n_flow_SO2_in - n_flow_O2_in;

    n_flow_H2O_req =
    if n_flow_H2O_in > 2 * SOx_separationRate * n_flow_SO2_in + n_flow_H2O_out then
      0 else
      n_flow_H2O_sep + n_flow_H2O_out - n_flow_H2O_in;

    n_flow_CaSO4_H2O_out = SOx_separationRate * n_flow_SO2_in;
    n_flow_CO2_out = SOx_separationRate * n_flow_SO2_in;

    m_flow_SOx_sep =SOx_separationRate*inlet.m_flow*inStream(inlet.xi_outflow[4]);
    m_flow_O2_sep = 0.5 * SOx_separationRate * n_flow_SO2_in * flueGasInlet.M_i[6];
    m_flow_H2O_sep = n_flow_H2O_sep * flueGasInlet.M_i[8];

    m_flow_CaSO4_H2O_out = n_flow_CaSO4_H2O_out * M_CaSO4_H2O; //Inherits the separated H2O
    m_flow_H2O_req = n_flow_H2O_req * flueGasInlet.M_i[8];
    m_flow_O2_req = n_flow_O2_req *flueGasInlet.M_i[6];
    m_flow_CaCO3_req = n_flow_CaCO3_req * M_CaCO3;
    m_flow_CO2_prod = 1*SOx_separationRate*n_flow_SO2_in*flueGasInlet.M_i[3];

    if (useStabilisedMassFlow==false) then
      - outlet.m_flow = inlet.m_flow - m_flow_SOx_sep + m_flow_O2_req - m_flow_O2_sep + m_flow_H2O_req + m_flow_CO2_prod + m_flow_CaCO3_req - m_flow_CaSO4_H2O_out; //Without H2O_sep because it is inherited within m_flow_CaSO4_H2O_out
      der(m_flow_aux) = 0;
    else
      der(m_flow_aux) = 1/Tau *(-(inlet.m_flow - m_flow_SOx_sep + m_flow_O2_req - m_flow_O2_sep + m_flow_H2O_req + m_flow_CO2_prod + m_flow_CaCO3_req - m_flow_CaSO4_H2O_out) -m_flow_aux);
      outlet.m_flow = m_flow_aux;
    end if;

    //Komponentenbilanz
     for i in 1:(medium.nc-1) loop
        if i == 3 then
          inlet.m_flow*inStream(inlet.xi_outflow[3]) + (1*SOx_separationRate*
            n_flow_SO2_in*flueGasInlet.M_i[3]) = -outlet.m_flow*outlet.xi_outflow[3];
        else if i == 4 then
            inlet.m_flow*inStream(inlet.xi_outflow[4]) - (1*SOx_separationRate*
              n_flow_SO2_in*flueGasInlet.M_i[4]) = -outlet.m_flow*outlet.xi_outflow[
              4];
        else if i == 6 then
         if n_flow_O2_in < 0.5 * SOx_separationRate * n_flow_SO2_in then
                outlet.xi_outflow[6] = 0;
                                     else
                inlet.m_flow*inStream(inlet.xi_outflow[6]) - (0.5*
                  SOx_separationRate*n_flow_SO2_in*flueGasInlet.M_i[6]) = -outlet.m_flow
                  *outlet.xi_outflow[6];
         end if;
       else if i == 8 then
                outlet.xi_outflow[8] = flueGasOutlet.xi_s;
                                                      //Outlet flue gas is fully saturated with water
           //outlet.Xi_outflow[8] = xi_s_del;
       else     inlet.m_flow*inStream(inlet.xi_outflow[i]) = -outlet.m_flow*outlet.xi_outflow[
                  i];
       end if;
       end if;
       end if;
       end if;
     end for;

    0 = inlet.m_flow * flueGasInlet.h + (m_flow_H2O_req-m_flow_H2O_sep) * (-flueGasInlet.delta_hv) + outlet.m_flow * h_out;
    //der(h_out_del)=1/Tau*(h_out-h_out_del);
    outlet.T_outflow= flueGasOutlet.T;

    inlet.p = outlet.p;

      inlet.xi_outflow
                     = inStream(outlet.xi_outflow);
    inlet.T_outflow = inStream(outlet.T_outflow);
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}),
                       graphics));
    end Desulfurisation_controlVolume_ideal;
  end Fundamentals;
end Desulfurization;
