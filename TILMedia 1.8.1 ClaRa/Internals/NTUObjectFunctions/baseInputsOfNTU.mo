within TILMedia.Internals.NTUObjectFunctions;
partial function baseInputsOfNTU

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Inputs ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Fluid_a at inlet of heat exchanger
  input Modelica.Units.SI.Pressure p_a_in;
  input Modelica.Units.SI.SpecificEnthalpy h_a_in;
  input Real xi_a_in[:];
  input Modelica.Units.SI.MassFlowRate m_flow_a_in;
  // Fluid_b at inlet of heat exchanger
  input Modelica.Units.SI.Pressure p_b_in;
  input Modelica.Units.SI.SpecificEnthalpy h_b_in;
  input Real xi_b_in[:];
  input Modelica.Units.SI.MassFlowRate m_flow_b_in;
  // Over entire heat exchanger (for NTU-algorithm)
  input Modelica.Units.SI.HeatFlowRate QDotFixed "Fixed absolute heat flow rate of heat exchanger";
  input Modelica.Units.SI.TemperatureDifference PinchPointDeltaTFixed "Fixed pinch-point temperature difference";
  input Modelica.Units.SI.ThermalConductance UAFixed "Fixed overall heat transfer coefficient";
  input TILMedia.Internals.NTUObjectFunctions.NTUExternalObject ntuPointer;

end baseInputsOfNTU;
