within ClaRa.Visualisation;
model StatePoint "State Point of fluid without visualisation"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
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

//  parameter String unit="C" "Variable unit";
  parameter Integer identifier= -1 "Identifier of the quadruple" annotation(Dialog(group="Indices"));
  parameter Integer stateViewerIndex=-1 "Index for StateViewer" annotation(Dialog(group="Indices"));
  parameter Boolean useEyeIn=true "True if connector shall be used" annotation(Dialog(group="Input"));
  Real p "Pressure in bar";
  Real h "Specific enthalpy in kJ/kg";
  Real s "Specific entropy in kJ/(kg*s)";
  Real T "Temperature in C";
  Real m_flow "Mass flow rate in kg/s";
  input ClaRa.Basics.Units.Pressure p_in=1e5 "Input pressure"
                                                             annotation(Dialog(group="Input", enable= not useEyeIn));
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_in=200e3 "Specific enthalpy of state"
                                                                                       annotation(Dialog(group="Input", enable= not useEyeIn));
  input ClaRa.Basics.Units.EntropyMassSpecific s_in=1e3 "Specific enthalpy of state"
                                                                                    annotation(Dialog(group="Input", enable= not useEyeIn));
  input ClaRa.Basics.Units.Temperature T_in=273.15+20 "Temperature of state"
                                                                            annotation(Dialog(group="Input", enable= not useEyeIn));
  input ClaRa.Basics.Units.MassFlowRate m_flow_in=1 "Mass flow rate"
                                                                    annotation(Dialog(group="Input", enable= not useEyeIn));
  outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.Interfaces.EyeIn eye(p(value=p), h(value=h), s(value=s), T(value=T), m_flow(value=m_flow)) if useEyeIn  annotation (Placement(transformation(extent={{-40,-10},{-20,10}}), iconTransformation(extent={{-40,-10},{-20,10}})));

equation
  if useEyeIn==false then
    p=p_in/1e5;
    h=h_in/1e3;
    s=s_in/1e3;
    T=T_in-273.15;
    m_flow=m_flow_in;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-20,-20},{20,20}},
        initialScale=0.05), graphics={
                             Ellipse(
          extent={{-20,-20},{20,20}},
          lineColor={215,215,215},
          lineThickness=0.5),
                            Text(
          extent={{-20,-20},{20,20}},
          lineColor={215,215,215},
          lineThickness=1,
          textString="S")}),Diagram(graphics,
                                    coordinateSystem(preserveAspectRatio=true,  extent={{-20,-20},{20,20}},
        initialScale=0.05)));
end StatePoint;
