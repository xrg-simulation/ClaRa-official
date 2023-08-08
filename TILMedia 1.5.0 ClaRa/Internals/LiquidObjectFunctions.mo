﻿within TILMedia.Internals;
package LiquidObjectFunctions
  extends TILMedia.Internals.ClassTypes.ModelPackage;

  function molarMass_xi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input Modelica.SIunits.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output Modelica.SIunits.MolarMass mm "Molar mass";
  external "C" mm = TILMedia_Liquid_molarMass_xi(liquidPointer, xi) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Liquid_molarMass_xi(double*,void*);",
      Library="TILMedia150ClaRa");
    annotation (Impure=false);
  end molarMass_xi;

  function properties_hxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.SIunits.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output Modelica.SIunits.Density d "Density";
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity cp";
    output Modelica.SIunits.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
  external "C" TILMedia_Liquid_properties_hxi(
        h,
        xi, liquidPointer,
        d,
        cp,
        beta) annotation (
      __iti_dllNoExport=true,
      Include=
          "void TILMedia_Liquid_properties_hxi(double, double*, void*, double*, double*, double*);",
      Library="TILMedia150ClaRa");

    annotation (Impure=false);
  end properties_hxi;

  function properties_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.SIunits.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output Modelica.SIunits.Density d "Density";
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity cp";
    output Modelica.SIunits.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
  external "C" TILMedia_Liquid_properties_Txi(
        T,
        xi, liquidPointer,
        d,
        cp,
        beta) annotation (
      __iti_dllNoExport=true,
      Include=
          "void TILMedia_Liquid_properties_Txi(double, double*, void*, double*, double*, double*);",
      Library="TILMedia150ClaRa");

    annotation (Impure=false);
  end properties_Txi;

  function specificEnthalpy_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";
  external "C" h = TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include=
          "double TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(double, double*, void*);",
      Library="TILMedia150ClaRa");
      annotation (
      inverse(T=temperature_hxi(
              h,
              xi,
              liquidPointer)));

  end specificEnthalpy_Txi;

  function specificEntropy_pTxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input Modelica.SIunits.AbsolutePressure p "Pressure";
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.SIunits.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output Modelica.SIunits.SpecificEntropy s "Specific entropy";
  external "C" s = TILMedia_Liquid_specificEntropy_pTxi(
        p,
        T,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include=
          "double TILMedia_Liquid_specificEntropy_pTxi(double, double, double*, void*);",
      Library="TILMedia150ClaRa");

    annotation (Impure=false);
  end specificEntropy_pTxi;

  function temperature_hxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output SI.Temperature T "Temperature";
  external "C" T = TILMedia_LiquidObjectFunctions_temperature_hxi(
        h,
        xi,
        liquidPointer) annotation (
      __iti_dllNoExport=true,
      Include=
          "double TILMedia_LiquidObjectFunctions_temperature_hxi(double, double*, void*);",
      Library="TILMedia150ClaRa");
      annotation (
      inverse(h=specificEnthalpy_Txi(
              T,
              xi,
              liquidPointer)));

  end temperature_hxi;

  function transportPropertyRecord_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.SIunits.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
    output TILMedia.Internals.TransportPropertyRecord transp
      "Transport property record";
  external "C" TILMedia_Liquid_transportProperties_Txi(
        T,
        xi, liquidPointer,
        transp.Pr,
        transp.lambda,
        transp.eta,
        transp.sigma) annotation (
      __iti_dllNoExport=true,
      Include=
          "void TILMedia_Liquid_transportProperties_Txi(double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia150ClaRa");

    annotation (Impure=false);
  end transportPropertyRecord_Txi;

  package PureComponentDerivatives
      extends TILMedia.Internals.ClassTypes.ModelPackage;

    function temperature_hxi
      extends TILMedia.BaseClasses.PartialLiquidFunction;
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      output SI.Temperature T "Temperature";
    external "C" T = TILMedia_LiquidObjectFunctions_temperature_hxi(h, xi, liquidPointer)
      annotation(__iti_dllNoExport = true,Include="double TILMedia_LiquidObjectFunctions_temperature_hxi(double, double*, void*);",Library="TILMedia150ClaRa");
      annotation(inverse(h=specificEnthalpy_Txi(T,xi,liquidPointer)), derivative = TILMedia.Internals.LiquidObjectFunctions.PureComponentDerivatives.der_temperature_hxi);
    end temperature_hxi;

    function der_temperature_hxi "derivative function for pure components"
      extends TILMedia.BaseClasses.PartialLiquidFunction;
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      input Real der_h "Specific enthalpy";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real der_T "Temperature";
      external "C" der_T = TILMedia_LiquidObjectFunctions_der_temperature_hxi(h, xi, der_h, der_xi, liquidPointer)
      annotation(__iti_dllNoExport = true,Include="double TILMedia_LiquidObjectFunctions_der_temperature_hxi(double, double*, double, double*, void*);",Library="TILMedia150ClaRa");
    end der_temperature_hxi;

    function specificEnthalpy_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
      input SI.Temperature T "Temperature";
      input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      output SI.SpecificEnthalpy h "Specific enthalpy";
    external "C" h = TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(T, xi, liquidPointer)
      annotation(__iti_dllNoExport = true,Include="double TILMedia_LiquidObjectFunctions_specificEnthalpy_Txi(double, double*, void*);",Library="TILMedia150ClaRa");
      annotation(inverse(T=temperature_hxi(h,xi,liquidPointer)), derivative(noDerivative=liquidPointer)=TILMedia.Internals.LiquidObjectFunctions.PureComponentDerivatives.der_specificEnthalpy_Txi);
    end specificEnthalpy_Txi;

      function der_specificEnthalpy_Txi
      "derivative function for pure components"
      extends TILMedia.BaseClasses.PartialLiquidFunction;
      input SI.Temperature T "Temperature";
      input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      input Real der_T "Derivative of Temperature";
      input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
      output Real der_h "Derivative of Specific enthalpy";
      external "C" der_h = TILMedia_LiquidObjectFunctions_der_specificEnthalpy_Txi(T, xi, der_T, der_xi, liquidPointer)
          annotation(__iti_dllNoExport = true,Include="double TILMedia_LiquidObjectFunctions_der_specificEnthalpy_Txi(double, double*, double, double*, void*);",Library="TILMedia150ClaRa");
      end der_specificEnthalpy_Txi;

    function properties_hxi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      output Modelica.SIunits.Density d "Density";
      output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity cp";
      output Modelica.SIunits.LinearExpansionCoefficient beta
        "Isobaric expansion coefficient";
    external "C" TILMedia_Liquid_properties_hxi(h,xi, liquidPointer,
          d,
          cp,
          beta)
        annotation(__iti_dllNoExport = true,Include="void TILMedia_Liquid_properties_hxi(double, double*, void*, double*, double*, double*);",Library="TILMedia150ClaRa");
        annotation(derivative(noDerivative=liquidPointer)=TILMedia.Internals.LiquidObjectFunctions.PureComponentDerivatives.der_properties_hxi, Impure=false);
    end properties_hxi;

    function der_properties_hxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject mediumPointer;
      input Real der_h "Specific enthalpy";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real der_d "Density";
      output Real der_cp "Specific heat capacity cp";
      output Real der_beta "Isobaric expansion coefficient";
      external "C" TILMedia_Liquid_der_properties_hxi(h,xi,mediumPointer,der_h,der_xi,der_d,der_cp,der_beta)
        annotation(__iti_dllNoExport = true,Include="void TILMedia_Liquid_der_properties_hxi(double, double*, void*, double, double*, double*, double*, double*);",Library="TILMedia150ClaRa");
        annotation(Impure=false);
    end der_properties_hxi;

    function properties_Txi
    extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.Temperature T "Temperature";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      output Modelica.SIunits.Density d "Density";
      output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity cp";
      output Modelica.SIunits.LinearExpansionCoefficient beta
        "Isobaric expansion coefficient";
    external "C" TILMedia_Liquid_properties_Txi(T,xi, liquidPointer,
          d,
          cp,
          beta)
        annotation(__iti_dllNoExport = true,Include="void TILMedia_Liquid_properties_Txi(double, double*, void*, double*, double*, double*);",Library="TILMedia150ClaRa");
        annotation(derivative(noDerivative=liquidPointer)=TILMedia.Internals.LiquidObjectFunctions.PureComponentDerivatives.der_properties_Txi, Impure=false);
    end properties_Txi;

    function der_properties_Txi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.Temperature T "Temperature";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject mediumPointer;
      input Real der_T "Temperature";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real der_d "Density";
      output Real der_cp "Specific heat capacity cp";
      output Real der_beta "Isobaric expansion coefficient";
      external "C" TILMedia_Liquid_der_properties_Txi(T,xi,mediumPointer,der_T, der_xi,der_d,der_cp,der_beta)
        annotation(__iti_dllNoExport = true,Include="void TILMedia_Liquid_der_properties_Txi(double, double*, void*, double, double*, double*, double*, double*);",Library="TILMedia150ClaRa");
        annotation(Impure=false);
    end der_properties_Txi;

    function transportPropertyRecord_Txi
      extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.Temperature T "Temperature";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      output TILMedia.Internals.TransportPropertyRecord transp
        "Transport property record";
    external "C" TILMedia_Liquid_transportProperties_Txi(
          T,
          xi, liquidPointer,
          transp.Pr,
          transp.lambda,
          transp.eta,
          transp.sigma) annotation (
        __iti_dllNoExport=true,
        Include=
            "void TILMedia_Liquid_transportProperties_Txi(double, double*, void*, double*, double*, double*, double*);",
        Library="TILMedia150ClaRa");

      annotation (derivative(noDerivative=liquidPointer)=TILMedia.Internals.LiquidObjectFunctions.PureComponentDerivatives.der_transportPropertyRecord_Txi, Impure=false);
    end transportPropertyRecord_Txi;

    function der_transportPropertyRecord_Txi
      extends TILMedia.BaseClasses.PartialLiquidFunction;
      input Modelica.SIunits.Temperature T "Temperature";
      input Modelica.SIunits.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.LiquidObjectFunctions.LiquidPointerExternalObject liquidPointer;
      input Real der_T "Temperature";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output TILMedia.Internals.TransportPropertyRecord transp
        "Transport property record";
    external "C" TILMedia_Liquid_der_transportProperties_Txi(
          T,
          xi, liquidPointer,
          der_T,
          der_xi,
          transp.Pr,
          transp.lambda,
          transp.eta,
          transp.sigma) annotation (
        __iti_dllNoExport=true,
        Include=
            "void TILMedia_Liquid_der_transportProperties_Txi(double, double*, void*, double, double*, double*, double*, double*, double*);",
        Library="TILMedia150ClaRa");

      annotation (Impure=false);
    end der_transportPropertyRecord_Txi;
  end PureComponentDerivatives;
end LiquidObjectFunctions;
