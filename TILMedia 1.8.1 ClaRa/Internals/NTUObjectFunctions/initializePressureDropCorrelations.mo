within TILMedia.Internals.NTUObjectFunctions;
function initializePressureDropCorrelations

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Inputs ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Fluid_a
  input TIL3_AddOn_NTU.Internals.EnumsAndTypes.dpTypes dp_type_a;
  input Integer dp_numOfParameters_a;
  input Real dp_parameters_a[dp_numOfParameters_a];
  // Fluid_b
  input TIL3_AddOn_NTU.Internals.EnumsAndTypes.dpTypes dp_type_b;
  input Integer dp_numOfParameters_b;
  input Real dp_parameters_b[dp_numOfParameters_b];
  // NTU object
  input TILMedia.Internals.NTUObjectFunctions.NTUExternalObject ntuPointer;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Output ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  output Integer outputFlag;

external"C" outputFlag = TILMedia_NTU_initializePressureDropCorrelations(
    dp_type_a,
    dp_numOfParameters_a,
    dp_parameters_a,
    dp_type_b,
    dp_numOfParameters_b,
    dp_parameters_b,
    ntuPointer) annotation (
    __iti_dllNoExport=true,
    Include="int TILMedia_NTU_initializePressureDropCorrelations(
    const int, const int, const double*,
    const int, const int, const double*,
    void*);",
    Library="TILMedia181ClaRa");

end initializePressureDropCorrelations;
