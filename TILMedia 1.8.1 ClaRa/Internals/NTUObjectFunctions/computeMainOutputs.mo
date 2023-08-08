within TILMedia.Internals.NTUObjectFunctions;
function computeMainOutputs
  extends NTUObjectFunctions.baseInputsOfNTU;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Inputs ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  input Integer lengthArrayOfZones "Length of array for zones";

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Outputs: Fluid_a /////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // At outlet of heat exchanger
  output Modelica.Units.SI.Pressure p_a_out;
  output Modelica.Units.SI.SpecificEnthalpy h_a_out;
  output Real xi_a_out[size(xi_a_in, 1)];
  output Modelica.Units.SI.Temperature T_a_out;
  output Modelica.Units.SI.MassFlowRate m_flow_totalCondensate_a;
  // At inlet of heat exchanger
  output Modelica.Units.SI.Temperature T_a_in;
  output Modelica.Units.SI.MassFlowRate m_flow_inletCondensate_a;
  // Over entire path in the heat exchanger
  output Modelica.Units.SI.PressureDifference dp_a;
  output Modelica.Units.SI.SpecificEnthalpy dh_a;
  output Modelica.Units.SI.TemperatureDifference dT_a;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Outputs: Fluid_b /////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // At outlet of heat exchanger
  output Modelica.Units.SI.Pressure p_b_out;
  output Modelica.Units.SI.SpecificEnthalpy h_b_out;
  output Real xi_b_out[size(xi_b_in, 1)];
  output Modelica.Units.SI.Temperature T_b_out;
  output Modelica.Units.SI.MassFlowRate m_flow_totalCondensate_b;
  // At inlet of heat exchanger
  output Modelica.Units.SI.Temperature T_b_in;
  output Modelica.Units.SI.MassFlowRate m_flow_inletCondensate_b;
  // Over entire path in the heat exchanger
  output Modelica.Units.SI.PressureDifference dp_b;
  output Modelica.Units.SI.SpecificEnthalpy dh_b;
  output Modelica.Units.SI.TemperatureDifference dT_b;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Outputs: Over entire heat exchanger //////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  output Modelica.Units.SI.HeatFlowRate QDot "Absolute heat flow rate of heat exchanger";
  output Modelica.Units.SI.TemperatureDifference PinchPointDeltaT "pinch-point temperature difference";
  output Modelica.Units.SI.ThermalConductance UA "Overall heat transfer coefficient";
  output Modelica.Units.SI.HeatFlowRate[lengthArrayOfZones] QDot_Z "Absolute heat flow rate of each zone in heat exchanger";
  output Modelica.Units.SI.ThermalConductance[lengthArrayOfZones] UA_Z "Overall heat transfer coefficient of each zone in heat exchanger";
  output Real numberOfZones;
  output Real numberOfZones_a;
  output Real numberOfZones_b;
  output Real numberOfCalls;

external"C" TILMedia_NTU_computeMainOutputs(
    p_a_in,
    h_a_in,
    xi_a_in,
    m_flow_a_in,
    p_b_in,
    h_b_in,
    xi_b_in,
    m_flow_b_in,
    QDotFixed,
    PinchPointDeltaTFixed,
    UAFixed,
    ntuPointer,
    p_a_out,
    h_a_out,
    xi_a_out,
    T_a_out,
    m_flow_totalCondensate_a,
    T_a_in,
    m_flow_inletCondensate_a,
    dp_a,
    dh_a,
    dT_a,
    p_b_out,
    h_b_out,
    xi_b_out,
    T_b_out,
    m_flow_totalCondensate_b,
    T_b_in,
    m_flow_inletCondensate_b,
    dp_b,
    dh_b,
    dT_b,
    QDot,
    PinchPointDeltaT,
    UA,
    lengthArrayOfZones,
    QDot_Z,
    UA_Z,
    numberOfZones,
    numberOfZones_a,
    numberOfZones_b,
    numberOfCalls) annotation (
    __iti_dllNoExport=true,
    Include="void TILMedia_NTU_computeMainOutputs(
    const double, const double, const double*, const double,
    const double, const double, const double*, const double,
    const double, const double, const double,
    void*,
    double*, double*, double*,
    double*, double*,
    double*, double*,
    double*, double*, double*,
    double*, double*, double*,
    double*, double*,
    double*, double*,
    double*, double*, double*,
    double*, double*, double*,
    const int, double*, double*,
    double*, double*, double*,
    double*);",
    Library="TILMedia181ClaRa");

end computeMainOutputs;
