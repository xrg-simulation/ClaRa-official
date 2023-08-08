within TILMedia.Internals;
package LiquidObjectFunctions
  extends TILMedia.Internals.ClassTypes.ModelPackage;

  function molarMass_xi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.MolarMass mm "Molar mass";
  external"C" mm = TILMedia_Liquid_molarMass_xi(liquidPointer, xi) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Liquid_molarMass_xi(double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (Impure=false);
  end molarMass_xi;

  function properties_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.Density d "Density";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta "Isobaric expansion coefficient";
  external"C" TILMedia_Liquid_properties_Txi(
        T,
        xi,
        liquidPointer,
        d,
        cp,
        beta) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_properties_Txi(double, double*, void*, double*, double*, double*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_properties_Txi,
        Impure=false);
  end properties_Txi;

  function der_properties_Txi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_d "Density";
    output Real der_cp "Specific heat capacity cp";
    output Real der_beta "Isobaric expansion coefficient";
  external"C" TILMedia_Liquid_der_properties_Txi(
        T,
        xi,
        liquidPointer,
        der_T,
        der_xi,
        der_d,
        der_cp,
        der_beta) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_der_properties_Txi(double, double*, void*, double, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_properties_Txi;

  function properties_hxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.Density d "Density";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta "Isobaric expansion coefficient";
  external"C" TILMedia_Liquid_properties_hxi(
        h,
        xi,
        liquidPointer,
        d,
        cp,
        beta) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_properties_hxi(double, double*, void*, double*, double*, double*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_properties_hxi,
        Impure=false);
  end properties_hxi;

  function der_properties_hxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_d "Density";
    output Real der_cp "Specific heat capacity cp";
    output Real der_beta "Isobaric expansion coefficient";
  external"C" TILMedia_Liquid_der_properties_hxi(
        h,
        xi,
        liquidPointer,
        der_h,
        der_xi,
        der_d,
        der_cp,
        der_beta) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_der_properties_hxi(double, double*, void*, double, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_properties_hxi;

  function transportPropertyRecord_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external"C" TILMedia_Liquid_transportProperties_Txi(
        T,
        xi,
        liquidPointer,
        Pr,
        lambda,
        eta,
        sigma) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_transportProperties_Txi(double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_transportPropertyRecord_Txi,
        Impure=false);
  end transportPropertyRecord_Txi;

  function der_transportPropertyRecord_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real Pr "Prandtl number";
    output Real lambda "Thermal conductivity";
    output Real eta "Dynamic viscosity";
    output Real sigma "Surface tension";
  external"C" TILMedia_Liquid_der_transportProperties_Txi(
        T,
        xi,
        liquidPointer,
        der_T,
        der_xi,
        Pr,
        lambda,
        eta,
        sigma) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Liquid_der_transportProperties_Txi(double, double*, void*, double, double*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_transportPropertyRecord_Txi;

  function specificEntropy_pTxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.SpecificEntropy s "Specific entropy";
  external"C" s = TILMedia_Liquid_specificEntropy_pTxi(
        p,
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Liquid_specificEntropy_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end specificEntropy_pTxi;

  function density_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.Density d "Density";

  external"C" d = TILMedia_LiquidObjectFunctions_density_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_density_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_density_Txi);
  end density_Txi;

  function der_density_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_d "Density";

  external"C" der_d = TILMedia_LiquidObjectFunctions_der_density_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_density_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_density_Txi;

  function specificEnthalpy_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";
  external"C" h = TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(T=TILMedia.Internals.LiquidObjectFunctions.temperature_hxi(
              h,
              xi,
              liquidPointer)), derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_specificEnthalpy_Txi);
  end specificEnthalpy_Txi;

  function der_specificEnthalpy_Txi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Derivative of Temperature";
    input Real[:] der_xi "Derivative of Mass fractions of the first nc-1 components";
    output Real der_h "Derivative of Specific enthalpy";
  external"C" der_h = TILMedia_LiquidObjectFunctions_der_specificEnthalpy_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_specificEnthalpy_Txi(double, double*, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_specificEnthalpy_Txi;

  function specificIsobaricHeatCapacity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.SpecificHeatCapacity cp "Specific isobaric heat capacity cp";

  external"C" cp = TILMedia_LiquidObjectFunctions_specificIsobaricHeatCapacity_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_specificIsobaricHeatCapacity_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_specificIsobaricHeatCapacity_Txi);
  end specificIsobaricHeatCapacity_Txi;

  function der_specificIsobaricHeatCapacity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_cp "Specific isobaric heat capacity cp";

  external"C" der_cp = TILMedia_LiquidObjectFunctions_der_specificIsobaricHeatCapacity_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_specificIsobaricHeatCapacity_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsobaricHeatCapacity_Txi;

  function isobaricThermalExpansionCoefficient_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.LinearExpansionCoefficient beta "Isobaric thermal expansion coefficient";

  external"C" beta = TILMedia_LiquidObjectFunctions_isobaricThermalExpansionCoefficient_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_isobaricThermalExpansionCoefficient_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_isobaricThermalExpansionCoefficient_Txi);
  end isobaricThermalExpansionCoefficient_Txi;

  function der_isobaricThermalExpansionCoefficient_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_beta "Isobaric thermal expansion coefficient";

  external"C" der_beta = TILMedia_LiquidObjectFunctions_der_isobaricThermalExpansionCoefficient_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_isobaricThermalExpansionCoefficient_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_isobaricThermalExpansionCoefficient_Txi;

  function prandtlNumber_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";

  external"C" Pr = TILMedia_LiquidObjectFunctions_prandtlNumber_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_prandtlNumber_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_prandtlNumber_Txi);
  end prandtlNumber_Txi;

  function der_prandtlNumber_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_Pr "Prandtl number";

  external"C" der_Pr = TILMedia_LiquidObjectFunctions_der_prandtlNumber_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_prandtlNumber_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_prandtlNumber_Txi;

  function thermalConductivity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.ThermalConductivity lambda "Thermal conductivity";

  external"C" lambda = TILMedia_LiquidObjectFunctions_thermalConductivity_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_thermalConductivity_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_thermalConductivity_Txi);
  end thermalConductivity_Txi;

  function der_thermalConductivity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_lambda "Thermal conductivity";

  external"C" der_lambda = TILMedia_LiquidObjectFunctions_der_thermalConductivity_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_thermalConductivity_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_thermalConductivity_Txi;

  function dynamicViscosity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.DynamicViscosity eta "Dynamic viscosity";

  external"C" eta = TILMedia_LiquidObjectFunctions_dynamicViscosity_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_dynamicViscosity_Txi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_dynamicViscosity_Txi);
  end dynamicViscosity_Txi;

  function der_dynamicViscosity_Txi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_eta "Dynamic viscosity";

  external"C" der_eta = TILMedia_LiquidObjectFunctions_der_dynamicViscosity_Txi(
        T,
        xi,
        der_T,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_dynamicViscosity_Txi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_dynamicViscosity_Txi;

  function density_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.Density d "Density";

  external"C" d = TILMedia_LiquidObjectFunctions_density_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_density_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_density_hxi);
  end density_hxi;

  function der_density_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_d "Density";

  external"C" der_d = TILMedia_LiquidObjectFunctions_der_density_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_density_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_density_hxi;

  function temperature_hxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.Temperature T "Temperature";
  external"C" T = TILMedia_LiquidObjectFunctions_temperature_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_temperature_hxi(double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(h=TILMedia.Internals.LiquidObjectFunctions.specificEnthalpy_Txi(
              T,
              xi,
              liquidPointer)), derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_temperature_hxi);
  end temperature_hxi;

  function der_temperature_hxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_T "Temperature";
  external"C" der_T = TILMedia_LiquidObjectFunctions_der_temperature_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_temperature_hxi(double, double*, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end der_temperature_hxi;

  function specificIsobaricHeatCapacity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.SpecificHeatCapacity cp "Specific isobaric heat capacity cp";

  external"C" cp = TILMedia_LiquidObjectFunctions_specificIsobaricHeatCapacity_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_specificIsobaricHeatCapacity_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_specificIsobaricHeatCapacity_hxi);
  end specificIsobaricHeatCapacity_hxi;

  function der_specificIsobaricHeatCapacity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_cp "Specific isobaric heat capacity cp";

  external"C" der_cp = TILMedia_LiquidObjectFunctions_der_specificIsobaricHeatCapacity_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_specificIsobaricHeatCapacity_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsobaricHeatCapacity_hxi;

  function isobaricThermalExpansionCoefficient_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.LinearExpansionCoefficient beta "Isobaric thermal expansion coefficient";

  external"C" beta = TILMedia_LiquidObjectFunctions_isobaricThermalExpansionCoefficient_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_isobaricThermalExpansionCoefficient_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_isobaricThermalExpansionCoefficient_hxi);
  end isobaricThermalExpansionCoefficient_hxi;

  function der_isobaricThermalExpansionCoefficient_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_beta "Isobaric thermal expansion coefficient";

  external"C" der_beta = TILMedia_LiquidObjectFunctions_der_isobaricThermalExpansionCoefficient_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_isobaricThermalExpansionCoefficient_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_isobaricThermalExpansionCoefficient_hxi;

  function prandtlNumber_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";

  external"C" Pr = TILMedia_LiquidObjectFunctions_prandtlNumber_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_prandtlNumber_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_prandtlNumber_hxi);
  end prandtlNumber_hxi;

  function der_prandtlNumber_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_Pr "Prandtl number";

  external"C" der_Pr = TILMedia_LiquidObjectFunctions_der_prandtlNumber_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_prandtlNumber_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_prandtlNumber_hxi;

  function thermalConductivity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.ThermalConductivity lambda "Thermal conductivity";

  external"C" lambda = TILMedia_LiquidObjectFunctions_thermalConductivity_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_thermalConductivity_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_thermalConductivity_hxi);
  end thermalConductivity_hxi;

  function der_thermalConductivity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_lambda "Thermal conductivity";

  external"C" der_lambda = TILMedia_LiquidObjectFunctions_der_thermalConductivity_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_thermalConductivity_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_thermalConductivity_hxi;

  function dynamicViscosity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    output SI.DynamicViscosity eta "Dynamic viscosity";

  external"C" eta = TILMedia_LiquidObjectFunctions_dynamicViscosity_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_dynamicViscosity_hxi(double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=liquidPointer) = TILMedia.Internals.LiquidObjectFunctions.der_dynamicViscosity_hxi);
  end dynamicViscosity_hxi;

  function der_dynamicViscosity_hxi
    extends TILMedia.BaseClasses.PartialLiquidObjectFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject liquidPointer;
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_eta "Dynamic viscosity";

  external"C" der_eta = TILMedia_LiquidObjectFunctions_der_dynamicViscosity_hxi(
        h,
        xi,
        der_h,
        der_xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_LiquidObjectFunctions_der_dynamicViscosity_hxi(double,double*,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_dynamicViscosity_hxi;
end LiquidObjectFunctions;
