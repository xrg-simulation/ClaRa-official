within TILMedia.Internals.NTUObjectFunctions;
function initializeAlphaCorrelations

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Inputs ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Fluid_a
  input TIL3_AddOn_NTU.Internals.EnumsAndTypes.alphaTypes alpha_type_a;
  input Integer alpha_numOfParameters_a;
  input Real alpha_parameters_a[alpha_numOfParameters_a];
  // Fluid_b
  input TIL3_AddOn_NTU.Internals.EnumsAndTypes.alphaTypes alpha_type_b;
  input Integer alpha_numOfParameters_b;
  input Real alpha_parameters_b[alpha_numOfParameters_b];
  // NTU object
  input TILMedia.Internals.NTUObjectFunctions.NTUExternalObject ntuPointer;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //// Output ///////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  output Integer outputFlag;

external"C" outputFlag = TILMedia_NTU_initializeAlphaCorrelations(
    alpha_type_a,
    alpha_numOfParameters_a,
    alpha_parameters_a,
    alpha_type_b,
    alpha_numOfParameters_b,
    alpha_parameters_b,
    ntuPointer) annotation (
    __iti_dllNoExport=true,
    Include="int TILMedia_NTU_initializeAlphaCorrelations(
    const int, const int, const double*,
    const int, const int, const double*,
    void*);",
    Library="TILMedia181ClaRa");

end initializeAlphaCorrelations;
