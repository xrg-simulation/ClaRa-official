within TILMedia.Internals.NTUObjectFunctions;
function getInfo_ProfileArraysAndPinchPoint
  extends NTUObjectFunctions.baseInputsOfNTU;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Inputs ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  input Integer numberOfPoints_ProfileArrays;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Outputs: Profile arrays over the heat exchanger //////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  output Real dimlessPos_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.HeatFlowRate qDot_Profile[numberOfPoints_ProfileArrays];
  output Real dimLessQDot_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.Temperature T_a_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.SpecificEnthalpy h_a_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.Pressure p_a_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.Temperature T_b_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.SpecificEnthalpy h_b_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.Pressure p_b_Profile[numberOfPoints_ProfileArrays];
  output Modelica.Units.SI.TemperatureDifference dT_HotCold_Profile[numberOfPoints_ProfileArrays];

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Outputs: Pinch point /////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  output Real dimlessPos_PinchPoint;
  output Modelica.Units.SI.Temperature T_H_PinchPoint;
  output Modelica.Units.SI.Temperature T_C_PinchPoint;
  output Modelica.Units.SI.TemperatureDifference dT_HotCold_PinchPoint;

external"C" TILMedia_NTU_getInfo_ProfileArraysAndPinchPoint(
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
    numberOfPoints_ProfileArrays,
    dimlessPos_Profile,
    qDot_Profile,
    dimLessQDot_Profile,
    T_a_Profile,
    h_a_Profile,
    p_a_Profile,
    T_b_Profile,
    h_b_Profile,
    p_b_Profile,
    dT_HotCold_Profile,
    dimlessPos_PinchPoint,
    T_H_PinchPoint,
    T_C_PinchPoint,
    dT_HotCold_PinchPoint) annotation (
    __iti_dllNoExport=true,
    Include="void TILMedia_NTU_getInfo_ProfileArraysAndPinchPoint(
    const double, const double, const double*, const double,
    const double, const double, const double*, const double,
    const double, const double, const double,
    void*,
    const int,
    double*,
    double*, double*,
    double*, double*, double*,
    double*, double* , double*,
    double*,
    double*,
    double*, double*,
    double*);",
    Library="TILMedia181ClaRa");

end getInfo_ProfileArraysAndPinchPoint;
