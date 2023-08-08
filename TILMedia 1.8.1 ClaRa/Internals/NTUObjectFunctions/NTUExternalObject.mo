within TILMedia.Internals.NTUObjectFunctions;
class NTUExternalObject
  extends ExternalObject;
  function constructor "get memory"
    input String mediumType_a;
    input String name_a;
    input Integer flags_a;
    input Real[:] xi_a;
    input Integer nc_a;
    input Integer condensingIndex_a;
    input Integer sideFlag_a;
    input String mediumType_b;
    input String name_b;
    input Integer flags_b;
    input Real[:] xi_b;
    input Integer nc_b;
    input Integer condensingIndex_b;
    input Integer sideFlag_b;
    input TIL3_AddOn_NTU.Internals.EnumsAndTypes.calculationInputEnum calculationInputType;
    input String instanceName;
    output NTUExternalObject ntuPointer;

  external"C" ntuPointer = TILMedia_NTU_createExternalObject(
        mediumType_a,
        name_a,
        flags_a,
        xi_a,
        nc_a,
        condensingIndex_a,
        sideFlag_a,
        mediumType_b,
        name_b,
        flags_b,
        xi_b,
        nc_b,
        condensingIndex_b,
        sideFlag_b,
        calculationInputType,
        instanceName) annotation (
      __iti_dllNoExport=true,
      Include="
#ifndef TILMEDIANTUCONSTRUCTOR
#define TILMEDIANTUCONSTRUCTOR
#if defined(_JMI_GLOBAL_H) || defined(WSM_VERSION) || defined(DYMOLA_STATIC) || (defined(ITI_CRT_INCLUDE) && !defined(ITI_COMP_SIM)) || defined(OPENMODELICA_H_)
void* TILMedia_NTU_createExternalObject_errorInterface(
        const char* mediumType_a,
        const char* name_a, int flags_a, double* xi_a, int nc_a,
        const int condensingIndex_a, const int sideFlag_a,
        const char* mediumType_b,
        const char* name_b, int flags_b, double* xi_b, int nc_b,
        const int condensingIndex_b, const int sideFlag_b,
        const int calculationInputType,
        const char* instanceName,
        void* formatMessage,
        void* formatError,
        void* dymolaErrorLev);
#if defined(DYMOLA_STATIC)
#ifndef _WIN32
#define __stdcall
#endif
double __stdcall TILMedia_DymosimErrorLevWrapper_NTU(const char* message, int level)
{
    return DymosimErrorLev(message, level);
}
#endif
void* TILMedia_NTU_createExternalObject(
        const char* mediumType_a,
        const char* name_a, int flags_a, double* xi_a, int nc_a,
        const int condensingIndex_a, const int sideFlag_a,
        const char* mediumType_b,
        const char* name_b, int flags_b, double* xi_b, int nc_b,
        const int condensingIndex_b, const int sideFlag_b,
        const int calculationInputType,
        const char* instanceName)
{
#if defined(DYMOLA_STATIC)
return TILMedia_NTU_createExternalObject_errorInterface(
        mediumType_a,
        name_a, flags_a, xi_a, nc_a,
        condensingIndex_a, sideFlag_a,
        mediumType_b,
        name_b, flags_b, xi_b, nc_b,
        condensingIndex_b, sideFlag_b,
        calculationInputType,
        instanceName,
        (void*)ModelicaFormatMessage,
        (void*)ModelicaFormatError,
        (void*)TILMedia_DymosimErrorLevWrapper_NTU);
#else
return TILMedia_NTU_createExternalObject_errorInterface(
        mediumType_a,
        name_a, flags_a, xi_a, nc_a,
        condensingIndex_a, sideFlag_a,
        mediumType_b,
        name_b, flags_b, xi_b, nc_b,
        condensingIndex_b, sideFlag_b,
        calculationInputType,
        instanceName,
        (void*)ModelicaFormatMessage,
        (void*)ModelicaFormatError,
        0);
#endif
}
#endif
#else
void* TILMedia_NTU_createExternalObject(
        const char* mediumType_a,
        const char* name_a, int flags_a, double* xi_a, int nc_a,
        const int condensingIndex_a, const int sideFlag_a,
        const char* mediumType_b,
        const char* name_b, int flags_b, double* xi_b, int nc_b,
        const int condensingIndex_b, const int sideFlag_b,
        const int calculationInputType,
        const char* instanceName);
#endif
",    Library="TILMedia181ClaRa");
  end constructor;

  function destructor "free memory"
    input NTUExternalObject ntuPointer;
  external"C" TILMedia_NTU_destroyExternalObject(ntuPointer) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_NTU_destroyExternalObject(void*);",
      Library="TILMedia181ClaRa");
  end destructor;
end NTUExternalObject;
