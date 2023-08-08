﻿within TILMedia.Internals;
package VLEFluidObjectFunctions
  extends TILMedia.Internals.ClassTypes.ModelPackage;

  function density_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
   input SI.AbsolutePressure p "Pressure";
   input SI.SpecificEnthalpy h "Specific Enthalpy";
   input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
   output SI.Density d "Density";
  external "C" d = TILMedia_VLEFluid_Cached_density_phxi(
        p,
        h,
        xi, vleFluidPointer)
  annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_density_phxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
  annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.der_density_phxi,Impure=false);
  end density_phxi;

    function der_density_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific Enthalpy";
      input SI.MassFraction[:] xi
    "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
      input Real der_p "Derivative of Pressure";
      input Real der_h "Derivative of Specific Enthalpy";
      input Real[:] der_xi
    "Derivative of Mass fractions of the first nc-1 components";
      output Real der_d "Derivative of Density";
    algorithm
      der_d :=+
      TILMedia.VLEFluidObjectFunctions.densityDerivativeWRTpressure_phxi(
          p,
          h,
          xi,
          vleFluidPointer)*der_p +
      TILMedia.VLEFluidObjectFunctions.densityDerivativeWRTspecificEnthalpy_phxi(
          p,
          h,
          xi,
          vleFluidPointer)*der_h + {
      TILMedia.VLEFluidObjectFunctions.densityDerivativeWRTmassFraction_phxin(
          p,
          h,
          xi,
          i,
          vleFluidPointer) for i in 1:size(xi, 1)}*der_xi;
    end der_density_phxi;

  function additionalProperties_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MassFraction x "Steam mass fraction";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa "Isothermal compressibility";
    output TILMedia.Internals.Units.DensityDerPressure drhodp
      "Derivative of density wrt pressure";
    output TILMedia.Internals.Units.DensityDerSpecificEnthalpy drhodh
      "Derivative of density wrt specific enthalpy";
    output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
    output SI.Velocity a "Speed of sound";
    output Real gamma "Heat capacity ratio";
  external "C" TILMedia_VLEFluid_additionalProperties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
        x,
        cp,
        cv,
        beta,
        kappa,
        drhodp,
        drhodh,
        drhodxi,
        a,
        gamma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_additionalProperties_dTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end additionalProperties_dTxi;

  function additionalProperties_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MassFraction x "Steam mass fraction";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa "Isothermal compressibility";
    output TILMedia.Internals.Units.DensityDerPressure drhodp
      "Derivative of density wrt pressure";
    output TILMedia.Internals.Units.DensityDerSpecificEnthalpy drhodh
      "Derivative of density wrt specific enthalpy";
    output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
    output SI.Velocity a "Speed of sound";
    output Real gamma "Heat capacity ratio";
  external "C" TILMedia_VLEFluid_additionalProperties_phxi(
        p,
        h,
        xi, vleFluidPointer,
        x,
        cp,
        cv,
        beta,
        kappa,
        drhodp,
        drhodh,
        drhodxi,
        a,
        gamma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_additionalProperties_phxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end additionalProperties_phxi;

  function additionalProperties_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MassFraction x "Steam mass fraction";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa "Isothermal compressibility";
    output TILMedia.Internals.Units.DensityDerPressure drhodp
      "Derivative of density wrt pressure";
    output TILMedia.Internals.Units.DensityDerSpecificEnthalpy drhodh
      "Derivative of density wrt specific enthalpy";
    output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
    output SI.Velocity a "Speed of sound";
    output Real gamma "Heat capacity ratio";
  external "C" TILMedia_VLEFluid_additionalProperties_psxi(
        p,
        s,
        xi, vleFluidPointer,
        x,
        cp,
        cv,
        beta,
        kappa,
        drhodp,
        drhodh,
        drhodxi,
        a,
        gamma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_additionalProperties_psxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end additionalProperties_psxi;

  function additionalProperties_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MassFraction x "Steam mass fraction";
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa "Isothermal compressibility";
    output TILMedia.Internals.Units.DensityDerPressure drhodp
      "Derivative of density wrt pressure";
    output TILMedia.Internals.Units.DensityDerSpecificEnthalpy drhodh
      "Derivative of density wrt specific enthalpy";
    output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
    output SI.Velocity a "Speed of sound";
    output Real gamma "Heat capacity ratio";
  external "C" TILMedia_VLEFluid_additionalProperties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
        x,
        cp,
        cv,
        beta,
        kappa,
        drhodp,
        drhodh,
        drhodxi,
        a,
        gamma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_additionalProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end additionalProperties_pTxi;

  function criticalDataRecord_xi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Real d,h,p,s,T;
  external "C" TILMedia_VLEFluid_criticalDataRecord_xi(
        xi, vleFluidPointer,
        d,
        h,
        p,
        s,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_criticalDataRecord_xi(double*, void*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end criticalDataRecord_xi;

  function molarMass_xi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MolarMass mm "Molar mass";
  external "C" mm = TILMedia_VLEFluid_Cached_molarMass_xi(xi)
  annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_molarMass_xi(double*,void*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end molarMass_xi;

  function properties_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.AbsolutePressure p "Pressure";
    output SI.SpecificEntropy s "Specific entropy";
  external "C" TILMedia_VLEFluid_properties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
        h,
        p,
        s)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_dTxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_dTxi;

  function properties_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d "Density";
    output SI.SpecificEntropy s "Specific entropy";
    output SI.Temperature T "Temperature";
  external "C" TILMedia_VLEFluid_properties_phxi(
        p,
        h,
        xi, vleFluidPointer,
        d,
        s,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_phxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_phxi;

  function properties_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d "Density";
    output SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.Temperature T "Temperature";
  external "C" TILMedia_VLEFluid_properties_psxi(
        p,
        s,
        xi, vleFluidPointer,
        d,
        h,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_psxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_psxi;

  function properties_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d "Density";
    output SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.SpecificEntropy s "Specific entropy";
  external "C" TILMedia_VLEFluid_properties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
        d,
        h,
        s)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_pTxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_pTxi;

  function transportPropertyRecord_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external "C" TILMedia_VLEFluid_transportProperties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
        Pr,
        lambda,
        eta,
        sigma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_transportProperties_dTxi(double, double, double*, void*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end transportPropertyRecord_dTxi;

  function transportPropertyRecord_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external "C" TILMedia_VLEFluid_transportProperties_phxi(
        p,
        h,
        xi, vleFluidPointer,
        Pr,
        lambda,
        eta,
        sigma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_transportProperties_phxi(double, double, double*, void*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end transportPropertyRecord_phxi;

  function transportPropertyRecord_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external "C" TILMedia_VLEFluid_transportProperties_psxi(
        p,
        s,
        xi, vleFluidPointer,
        Pr,
        lambda,
        eta,
        sigma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_transportProperties_psxi(double, double, double*, void*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end transportPropertyRecord_psxi;

  function transportPropertyRecord_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external "C" TILMedia_VLEFluid_transportProperties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
        Pr,
        lambda,
        eta,
        sigma)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_transportProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end transportPropertyRecord_pTxi;

  function VLETransportPropertyRecord_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr_l "Prandtl number";
    output SI.PrandtlNumber Pr_v "Prandtl number";
    output SI.ThermalConductivity lambda_l "Thermal conductivity";
    output SI.ThermalConductivity lambda_v "Thermal conductivity";
    output SI.DynamicViscosity eta_l "Dynamic viscosity";
    output SI.DynamicViscosity eta_v "Dynamic viscosity";
  external "C" TILMedia_VLEFluid_VLETransportProperties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
        Pr_l,
        Pr_v,
        lambda_l,
        lambda_v,
        eta_l,
        eta_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLETransportProperties_dTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLETransportPropertyRecord_dTxi;

  function VLETransportPropertyRecord_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr_l "Prandtl number";
    output SI.PrandtlNumber Pr_v "Prandtl number";
    output SI.ThermalConductivity lambda_l "Thermal conductivity";
    output SI.ThermalConductivity lambda_v "Thermal conductivity";
    output SI.DynamicViscosity eta_l "Dynamic viscosity";
    output SI.DynamicViscosity eta_v "Dynamic viscosity";
  external "C" TILMedia_VLEFluid_VLETransportProperties_phxi(
        p,
        h,
        xi, vleFluidPointer,
        Pr_l,
        Pr_v,
        lambda_l,
        lambda_v,
        eta_l,
        eta_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLETransportProperties_phxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLETransportPropertyRecord_phxi;

  function VLETransportPropertyRecord_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr_l "Prandtl number";
    output SI.PrandtlNumber Pr_v "Prandtl number";
    output SI.ThermalConductivity lambda_l "Thermal conductivity";
    output SI.ThermalConductivity lambda_v "Thermal conductivity";
    output SI.DynamicViscosity eta_l "Dynamic viscosity";
    output SI.DynamicViscosity eta_v "Dynamic viscosity";
  external "C" TILMedia_VLEFluid_VLETransportProperties_psxi(
        p,
        s,
        xi, vleFluidPointer,
        Pr_l,
        Pr_v,
        lambda_l,
        lambda_v,
        eta_l,
        eta_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLETransportProperties_psxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLETransportPropertyRecord_psxi;

  function VLETransportPropertyRecord_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.PrandtlNumber Pr_l "Prandtl number";
    output SI.PrandtlNumber Pr_v "Prandtl number";
    output SI.ThermalConductivity lambda_l "Thermal conductivity";
    output SI.ThermalConductivity lambda_v "Thermal conductivity";
    output SI.DynamicViscosity eta_l "Dynamic viscosity";
    output SI.DynamicViscosity eta_v "Dynamic viscosity";
  external "C" TILMedia_VLEFluid_VLETransportProperties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
        Pr_l,
        Pr_v,
        lambda_l,
        lambda_v,
        eta_l,
        eta_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLETransportProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLETransportPropertyRecord_pTxi;

  function fluidIsValid
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input String mediumName;
    output Boolean isValid;
  external "C" isValid = TILMedia_VLEFluid_isValid(mediumName) annotation (
      __iti_dllNoExport=true,
      Include="int TILMedia_VLEFluid_isValid(const char*, int*);",
      Library="TILMedia170ClaRa");
                                                                                                 annotation(Impure=false);
  end fluidIsValid;

  function phase_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Integer phase;
  external "C" TILMedia_VLEFluid_Cached_phase_dTxi(
      d,
      T,
      xi, vleFluidPointer,
      phase)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_Cached_phase_dTxi(double, double, double*, void*, int*);",Library="TILMedia170ClaRa");
  end phase_dTxi;

  function phase_phxi2
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Integer phase;
  external "C" TILMedia_VLEFluid_Cached_phase_phxi(
        p,
        h,
        xi, vleFluidPointer,
        phase)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_Cached_phase_phxi(double, double, double*, void*, int*)",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end phase_phxi2;

  function phase_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Integer phase;
  algorithm
    phase := phase_phxi2(
        p,
        h,
        xi,
        vleFluidPointer);
  end phase_phxi;

  function VLEAdditionalProperties_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificHeatCapacity cp_l
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_l
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_l
      "Isothermal compressibility";
    output SI.SpecificHeatCapacity cp_v
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_v
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_v
      "Isothermal compressibility";
  external "C" TILMedia_VLEFluid_VLEAdditionalProperties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
    cp_l, beta_l, kappa_l,
    cp_v, beta_v, kappa_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEAdditionalProperties_dTxi(double, double, double*, void*,double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEAdditionalProperties_dTxi;

  function VLEAdditionalProperties_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificHeatCapacity cp_l
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_l
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_l
      "Isothermal compressibility";
    output SI.SpecificHeatCapacity cp_v
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_v
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_v
      "Isothermal compressibility";
  external "C" TILMedia_VLEFluid_VLEAdditionalProperties_phxi(
        p,
        h,
        xi, vleFluidPointer,
    cp_l, beta_l, kappa_l,
    cp_v, beta_v, kappa_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEAdditionalProperties_phxi(double, double, double*, void*,double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEAdditionalProperties_phxi;

  function VLEAdditionalProperties_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificHeatCapacity cp_l
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_l
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_l
      "Isothermal compressibility";
    output SI.SpecificHeatCapacity cp_v
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_v
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_v
      "Isothermal compressibility";
  external "C" TILMedia_VLEFluid_VLEAdditionalProperties_psxi(
        p,
        s,
        xi, vleFluidPointer,
    cp_l, beta_l, kappa_l,
    cp_v, beta_v, kappa_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEAdditionalProperties_psxi(double, double, double*, void*,double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEAdditionalProperties_psxi;

  function VLEAdditionalProperties_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificHeatCapacity cp_l
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_l
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_l
      "Isothermal compressibility";
    output SI.SpecificHeatCapacity cp_v
      "Specific heat capacity cp";
    output SI.LinearExpansionCoefficient beta_v
      "Isobaric expansion coefficient";
    output SI.Compressibility kappa_v
      "Isothermal compressibility";
  external "C" TILMedia_VLEFluid_VLEAdditionalProperties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
    cp_l, beta_l, kappa_l,
    cp_v, beta_v, kappa_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEAdditionalProperties_pTxi(double, double, double*, void*,double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEAdditionalProperties_pTxi;

  function VLEProperties_dTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d_l "Density";
    output SI.SpecificEnthalpy h_l "Specific enthalpy";
    output SI.AbsolutePressure p_l "Pressure";
    output SI.SpecificEntropy s_l "Specific entropy";
    output SI.Temperature T_l "Temperature";
    output SI.MassFraction[size(xi,1)] xi_l "Mass fractions";
    output SI.Density d_v "Density";
    output SI.SpecificEnthalpy h_v "Specific enthalpy";
    output SI.AbsolutePressure p_v "Pressure";
    output SI.SpecificEntropy s_v "Specific entropy";
    output SI.Temperature T_v "Temperature";
    output SI.MassFraction[size(xi,1)] xi_v "Mass fractions";
  external "C" TILMedia_VLEFluid_VLEProperties_dTxi(
        d,
        T,
        xi, vleFluidPointer,
    d_l, h_l, p_l, s_l, T_l, xi_l,
    d_v, h_v, p_v, s_v, T_v, xi_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEProperties_dTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*,
                double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEProperties_dTxi;

  function VLEProperties_phxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d_l "Density";
    output SI.SpecificEnthalpy h_l "Specific enthalpy";
    output SI.AbsolutePressure p_l "Pressure";
    output SI.SpecificEntropy s_l "Specific entropy";
    output SI.Temperature T_l "Temperature";
    output SI.MassFraction[size(xi,1)] xi_l "Mass fractions";
    output SI.Density d_v "Density";
    output SI.SpecificEnthalpy h_v "Specific enthalpy";
    output SI.AbsolutePressure p_v "Pressure";
    output SI.SpecificEntropy s_v "Specific entropy";
    output SI.Temperature T_v "Temperature";
    output SI.MassFraction[size(xi,1)] xi_v "Mass fractions";
  external "C" TILMedia_VLEFluid_VLEProperties_phxi(
        p,
        h,
        xi, vleFluidPointer,
    d_l, h_l, p_l, s_l, T_l, xi_l,
    d_v, h_v, p_v, s_v, T_v, xi_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEProperties_phxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*,
                double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
           annotation(Impure=false);
  end VLEProperties_phxi;

  function VLEProperties_psxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d_l "Density";
    output SI.SpecificEnthalpy h_l "Specific enthalpy";
    output SI.AbsolutePressure p_l "Pressure";
    output SI.SpecificEntropy s_l "Specific entropy";
    output SI.Temperature T_l "Temperature";
    output SI.MassFraction[size(xi,1)] xi_l "Mass fractions";
    output SI.Density d_v "Density";
    output SI.SpecificEnthalpy h_v "Specific enthalpy";
    output SI.AbsolutePressure p_v "Pressure";
    output SI.SpecificEntropy s_v "Specific entropy";
    output SI.Temperature T_v "Temperature";
    output SI.MassFraction[size(xi,1)] xi_v "Mass fractions";
  external "C" TILMedia_VLEFluid_VLEProperties_psxi(
        p,
        s,
        xi, vleFluidPointer,
    d_l, h_l, p_l, s_l, T_l, xi_l,
    d_v, h_v, p_v, s_v, T_v, xi_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEProperties_psxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*,
                double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEProperties_psxi;

  function VLEProperties_pTxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d_l "Density";
    output SI.SpecificEnthalpy h_l "Specific enthalpy";
    output SI.AbsolutePressure p_l "Pressure";
    output SI.SpecificEntropy s_l "Specific entropy";
    output SI.Temperature T_l "Temperature";
    output SI.MassFraction[size(xi,1)] xi_l "Mass fractions";
    output SI.Density d_v "Density";
    output SI.SpecificEnthalpy h_v "Specific enthalpy";
    output SI.AbsolutePressure p_v "Pressure";
    output SI.SpecificEntropy s_v "Specific entropy";
    output SI.Temperature T_v "Temperature";
    output SI.MassFraction[size(xi,1)] xi_v "Mass fractions";
  external "C" TILMedia_VLEFluid_VLEProperties_pTxi(
        p,
        T,
        xi, vleFluidPointer,
    d_l, h_l, p_l, s_l, T_l, xi_l,
    d_v, h_v, p_v, s_v, T_v, xi_v)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*,
                double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end VLEProperties_pTxi;

  function molarMass_nc
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input Integer nc "Number of components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.MolarMass mm_i[nc] "Molar mass";
  external "C" TILMedia_VLEFluid_Cached_molarMass(vleFluidPointer, mm_i) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_VLEFluid_Cached_molarMass(void*,double*);",
      Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end molarMass_nc;

  function triplePressure_n
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input Integer compNo;
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.AbsolutePressure p_triple "Triple pressure";
  external "C" p_triple = TILMedia_VLEFluid_Cached_triplePressure_n(compNo, vleFluidPointer)
  annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_triplePressure_n(int, void*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end triplePressure_n;

  function tripleTemperature_n
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input Integer compNo;
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Temperature T_triple "Triple temperature";
  external "C" T_triple = TILMedia_VLEFluid_Cached_tripleTemperature_n(compNo, vleFluidPointer)
  annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_tripleTemperature_n(int, void*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end tripleTemperature_n;

  function cricondenbar_xi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Real d,h,p,s,T;
  external "C" TILMedia_VLEFluid_cricondenbar_xi(
        xi, vleFluidPointer,
        d,
        h,
        p,
        s,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_cricondenbar_xi(double*, void*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end cricondenbar_xi;

  function cricondentherm_xi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output Real d,h,p,s,T;
  external "C" TILMedia_VLEFluid_cricondentherm_xi(
        xi, vleFluidPointer,
        d,
        h,
        p,
        s,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_cricondentherm_xi(double*, void*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                                                                                        annotation(Impure=false);
  end cricondentherm_xi;

  function properties_pdxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Density d "Density";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.SpecificEntropy s "Specific entropy";
    output SI.Temperature T "Temperature";
  external "C" TILMedia_VLEFluid_properties_pdxi(
        p,
        d,
        xi, vleFluidPointer,
        h,
        s,
        T)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_pdxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_pdxi;

  function meanDensity_phAhB
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input Real p;
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input Real h_A;
    input Real h_B;
    input TILMedia.Internals.TILMediaExternalObject
      cache_A "Pointer to external medium mem||y";
    input TILMedia.Internals.TILMediaExternalObject
      cache_B "Pointer to external medium mem||y";
    output Real rhobar;
    output Real drhobar_dp;
    output Real drhobar_dh1;
    output Real drhobar_dh2;
    output Real onePhase;
  external "C" TILMedia_VLEFluid_meanDensity_phAhB(
        p,
        xi,
        h_A,
        h_B,
        cache_A,
        cache_B,
        rhobar,
        drhobar_dp,
        drhobar_dh1,
        drhobar_dh2,
        onePhase)
    annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_meanDensity_phAhB(double, double*, double, double, void*, void*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
  end meanDensity_phAhB;

  function properties_Thxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d "Density";
    output SI.AbsolutePressure p "Pressure";
    output SI.SpecificEntropy s "Specific entropy";
  external "C" TILMedia_VLEFluid_properties_Thxi(
        T,
        h,
        xi, vleFluidPointer,
        d,
        p,
        s)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_Thxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_Thxi;

  function properties_Tsxi
    extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
    input SI.Temperature T "Temperature";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction[:] xi
      "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject
      vleFluidPointer;
    output SI.Density d "Density";
    output SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.AbsolutePressure p "Pressure";
  external "C" TILMedia_VLEFluid_properties_Tsxi(
        T,
        s,
        xi, vleFluidPointer,
        d,
        h,
        p)
  annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_properties_Tsxi(double, double, double*, void*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                    annotation(Impure=false);
  end properties_Tsxi;

  package PureComponentDerivatives
    extends TILMedia.Internals.ClassTypes.ModelPackage;

    function specificEntropy_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEntropy s "Specific Entropy";
    external "C" s = TILMedia_VLEFluid_Cached_specificEntropy_dTxi(
          d,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEntropy_dTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEntropy_dTxi,
      Impure=false);

    end specificEntropy_dTxi;

    function der_specificEntropy_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_d "Derivative of Density";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_s "Derivative of Specific Entropy";
    external "C" der_s = TILMedia_VLEFluid_Cached_der_specificEntropy_dTxi(
          d,
          T,
          xi,
          der_d,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEntropy_dTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEntropy_dTxi;

    function specificEnthalpy_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEnthalpy h "Specific Enthalpy";
    external "C" h = TILMedia_VLEFluid_Cached_specificEnthalpy_dTxi(
          d,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEnthalpy_dTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEnthalpy_dTxi,Impure=false);
    end specificEnthalpy_dTxi;

    function der_specificEnthalpy_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_d "Derivative of Density";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_h "Derivative of Specific Enthalpy";
    external "C" der_h = TILMedia_VLEFluid_Cached_der_specificEnthalpy_dTxi(
          d,
          T,
          xi,
          der_d,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEnthalpy_dTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEnthalpy_dTxi;

    function pressure_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.AbsolutePressure p "Pressure";
    external "C" p = TILMedia_VLEFluid_Cached_pressure_dTxi(
          d,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_pressure_dTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_pressure_dTxi,
      inverse(d=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.density_pTxi(p, T, xi, vleFluidPointer)),Impure=false);
    end pressure_dTxi;

    function der_pressure_dTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.Density d "Density";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_d "Derivative of Density";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_p "Derivative of Pressure";
    external "C" der_p = TILMedia_VLEFluid_Cached_der_pressure_dTxi(
          d,
          T,
          xi,
          der_d,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_pressure_dTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_pressure_dTxi;

    function temperature_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.Temperature T "Temperature";
    external "C" T = TILMedia_VLEFluid_Cached_temperature_psxi(
          p,
          s,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_temperature_psxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_temperature_psxi,
      inverse(s=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.specificEntropy_pTxi(p, T, xi, vleFluidPointer)),Impure=false);
    end temperature_psxi;

    function der_temperature_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_s "Derivative of Specific Entropy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_T "Derivative of Temperature";
    external "C" der_T = TILMedia_VLEFluid_Cached_der_temperature_psxi(
          p,
          s,
          xi,
          der_p,
          der_s,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_temperature_psxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_temperature_psxi;

    function density_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.Density d "Density";
    external "C" d = TILMedia_VLEFluid_Cached_density_psxi(
          p,
          s,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_density_psxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_density_psxi,Impure=false);
    end density_psxi;

    function der_density_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_s "Derivative of Specific Entropy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_d "Derivative of Density";
    external "C" der_d = TILMedia_VLEFluid_Cached_der_density_psxi(
          p,
          s,
          xi,
          der_p,
          der_s,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_density_psxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_density_psxi;

    function specificEnthalpy_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEnthalpy h "Specific Enthalpy";
    external "C" h = TILMedia_VLEFluid_Cached_specificEnthalpy_psxi(
          p,
          s,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEnthalpy_psxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEnthalpy_psxi, inverse(s=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.specificEntropy_phxi(p, h, xi, vleFluidPointer)),Impure=false);
    end specificEnthalpy_psxi;

    function der_specificEnthalpy_psxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEntropy s "Specific Entropy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_s "Derivative of Specific Entropy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_h "Derivative of Specific Enthalpy";
    external "C" der_h = TILMedia_VLEFluid_Cached_der_specificEnthalpy_psxi(
          p,
          s,
          xi,
          der_p,
          der_s,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEnthalpy_psxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEnthalpy_psxi;

    function temperature_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.Temperature T "Temperature";
    external "C" T = TILMedia_VLEFluid_Cached_temperature_phxi(
          p,
          h,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_temperature_phxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_temperature_phxi, inverse(h=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.specificEnthalpy_pTxi(p, T, xi, vleFluidPointer)),Impure=false);
    end temperature_phxi;

    function der_temperature_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_h "Derivative of Specific Enthalpy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_T "Derivative of Temperature";
    external "C" der_T = TILMedia_VLEFluid_Cached_der_temperature_phxi(
          p,
          h,
          xi,
          der_p,
          der_h,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_temperature_phxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_temperature_phxi;

    function specificEntropy_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEntropy s "Specific Entropy";
    external "C" s = TILMedia_VLEFluid_Cached_specificEntropy_phxi(
          p,
          h,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEntropy_phxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEntropy_phxi, inverse(h=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.specificEnthalpy_psxi(p, s, xi, vleFluidPointer)),Impure=false);
    end specificEntropy_phxi;

    function der_specificEntropy_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_h "Derivative of Specific Enthalpy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_s "Derivative of Specific Entropy";
    external "C" der_s = TILMedia_VLEFluid_Cached_der_specificEntropy_phxi(
          p,
          h,
          xi,
          der_p,
          der_h,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEntropy_phxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEntropy_phxi;

    function density_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.Density d "Density";
    external "C" d = TILMedia_VLEFluid_Cached_density_phxi(
          p,
          h,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_density_phxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_density_phxi,Impure=false);
    end density_phxi;

    function der_density_phxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.SpecificEnthalpy h "Specific Enthalpy";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_h "Derivative of Specific Enthalpy";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_d "Derivative of Density";
    external "C" der_d = TILMedia_VLEFluid_Cached_der_density_phxi(
          p,
          h,
          xi,
          der_p,
          der_h,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_density_phxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_density_phxi;

    function specificEntropy_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEntropy s "Specific Entropy";
    external "C" s = TILMedia_VLEFluid_Cached_specificEntropy_pTxi(
          p,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEntropy_pTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEntropy_pTxi, inverse(T=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.temperature_psxi(p, s, xi, vleFluidPointer)),Impure=false);
    end specificEntropy_pTxi;

    function der_specificEntropy_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_s "Derivative of Specific Entropy";
    external "C" der_s = TILMedia_VLEFluid_Cached_der_specificEntropy_pTxi(
          p,
          T,
          xi,
          der_p,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEntropy_pTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEntropy_pTxi;

    function density_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.Density d "Density";
    external "C" d = TILMedia_VLEFluid_Cached_density_pTxi(
          p,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_density_pTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_density_pTxi);
    end density_pTxi;

    function der_density_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_d "Derivative of Density";
    external "C" der_d = TILMedia_VLEFluid_Cached_der_density_pTxi(
          p,
          T,
          xi,
          der_p,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_density_pTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_density_pTxi;

    function specificEnthalpy_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     output SI.SpecificEnthalpy h "Specific Enthalpy";
    external "C" h = TILMedia_VLEFluid_Cached_specificEnthalpy_pTxi(
          p,
          T,
          xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_specificEnthalpy_pTxi(double, double, double*, void*);",Library="TILMedia170ClaRa");
    annotation(derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_specificEnthalpy_pTxi, inverse(T=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.temperature_phxi(p, h, xi, vleFluidPointer)),Impure=false);
    end specificEnthalpy_pTxi;

    function der_specificEnthalpy_pTxi
      extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
     input SI.AbsolutePressure p "Pressure";
     input SI.Temperature T "Temperature";
     input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
     input Real der_p "Derivative of Pressure";
     input Real der_T "Derivative of Temperature";
     input Real[:] der_xi
        "Derivative of Mass fractions of the first nc-1 components";
     output Real der_h "Derivative of Specific Enthalpy";
    external "C" der_h = TILMedia_VLEFluid_Cached_der_specificEnthalpy_pTxi(
          p,
          T,
          xi,
          der_p,
          der_T,
          der_xi, vleFluidPointer)
    annotation(__iti_dllNoExport = true,Include="double TILMedia_VLEFluid_Cached_der_specificEnthalpy_pTxi(double, double, double*, double, double, double*, void*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false);
    end der_specificEnthalpy_pTxi;

    function VLEProperties_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      output SI.Density d_l "Density";
      output SI.SpecificEnthalpy h_l "Specific enthalpy";
      output SI.AbsolutePressure p_l "Pressure";
      output SI.SpecificEntropy s_l "Specific entropy";
      output SI.Temperature T_l "Temperature";
      output SI.MassFraction[size(xi,1)] xi_l "Mass fractions";
      output SI.Density d_v "Density";
      output SI.SpecificEnthalpy h_v "Specific enthalpy";
      output SI.AbsolutePressure p_v "Pressure";
      output SI.SpecificEntropy s_v "Specific entropy";
      output SI.Temperature T_v "Temperature";
      output SI.MassFraction[size(xi,1)] xi_v "Mass fractions";
    external "C" TILMedia_VLEFluid_VLEProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
      d_l, h_l, p_l, s_l, T_l, xi_l,
      d_v, h_v, p_v, s_v, T_v, xi_v)
    annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_VLEProperties_phxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*,
                double*, double*, double*, double*, double*, double*);",  Library="TILMedia170ClaRa");
             annotation(Impure=false,derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_VLEProperties_phxi);
    end VLEProperties_phxi;

    function der_VLEProperties_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      input Real der_p "Pressure";
      input Real der_h "Specific enthalpy";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real der_d_l "Density";
      output Real der_h_l "Specific enthalpy";
      output Real der_p_l "Pressure";
      output Real der_s_l "Specific entropy";
      output Real der_T_l "Temperature";
      output Real[size(xi,1)] der_xi_l "Mass fractions";
      output Real der_d_v "Density";
      output Real der_h_v "Specific enthalpy";
      output Real der_p_v "Pressure";
      output Real der_s_v "Specific entropy";
      output Real der_T_v "Temperature";
      output Real[size(xi,1)] der_xi_v "Mass fractions";
    external "C" TILMedia_VLEFluid_der_VLEProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
          der_p,
          der_h,
          der_xi,
      der_d_l, der_h_l, der_p_l, der_s_l, der_T_l, der_xi_l,
      der_d_v, der_h_v, der_p_v, der_s_v, der_T_v, der_xi_v)
    annotation(Library="TILMedia170ClaRa",__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_der_VLEProperties_phxi(double, double, double*, void*,
                double, double, double*,double*, double*, double*, double*, double*, double*,double*, double*, double*, double*, double*, double*);");
                                      annotation(Impure=false);
    end der_VLEProperties_phxi;

    function transportPropertyRecord_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      output SI.PrandtlNumber Pr "Prandtl number";
      output SI.ThermalConductivity lambda "Thermal conductivity";
      output SI.DynamicViscosity eta "Dynamic viscosity";
      output SI.SurfaceTension sigma "Surface tension";
    external "C" TILMedia_VLEFluid_transportProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
          Pr,
          lambda,
          eta,
          sigma)
    annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_transportProperties_phxi(double, double, double*, void*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false, derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_transportPropertyRecord_phxi);
    end transportPropertyRecord_phxi;

    function der_transportPropertyRecord_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      input Real der_p "Pressure";
      input Real der_h "Specific enthalpy";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real der_Pr "Prandtl number";
      output Real der_lambda "Thermal conductivity";
      output Real der_eta "Dynamic viscosity";
      output Real der_sigma "Surface tension";
    external "C" TILMedia_VLEFluid_der_transportProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
          der_p,
          der_h,
          der_xi,
          der_Pr,
          der_lambda,
          der_eta,
          der_sigma)
    annotation(Library="TILMedia170ClaRa",__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_der_transportProperties_phxi(double, double, double*, void*, double, double, double*, double*, double*, double*, double*);");
                                      annotation(Impure=false);
    end der_transportPropertyRecord_phxi;

    function additionalProperties_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      output SI.MassFraction x "Steam mass fraction";
      output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
      output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
      output SI.LinearExpansionCoefficient beta
        "Isobaric expansion coefficient";
      output SI.Compressibility kappa "Isothermal compressibility";
      output TILMedia.Internals.Units.DensityDerPressure drhodp
        "Derivative of density wrt pressure";
      output TILMedia.Internals.Units.DensityDerSpecificEnthalpy drhodh
        "Derivative of density wrt specific enthalpy";
      output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
      output SI.Velocity a "Speed of sound";
      output Real gamma "Heat capacity ratio";
    external "C" TILMedia_VLEFluid_additionalProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
          x,
          cp,
          cv,
          beta,
          kappa,
          drhodp,
          drhodh,
          drhodxi,
          a,
          gamma)
    annotation(__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_additionalProperties_phxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*);",Library="TILMedia170ClaRa");
                                      annotation(Impure=false,derivative(noDerivative=vleFluidPointer)=TILMedia.Internals.VLEFluidObjectFunctions.PureComponentDerivatives.der_additionalProperties_phxi);
    end additionalProperties_phxi;

    function der_additionalProperties_phxi
        extends TILMedia.BaseClasses.PartialVLEFluidObjectFunction;
      input SI.AbsolutePressure p "Pressure";
      input SI.SpecificEnthalpy h "Specific enthalpy";
      input SI.MassFraction[:] xi
        "Mass fractions of the first nc-1 components";
      input TILMedia.Internals.TILMediaExternalObject
        vleFluidPointer;
      input Real der_p "Pressure";
      input Real der_h "Specific enthalpy";
      input Real[:] der_xi "Mass fractions of the first nc-1 components";
      output Real x "Steam mass fraction";
      output Real cp "Specific heat capacity cp";
      output Real cv "Specific heat capacity cv";
      output Real beta "Isobaric expansion coefficient";
      output Real kappa "Isothermal compressibility";
      output Real drhodp "Derivative of density wrt pressure";
      output Real drhodh "Derivative of density wrt specific enthalpy";
      output Real[size(xi,1)] drhodxi "Derivative of density wrt mass fraction";
      output Real a "Speed of sound";
      output Real gamma "Heat capacity ratio";
    external "C" TILMedia_VLEFluid_der_additionalProperties_phxi(
          p,
          h,
          xi, vleFluidPointer,
          der_p,
          der_h,
          der_xi,
          x,
          cp,
          cv,
          beta,
          kappa,
          drhodp,
          drhodh,
          drhodxi,
          a,
          gamma)
    annotation(Library="TILMedia170ClaRa",__iti_dllNoExport = true,Include="void TILMedia_VLEFluid_der_additionalProperties_phxi(double, double, double*, void*, double, double, double*, double*, double*, double*, double*, double*, double*
        , double*, double*, double*, double*);");
                                      annotation(Impure=false);
    end der_additionalProperties_phxi;
  end PureComponentDerivatives;
end VLEFluidObjectFunctions;
