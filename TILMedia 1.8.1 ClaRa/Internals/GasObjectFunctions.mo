within TILMedia.Internals;
package GasObjectFunctions
  extends TILMedia.Internals.ClassTypes.ModelPackage;

  function molarMass_nc
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input Integer nc "Number of components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.MolarMass mm_i[nc] "Molar mass of component i";


  external"C" TILMedia_Gas_molarMass(gasPointer, mm_i) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_molarMass(void*, double*);",
      Library="TILMedia181ClaRa");
    annotation (Impure=false);
  end molarMass_nc;

  function pureComponentProperties_Tnc
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer nc "Number of components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.PartialPressure ppS "Saturation partial pressure of condensing component";
    output SI.SpecificEnthalpy delta_hv "Specific enthalpy of vaporation of condensing component";
    output SI.SpecificEnthalpy delta_hd "Specific enthalpy of desublimation of condensing component";
    output SI.SpecificEnthalpy h_idealGas[nc] "Specific enthalpy of theoretical pure component ideal gas state";


  external"C" TILMedia_Gas_pureComponentProperties_T(
        T,
        gasPointer,
        ppS,
        delta_hv,
        delta_hd,
        h_idealGas) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_pureComponentProperties_T(double, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");
    annotation (Impure=false);
  end pureComponentProperties_Tnc;

  function simpleCondensingProperties_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta "Isothermal expansion coefficient";
    output SI.Velocity w "Speed of sound";


  external"C" TILMedia_Gas_simpleCondensingProperties_phxi(
        p,
        h,
        xi,
        gasPointer,
        cp,
        cv,
        beta,
        w) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_simpleCondensingProperties_phxi(double p, double h, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false, derivative(noDerivative=gasPointer)=TILMedia.Internals.GasObjectFunctions.der_simpleCondensingProperties_phxi);
  end simpleCondensingProperties_phxi;

  function der_simpleCondensingProperties_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_cp "Specific heat capacity cp";
    output Real der_cv "Specific heat capacity cv";
    output Real der_beta "Isothermal expansion coefficient";
    output Real der_w "Speed of sound";

  external"C" TILMedia_Gas_der_simpleCondensingProperties_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer,
        der_cp,
        der_cv,
        der_beta,
        der_w) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_der_simpleCondensingProperties_phxi(double, double, double*, double, double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_simpleCondensingProperties_phxi;

  function simpleCondensingProperties_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cp "Specific heat capacity cp";
    output SI.SpecificHeatCapacity cv "Specific heat capacity cv";
    output SI.LinearExpansionCoefficient beta "Isothermal expansion coefficient";
    output SI.Velocity w "Speed of sound";


  external"C" TILMedia_Gas_simpleCondensingProperties_pTxi(
        p,
        T,
        xi,
        gasPointer,
        cp,
        cv,
        beta,
        w) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_simpleCondensingProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false, derivative(noDerivative=gasPointer)=TILMedia.Internals.GasObjectFunctions.der_simpleCondensingProperties_pTxi);
  end simpleCondensingProperties_pTxi;

  function der_simpleCondensingProperties_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_cp "Specific heat capacity cp";
    output Real der_cv "Specific heat capacity cv";
    output Real der_beta "Isothermal expansion coefficient";
    output Real der_w "Speed of sound";

  external"C" TILMedia_Gas_der_simpleCondensingProperties_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer,
        der_cp,
        der_cv,
        der_beta,
        der_w) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_der_simpleCondensingProperties_pTxi(double, double, double*, double, double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_simpleCondensingProperties_pTxi;

  function additionalProperties_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Density d "Density";
    output SI.Compressibility kappa "Compressibility";
    output SI.DerDensityByPressure drhodp_hxi "Derivative of density wrt pressure";
    output SI.DerDensityByEnthalpy drhodh_pxi "Derivative of density wrt specific enthalpy";
    output SI.Density drhodxi_ph[size(xi, 1)] "Derivative of density wrt mass fraction";
    output SI.PartialPressure pp[size(xi, 1) + 1] "Partial pressure";
    output SI.MassFraction xi_gas "Mass fraction of gasoues condensing component";


  external"C" TILMedia_Gas_additionalProperties_pTxi(
        p,
        T,
        xi,
        gasPointer,
        d,
        kappa,
        drhodp_hxi,
        drhodh_pxi,
        drhodxi_ph,
        pp,
        xi_gas) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_additionalProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end additionalProperties_pTxi;

  function temperature_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T "Temperature";


  external"C" T = TILMedia_Gas_temperature_psxi(
        p,
        s,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_temperature_psxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(s=TILMedia.Internals.GasObjectFunctions.specificEntropy_pTxi(
              p,
              T,
              xi,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_temperature_psxi);
  end temperature_psxi;

  function der_temperature_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_s "Specific entropy";
    input Real der_xi[:] "Mass fraction";
    output Real der_T "Temperature";

  external"C" der_T = TILMedia_Gas_der_temperature_psxi(
        p,
        s,
        xi,
        der_p,
        der_s,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_temperature_psxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end der_temperature_psxi;

  function specificEnthalpy_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";


  external"C" h = TILMedia_Gas_specificEnthalpy_psxi(
        p,
        s,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_specificEnthalpy_psxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(s=TILMedia.Internals.GasObjectFunctions.specificEntropy_phxi(
              p,
              h,
              xi,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEnthalpy_psxi);
  end specificEnthalpy_psxi;

  function der_specificEnthalpy_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_s "Specific entropy";
    input Real der_xi[:] "Mass fraction";
    output Real der_h "Specific enthalpy";

  external"C" der_h = TILMedia_Gas_der_specificEnthalpy_psxi(
        p,
        s,
        xi,
        der_p,
        der_s,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_specificEnthalpy_psxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_specificEnthalpy_psxi;

  function specificEntropy_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEntropy s "Specific entropy";


  external"C" s = TILMedia_Gas_specificEntropy_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_specificEntropy_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(T=TILMedia.Internals.GasObjectFunctions.temperature_psxi(
              p,
              s,
              xi,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEntropy_pTxi);
  end specificEntropy_pTxi;

  function der_specificEntropy_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_s "Specific entropy";

  external"C" der_s = TILMedia_Gas_der_specificEntropy_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_specificEntropy_pTxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_specificEntropy_pTxi;

  function specificEntropy_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEntropy s "Specific entropy";


  external"C" s = TILMedia_Gas_specificEntropy_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_specificEntropy_phxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(h=TILMedia.Internals.GasObjectFunctions.specificEnthalpy_psxi(
              p,
              s,
              xi,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEntropy_phxi);
  end specificEntropy_phxi;

  function der_specificEntropy_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real der_xi[:] "Mass fraction";
    output Real der_s "Specific entropy";

  external"C" der_s = TILMedia_Gas_der_specificEntropy_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_specificEntropy_phxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_specificEntropy_phxi;

  function xi_humRatioxidgnc
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input Real humRatioxi_dryGas[nc - 1] "Humidity ratio and xi_dryGas in one vector";
    input Integer nc;
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.MassFraction xi[nc - 1] "Mass fraction";


  external"C" TILMedia_Gas_xi_humRatioxidg(
        humRatioxi_dryGas,
        gasPointer,
        xi) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_xi_humRatioxidg(double*, void*, double*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(humRatioxi_dryGas=TILMedia.Internals.GasObjectFunctions.humRatioxidg_xinc(
              xi,
              nc,
              gasPointer)));
  end xi_humRatioxidgnc;

  function humRatioxidg_xinc
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.MassFraction xi[nc - 1] "Mass fraction";
    input Integer nc;
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real humRatioxi_dryGas[nc - 1] "Humidity ratio and xi_dryGas in one vector";


  external"C" TILMedia_Gas_humRatioxidg_xi(
        xi,
        gasPointer,
        humRatioxi_dryGas) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_humRatioxidg_xi(double*, void*, double*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(xi=TILMedia.Internals.GasObjectFunctions.xi_humRatioxidgnc(
              humRatioxi_dryGas,
              nc,
              gasPointer)));
  end humRatioxidg_xinc;

  function wetBulbTemperatureLiquid_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureLiquid_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureLiquid_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureLiquid_pTxi;

  function wetBulbTemperatureSolid_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureSolid_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureSolid_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureSolid_pTxi;

  function wetBulbTemperatureLiquid_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureLiquid_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureLiquid_phxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureLiquid_phxi;

  function wetBulbTemperatureSolid_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureSolid_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureSolid_phxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureSolid_phxi;

  function wetBulbTemperatureLiquid_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureLiquid_psxi(
        p,
        s,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureLiquid_psxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureLiquid_psxi;

  function wetBulbTemperatureSolid_psxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEntropy s "Specific entropy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T_wetBulb "Wet bulb temperature";


  external"C" T_wetBulb = TILMedia_GasMixture_wetBulbTemperatureSolid_psxi(
        p,
        s,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_wetBulbTemperatureSolid_psxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end wetBulbTemperatureSolid_psxi;

  function temperature_pdxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Density d "Density";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T "Temperature";


  external"C" T = TILMedia_GasMixture_temperature_pdxi(
        p,
        d,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasMixture_temperature_pdxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end temperature_pdxi;

  function liquidDensity_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Density d "density";


  external"C" d = TILMedia_Gas_liquidDensity_T(T, gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_liquidDensity_T(double, void*);",
      Library="TILMedia181ClaRa");
  end liquidDensity_T;

  function specificEntropyOfPureGas_pTxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEntropy s_i "Specific entropy of theoretical pure component";


  external"C" s_i = TILMedia_GasObjectFunctions_specificEntropyOfPureGas_pTxin(
        p,
        T,
        xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificEntropyOfPureGas_pTxin(double, double, double*,int, void*);",
      Library="TILMedia181ClaRa");

  end specificEntropyOfPureGas_pTxin;

  function dhdT_pxi_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dhdT_pxi;
  external"C" dhdT_pxi = TILMedia_Gas_dhdT_pxi_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dhdT_pxi_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end dhdT_pxi_pTxi;

  function dhdp_Txi_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dhdp_Txi;
  external"C" dhdp_Txi = TILMedia_Gas_dhdp_Txi_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dhdp_Txi_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end dhdp_Txi_pTxi;

  function dhdxi_pT_pTxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dhdxi_pT;
  external"C" dhdxi_pT = TILMedia_Gas_dhdxi_pT_pTxi(
        p,
        T,
        xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dhdxi_pT_pTxi(double, double, double*, int, void*);",
      Library="TILMedia181ClaRa");
  end dhdxi_pT_pTxin;

  function dd_dT_pxi_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dd_dT_pxi;
  external"C" dd_dT_pxi = TILMedia_Gas_dd_dT_pxi_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dd_dT_pxi_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end dd_dT_pxi_pTxi;

  function dd_dp_Txi_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dd_dp_Txi;
  external"C" dd_dp_Txi = TILMedia_Gas_dd_dp_Txi_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dd_dp_Txi_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
  end dd_dp_Txi_pTxi;

  function dd_dxi_pT_pTxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real dd_dxi_pT;
  external"C" dd_dxi_pT = TILMedia_Gas_dd_dxi_pT_pTxi(
        p,
        T,
        xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_dd_dxi_pT_pTxi(double, double, double*, int, void*);",
      Library="TILMedia181ClaRa");
  end dd_dxi_pT_pTxin;

  function density_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Density d "Density";
  external"C" d = TILMedia_GasObjectFunctions_density_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_density_pTxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_density_pTxi);
  end density_pTxi;

  function der_density_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_d "Density";
  algorithm
    der_d := der_p*TILMedia.Internals.GasObjectFunctions.dd_dp_Txi_pTxi(
        p,
        T,
        xi,
        gasPointer) + der_T*TILMedia.Internals.GasObjectFunctions.dd_dT_pxi_pTxi(
        p,
        T,
        xi,
        gasPointer) + der_xi*{TILMedia.Internals.GasObjectFunctions.dd_dxi_pT_pTxin(
        p,
        T,
        xi,
        i,
        gasPointer) for i in 0:size(xi, 1) - 1};
  end der_density_pTxi;

  function density_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Density d "Density";
  external"C" d = TILMedia_GasObjectFunctions_density_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_density_phxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_density_phxi);
  end density_phxi;

  function der_density_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_d "Density";
  external"C" der_d = TILMedia_GasObjectFunctions_der_density_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_density_phxi(double, double, double*,double, double, double*,void*);",
      Library="TILMedia181ClaRa");

  end der_density_phxi;

  function specificAbsoluteGasEntropy_pTn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEntropy s_i "Specific entropy of theoretical pure component";

  external"C" s_i = TILMedia_GasObjectFunctions_specificAbsoluteGasEntropy_pTn(
        p,
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificAbsoluteGasEntropy_pTn(double, double, int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(
        noDerivative=compNo,
        noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificAbsoluteGasEntropy_pTn);
  end specificAbsoluteGasEntropy_pTn;

  function der_specificAbsoluteGasEntropy_pTn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    output Real der_s_i "Specific entropy of theoretical pure component";

  external"C" der_s_i = TILMedia_GasObjectFunctions_der_specificAbsoluteGasEntropy_pTn(
        p,
        T,
        der_p,
        der_T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificAbsoluteGasEntropy_pTn(double, double, double, double, int, void*);",
      Library="TILMedia181ClaRa");

  end der_specificAbsoluteGasEntropy_pTn;

  function specificAbsoluteLiquidEntropy_pTn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEntropy s_i "Specific entropy of theoretical pure component";

  external"C" s_i = TILMedia_GasObjectFunctions_specificAbsoluteLiquidEntropy_pTn(
        p,
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificAbsoluteLiquidEntropy_pTn(double, double, int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(
        noDerivative=compNo,
        noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificAbsoluteLiquidEntropy_pTn);
  end specificAbsoluteLiquidEntropy_pTn;

  function der_specificAbsoluteLiquidEntropy_pTn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    output Real der_s_i "Specific entropy of theoretical pure component";

  external"C" der_s_i = TILMedia_GasObjectFunctions_der_specificAbsoluteLiquidEntropy_pTn(
        p,
        T,
        der_p,
        der_T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificAbsoluteLiquidEntropy_pTn(double, double, double, double, int, void*);",
      Library="TILMedia181ClaRa");

  end der_specificAbsoluteLiquidEntropy_pTn;

  function specificGasEnthalpy_refStateHf_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy h_i "Specific entropy of theoretical pure component";

  external"C" h_i = TILMedia_GasObjectFunctions_specificGasEnthalpy_refStateHf_Tn(
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificGasEnthalpy_refStateHf_Tn(double, int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(
        noDerivative=compNo,
        noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificGasEnthalpy_refStateHf_Tn);
  end specificGasEnthalpy_refStateHf_Tn;

  function der_specificGasEnthalpy_refStateHf_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_h_i "Specific entropy of theoretical pure component";

  external"C" der_h_i = TILMedia_GasObjectFunctions_der_specificGasEnthalpy_refStateHf_Tn(
        T,
        der_T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificGasEnthalpy_refStateHf_Tn(double, double, int, void*);",
      Library="TILMedia181ClaRa");
  end der_specificGasEnthalpy_refStateHf_Tn;

  function specificLiquidEnthalpy_refStateHf_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy h_i "Specific entropy of theoretical pure component";

  external"C" h_i = TILMedia_GasObjectFunctions_specificLiquidEnthalpy_refStateHf_Tn(
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificLiquidEnthalpy_refStateHf_Tn(double, int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(
        noDerivative=compNo,
        noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificLiquidEnthalpy_refStateHf_Tn);
  end specificLiquidEnthalpy_refStateHf_Tn;

  function der_specificLiquidEnthalpy_refStateHf_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_h_i "Specific entropy of theoretical pure component";

  external"C" der_h_i = TILMedia_GasObjectFunctions_der_specificLiquidEnthalpy_refStateHf_Tn(
        T,
        der_T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificLiquidEnthalpy_refStateHf_Tn(double, double, int, void*);",
      Library="TILMedia181ClaRa");

  end der_specificLiquidEnthalpy_refStateHf_Tn;

  function specificIsobaricHeatCapacityOfPureGas_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cp_i "Specific isobaric heat capacity of theoretical pure component";

  external"C" cp_i = TILMedia_GasObjectFunctions_specificIsobaricHeatCapacityOfPureGas_Tn(
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificIsobaricHeatCapacityOfPureGas_Tn(double,int, void*);",
      Library="TILMedia181ClaRa");

      annotation(derivative(noDerivative=compNo, noDerivative=gasPointer)=TILMedia.Internals.GasObjectFunctions.der_specificIsobaricHeatCapacityOfPureGas_Tn);
  end specificIsobaricHeatCapacityOfPureGas_Tn;

  function der_specificIsobaricHeatCapacityOfPureGas_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_cp_i "Specific isobaric heat capacity of theoretical pure component";

  external"C" der_cp_i = TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacityOfPureGas_Tn(
        T,
        der_T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacityOfPureGas_Tn(double,double,int, void*);",
      Library="TILMedia181ClaRa");
  end der_specificIsobaricHeatCapacityOfPureGas_Tn;

  function temperature_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Temperature T "Temperature";
  external"C" T = TILMedia_Gas_temperature_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_temperature_phxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(h=TILMedia.Internals.GasObjectFunctions.specificEnthalpy_pTxi(
              p,
              T,
              xi,
              gasPointer)), derivative=TILMedia.Internals.GasObjectFunctions.der_temperature_phxi);
  end temperature_phxi;

  function der_temperature_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real der_xi[:] "Mass fraction";
    output Real der_T "Temperature";
  external"C" der_T = TILMedia_GasObjectFunctions_der_temperature_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_temperature_phxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_temperature_phxi;

  function specificEnthalpy_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy h "Specific enthalpy";

  external"C" h = TILMedia_Gas_specificEnthalpy_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_specificEnthalpy_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(T=TILMedia.Internals.GasObjectFunctions.temperature_phxi(
              p,
              h,
              xi,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEnthalpy_pTxi);
  end specificEnthalpy_pTxi;

  function der_specificEnthalpy_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_h "Specific enthalpy";
  algorithm
    der_h := der_p*TILMedia.Internals.GasObjectFunctions.dhdp_Txi_pTxi(
        p,
        T,
        xi,
        gasPointer) + der_T*TILMedia.Internals.GasObjectFunctions.dhdT_pxi_pTxi(
        p,
        T,
        xi,
        gasPointer) + der_xi*{TILMedia.Internals.GasObjectFunctions.dhdxi_pT_pTxin(
        p,
        T,
        xi,
        i,
        gasPointer) for i in 0:size(xi, 1) - 1};
  end der_specificEnthalpy_pTxi;

  function transportProperties_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
    output SI.ThermalConductivity lambda "Thermal conductivity";
    output SI.DynamicViscosity eta "Dynamic viscosity";
    output SI.SurfaceTension sigma "Surface tension";
  external"C" TILMedia_Gas_transportProperties_pTxi(
        p,
        T,
        xi,
        gasPointer,
        Pr,
        lambda,
        eta,
        sigma) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_transportProperties_pTxi(double, double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false, derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_transportProperties_pTxi);
  end transportProperties_pTxi;

  function der_transportProperties_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_Pr "Prandtl number";
    output Real der_lambda "Thermal conductivity";
    output Real der_eta "Dynamic viscosity";
    output Real der_sigma "Surface tension";
  external"C" TILMedia_Gas_der_transportProperties_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer,
        der_Pr,
        der_lambda,
        der_eta,
        der_sigma) annotation (
      __iti_dllNoExport=true,
      Include="void TILMedia_Gas_der_transportProperties_pTxi(double, double, double*, double, double, double*, void*, double*, double*, double*, double*);",
      Library="TILMedia181ClaRa");

    annotation (Impure=false);
  end der_transportProperties_pTxi;

  function specificIsobaricHeatCapacity_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cp "Specific isobaric heat capacity cp";
  external"C" cp = TILMedia_GasObjectFunctions_specificIsobaricHeatCapacity_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificIsobaricHeatCapacity_phxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificIsobaricHeatCapacity_phxi);
  end specificIsobaricHeatCapacity_phxi;

  function der_specificIsobaricHeatCapacity_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_cp "Specific isobaric heat capacity cp";
  external"C" der_cp = TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacity_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacity_phxi(double, double, double*,double, double, double*,void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsobaricHeatCapacity_phxi;

  function specificIsochoricHeatCapacity_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cv "Specific isochoric heat capacity cp";
  external"C" cv = TILMedia_GasObjectFunctions_specificIsochoricHeatCapacity_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificIsochoricHeatCapacity_phxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificIsochoricHeatCapacity_phxi);

  end specificIsochoricHeatCapacity_phxi;

  function der_specificIsochoricHeatCapacity_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_cv "Specific isochoric heat capacity cp";
  external"C" der_cv = TILMedia_GasObjectFunctions_der_specificIsochoricHeatCapacity_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificIsochoricHeatCapacity_phxi(double, double, double*,double, double, double*,void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsochoricHeatCapacity_phxi;

  function speedOfSound_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Velocity w "Speed of sound";
  external"C" w = TILMedia_GasObjectFunctions_speedOfSound_phxi(
      p,
      h,
      xi,
      gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_speedOfSound_phxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_speedOfSound_phxi);
  end speedOfSound_phxi;

  function der_speedOfSound_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fraction";
    output Real der_w "Speed of sound";
  external"C" der_w = TILMedia_GasObjectFunctions_der_speedOfSound_phxi(
      p,
      h,
      xi,
      der_p,
      der_h,
      der_xi,
      gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_speedOfSound_phxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_speedOfSound_phxi;

  function densityDerivativeWRTspecificEnthalpy_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.DerDensityByEnthalpy drhodh_pxi
      "Derivative of density wrt specific enthalpy at constant pressure and mass fraction";
  external"C" drhodh_pxi = TILMedia_GasObjectFunctions_densityDerivativeWRTspecificEnthalpy_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_densityDerivativeWRTspecificEnthalpy_phxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_densityDerivativeWRTspecificEnthalpy_phxi);
  end densityDerivativeWRTspecificEnthalpy_phxi;

  function der_densityDerivativeWRTspecificEnthalpy_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_drhodh_pxi "Derivative of density wrt specific enthalpy at constant pressure and mass fraction";
  external"C" der_drhodh_pxi = TILMedia_GasObjectFunctions_der_densityDerivativeWRTspecificEnthalpy_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_densityDerivativeWRTspecificEnthalpy_phxi(double, double, double*,double, double, double*,void*);",
      Library="TILMedia181ClaRa");

  end der_densityDerivativeWRTspecificEnthalpy_phxi;

  function densityDerivativeWRTpressure_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.DerDensityByPressure drhodp_hxi
      "Derivative of density wrt pressure at specific enthalpy and mass fraction";
  external"C" drhodp_hxi = TILMedia_GasObjectFunctions_densityDerivativeWRTpressure_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_densityDerivativeWRTpressure_phxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_densityDerivativeWRTpressure_phxi);
  end densityDerivativeWRTpressure_phxi;

  function der_densityDerivativeWRTpressure_phxi "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_drhodp_hxi "Derivative of density wrt pressure at specific enthalpy and mass fraction";
  external"C" der_drhodp_hxi = TILMedia_GasObjectFunctions_der_densityDerivativeWRTpressure_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_densityDerivativeWRTpressure_phxi(double, double, double*,double, double, double*,void*);",
      Library="TILMedia181ClaRa");

  end der_densityDerivativeWRTpressure_phxi;

  function densityDerivativeWRTmassFraction_phxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input Integer compNo "Index of component";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output TILMedia.Internals.Units.DensityDerMassFraction drhodxi_ph
      "Derivative of density wrt mass fraction at constant pressure and specific enthalpy";
  external"C" drhodxi_ph = TILMedia_GasObjectFunctions_densityDerivativeWRTmassFraction_phxin(
        p,
        h,
        xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_densityDerivativeWRTmassFraction_phxin(double, double, double*,int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_densityDerivativeWRTmassFraction_phxin);
  end densityDerivativeWRTmassFraction_phxin;

  function der_densityDerivativeWRTmassFraction_phxin "derivative function for pure components"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input Integer compNo "Index of component";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_drhodxi_ph "Derivative of density wrt mass fraction at pressure and specific enthalpy";
  external"C" der_drhodxi_ph = TILMedia_GasObjectFunctions_der_densityDerivativeWRTmassFraction_phxin(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_densityDerivativeWRTmassFraction_phxin(double, double, double*,double, double, double*,int,void*);",
      Library="TILMedia181ClaRa");

  end der_densityDerivativeWRTmassFraction_phxin;

  function specificIsobaricHeatCapacity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cp "Specific isobaric heat capacity cp";
  external"C" cp = TILMedia_GasObjectFunctions_specificIsobaricHeatCapacity_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificIsobaricHeatCapacity_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = der_specificIsobaricHeatCapacity_pTxi);
  end specificIsobaricHeatCapacity_pTxi;

  function der_specificIsobaricHeatCapacity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_cp "Specific isobaric heat capacity cp";
  external"C" der_cp = TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacity_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificIsobaricHeatCapacity_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsobaricHeatCapacity_pTxi;

  function specificIsochoricHeatCapacity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificHeatCapacity cv "Specific isochoric heat capacity cp";
  external"C" cv = TILMedia_GasObjectFunctions_specificIsochoricHeatCapacity_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificIsochoricHeatCapacity_pTxi(double, double, double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificIsochoricHeatCapacity_pTxi);

  end specificIsochoricHeatCapacity_pTxi;

  function der_specificIsochoricHeatCapacity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_cv "Specific isochoric heat capacity cp";
  external"C" der_cv = TILMedia_GasObjectFunctions_der_specificIsochoricHeatCapacity_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificIsochoricHeatCapacity_pTxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_specificIsochoricHeatCapacity_pTxi;

  function speedOfSound_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Velocity w "Speed of sound";
  external"C" w = TILMedia_GasObjectFunctions_speedOfSound_pTxi(
      p,
      T,
      xi,
      gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_speedOfSound_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_speedOfSound_pTxi);
  end speedOfSound_pTxi;

  function der_speedOfSound_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_w "Speed of sound";
  external"C" der_w = TILMedia_GasObjectFunctions_der_speedOfSound_pTxi(
      p,
      T,
      xi,
      der_p,
      der_T,
      der_xi,
      gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_speedOfSound_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_speedOfSound_pTxi;

  function specificEnthalpyOfPureGas_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy h_i "Specific enthalpy of theoretical pure component";

  external"C" h_i = TILMedia_GasObjectFunctions_specificEnthalpyOfPureGas_Tn(
        T,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificEnthalpyOfPureGas_Tn(double,int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEnthalpyOfPureGas_Tn);
  end specificEnthalpyOfPureGas_Tn;

  function der_specificEnthalpyOfPureGas_Tn
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_h_i "Specific enthalpy of theoretical pure component";

  algorithm

    der_h_i := der_T*TILMedia.Internals.GasObjectFunctions.specificIsobaricHeatCapacityOfPureGas_Tn(
        T,
        compNo,
        gasPointer);

  end der_specificEnthalpyOfPureGas_Tn;

  function specificEnthalpyOfVaporisation_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;

    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy delta_hv "Specific enthalpy of vaporisation of condensing component";

  external"C" delta_hv = TILMedia_GasObjectFunctions_specificEnthalpyOfVaporisation_T(T, gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificEnthalpyOfVaporisation_T(double,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEnthalpyOfVaporisation_T);
  end specificEnthalpyOfVaporisation_T;

  function der_specificEnthalpyOfVaporisation_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;

    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_delta_hv "Specific enthalpy of vaporisation of condensing component";

  external"C" der_delta_hv = TILMedia_GasObjectFunctions_der_specificEnthalpyOfVaporisation_T(
        T,
        der_T,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificEnthalpyOfVaporisation_T(double, double, void*);",
      Library="TILMedia181ClaRa");

  end der_specificEnthalpyOfVaporisation_T;

  function specificEnthalpyOfDesublimation_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.SpecificEnthalpy delta_hd "Specific enthalpy of desublimation of condensing component";

  external"C" delta_hd = TILMedia_GasObjectFunctions_specificEnthalpyOfDesublimation_T(T, gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_specificEnthalpyOfDesublimation_T(double,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_specificEnthalpyOfDesublimation_T);
  end specificEnthalpyOfDesublimation_T;

  function der_specificEnthalpyOfDesublimation_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_delta_hd "Specific enthalpy of desublimation of condensing component";

  external"C" der_delta_hd = TILMedia_GasObjectFunctions_der_specificEnthalpyOfDesublimation_T(
        T,
        der_T,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_specificEnthalpyOfDesublimation_T(double, double, void*);",
      Library="TILMedia181ClaRa");
  end der_specificEnthalpyOfDesublimation_T;

  function saturationPartialPressure_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.PartialPressure p_s "Saturation partial pressure of condensing component";

  external"C" p_s = TILMedia_GasObjectFunctions_saturationPartialPressure_T(T, gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_saturationPartialPressure_T(double,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_saturationPartialPressure_T);
  end saturationPartialPressure_T;

  function der_saturationPartialPressure_T
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_T "Temperature";
    output Real der_p_s "Saturation partial pressure of condensing component";

  external"C" der_p_s = TILMedia_GasObjectFunctions_der_saturationPartialPressure_T(
        T,
        der_T,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_saturationPartialPressure_T(double, double, void*);",
      Library="TILMedia181ClaRa");
  end der_saturationPartialPressure_T;

  function relativeHumidity_pThumRatioxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Real humRatio "Humidity ratio";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output TILMedia.Internals.Units.RelativeHumidity phi "Relative humidity";

  external"C" phi = TILMedia_MoistAir_phi_pThumRatioxidg(
        p,
        T,
        humRatio,
        xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_MoistAir_phi_pThumRatioxidg(double, double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(humRatio=TILMedia.Internals.GasObjectFunctions.humidityRatio_pTphixidg(
              p,
              T,
              phi,
              xi_dryGas,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_relativeHumidity_pThumRatioxidg);
  end relativeHumidity_pThumRatioxidg;

  function der_relativeHumidity_pThumRatioxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input Real humRatio "Humidity ratio";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_humRatio "Humidity ratio";
    input Real der_xi_dryGas[:] "Mass fraction of dry gas";
    output Real der_phi "Relative humidity";

  external"C" der_phi = TILMedia_MoistAir_der_phi_pThumRatioxidg(
        p,
        T,
        humRatio,
        xi_dryGas,
        der_p,
        der_T,
        der_humRatio,
        der_xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_MoistAir_der_phi_pThumRatioxidg(double, double, double, double*, double, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    //    annotation (inverse(humRatio=TILMedia.Internals.GasObjectFunctions.humRatio_pTphixidg(p,T,phi,xi_dryGas,gasPointer)));
  end der_relativeHumidity_pThumRatioxidg;

  function humidityRatio_pTphixidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.Units.RelativeHumidity phi "Relative humidity";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real humRatio "Humidity ratio";

  external"C" humRatio = TILMedia_MoistAir_humRatio_pTphixidg(
        p,
        T,
        phi,
        xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_MoistAir_humRatio_pTphixidg(double, double, double, double*, void*);",
      Library="TILMedia181ClaRa");
    annotation (inverse(phi=TILMedia.Internals.GasObjectFunctions.relativeHumidity_pThumRatioxidg(
              p,
              T,
              humRatio,
              xi_dryGas,
              gasPointer)), derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_humidityRatio_pTphixidg);
  end humidityRatio_pTphixidg;

  function der_humidityRatio_pTphixidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input TILMedia.Internals.Units.RelativeHumidity phi "Relative humidity";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_phi "Relative humidity";
    input Real der_xi_dryGas[:] "Mass fraction of dry gas";
    output Real der_humRatio "Humidity ratio";

  external"C" der_humRatio = TILMedia_MoistAir_der_humRatio_pTphixidg(
        p,
        T,
        phi,
        xi_dryGas,
        der_p,
        der_T,
        der_phi,
        der_xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_MoistAir_der_humRatio_pTphixidg(double, double, double, double*, double, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    //    annotation (inverse(phi=TILMedia.Internals.GasObjectFunctions.phi_pThumRatioxidg(p,T,humRatio,xi_dryGas,gasPointer)));
  end der_humidityRatio_pTphixidg;

  function saturationHumidityRatio_pTxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;

    output Real humRatio_s "Saturation humidity ratio";

  external"C" humRatio_s = TILMedia_Gas_saturationHumidityRatio_pTxidg(
        p,
        T,
        xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_saturationHumidityRatio_pTxidg(double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_saturationHumidityRatio_pTxidg);
  end saturationHumidityRatio_pTxidg;

  function der_saturationHumidityRatio_pTxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi_dryGas[:] "Mass fraction of dry gas";
    output Real der_humRatio_s "Saturation humidity ratio";

  external"C" der_humRatio_s = TILMedia_Gas_der_saturationHumidityRatio_pTxidg(
        p,
        T,
        xi_dryGas,
        der_p,
        der_T,
        der_xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_saturationHumidityRatio_pTxidg(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_saturationHumidityRatio_pTxidg;

  function saturationMassFraction_pTxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.MassFraction xi_s "Saturation vapour mass fraction";

  external"C" xi_s = TILMedia_Gas_saturationMassFraction_pTxidg(
        p,
        T,
        xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_saturationMassFraction_pTxidg(double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_saturationMassFraction_pTxidg);
  end saturationMassFraction_pTxidg;

  function der_saturationMassFraction_pTxidg
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi_dryGas[:] "Mass fraction of dry gas";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi_dryGas[:] "Mass fraction of dry gas";
    output Real der_xi_s "Saturation vapour mass fraction";

  external"C" der_xi_s = TILMedia_Gas_der_saturationMassFraction_pTxidg(
        p,
        T,
        xi_dryGas,
        der_p,
        der_T,
        der_xi_dryGas,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_Gas_der_saturationMassFraction_pTxidg(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_saturationMassFraction_pTxidg;

  function saturationHumidityRatio_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;

    output Real humRatio_s "Saturation humidity ratio";

  external"C" humRatio_s = TILMedia_GasObjectFunctions_saturationHumidityRatio_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_saturationHumidityRatio_pTxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_saturationHumidityRatio_pTxi);
  end saturationHumidityRatio_pTxi;

  function der_saturationHumidityRatio_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_humRatio_s "Saturation humidity ratio";

  external"C" der_humRatio_s = TILMedia_GasObjectFunctions_der_saturationHumidityRatio_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_saturationHumidityRatio_pTxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_saturationHumidityRatio_pTxi;

  function saturationHumidityRatio_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;

    output Real humRatio_s "Saturation humidity ratio";

  external"C" humRatio_s = TILMedia_GasObjectFunctions_saturationHumidityRatio_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_saturationHumidityRatio_phxi(double, double, double*, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_saturationHumidityRatio_phxi);
  end saturationHumidityRatio_phxi;

  function der_saturationHumidityRatio_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction xi[:] "Mass fraction";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real der_xi[:] "Mass fraction";
    output Real der_humRatio_s "Saturation humidity ratio";

  external"C" der_humRatio_s = TILMedia_GasObjectFunctions_der_saturationHumidityRatio_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_saturationHumidityRatio_phxi(double, double, double*, double, double, double*, void*);",
      Library="TILMedia181ClaRa");

  end der_saturationHumidityRatio_phxi;

  function gaseousMassFraction_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.MassFraction xi_gas "Mass fraction of gasoues condensing component";

  external"C" xi_gas = TILMedia_GasObjectFunctions_gaseousMassFraction_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_gaseousMassFraction_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_gaseousMassFraction_pTxi);
  end gaseousMassFraction_pTxi;

  function der_gaseousMassFraction_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_xi_gas "Mass fraction of gasoues condensing component";

  external"C" der_xi_gas = TILMedia_GasObjectFunctions_der_gaseousMassFraction_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_gaseousMassFraction_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_gaseousMassFraction_pTxi;

  function isothermalCompressibility_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.Compressibility kappa "Isothermal compressibility";

  external"C" kappa = TILMedia_GasObjectFunctions_isothermalCompressibility_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_isothermalCompressibility_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_isothermalCompressibility_pTxi);
  end isothermalCompressibility_pTxi;

  function der_isothermalCompressibility_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fraction";
    output Real der_kappa "Isothermal compressibility";

  external"C" der_kappa = TILMedia_GasObjectFunctions_der_isothermalCompressibility_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_isothermalCompressibility_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_isothermalCompressibility_pTxi;

  function partialPressure_pTxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.PartialPressure p_i "Partial pressure";
  external"C" p_i = TILMedia_GasObjectFunctions_partialPressure_pTxin(
        p,
        T,
        xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_partialPressure_pTxin(double,double,double*,int, void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(
        noDerivative=compNo,
        noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_partialPressure_pTxin);
  end partialPressure_pTxin;

  function der_partialPressure_pTxin
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input Integer compNo "Component ID";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real[:] der_xi "Mass fractions of the first nc-1 components";
    output Real der_p_i "Partial pressure";
  external"C" der_p_i = TILMedia_GasObjectFunctions_der_partialPressure_pTxin(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        compNo,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_partialPressure_pTxin(double,double,double*,double,double,double*,int,void*);",
      Library="TILMedia181ClaRa");

  end der_partialPressure_pTxin;

  function prandtlNumber_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.PrandtlNumber Pr "Prandtl number";
  external"C" Pr = TILMedia_GasObjectFunctions_prandtlNumber_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_prandtlNumber_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_prandtlNumber_pTxi);
  end prandtlNumber_pTxi;

  function der_prandtlNumber_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_Pr "Prandtl number";
  external"C" der_Pr = TILMedia_GasObjectFunctions_der_prandtlNumber_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_prandtlNumber_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_prandtlNumber_pTxi;

  function thermalConductivity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.ThermalConductivity lambda "Thermal conductivity";
  external"C" lambda = TILMedia_GasObjectFunctions_thermalConductivity_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_thermalConductivity_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_thermalConductivity_pTxi);
  end thermalConductivity_pTxi;

  function der_thermalConductivity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_lambda "Thermal conductivity";
  external"C" der_lambda = TILMedia_GasObjectFunctions_der_thermalConductivity_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_thermalConductivity_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_thermalConductivity_pTxi;

  function dynamicViscosity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.DynamicViscosity eta "Dynamic viscosity";
  external"C" eta = TILMedia_GasObjectFunctions_dynamicViscosity_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_dynamicViscosity_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_dynamicViscosity_pTxi);
  end dynamicViscosity_pTxi;

  function der_dynamicViscosity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_eta "Dynamic viscosity";
  external"C" der_eta = TILMedia_GasObjectFunctions_der_dynamicViscosity_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_dynamicViscosity_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_dynamicViscosity_pTxi;

  function relativeHumidity_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output TILMedia.Internals.Units.RelativeHumidity phi "Relative humidity";
  external"C" phi = TILMedia_GasObjectFunctions_relativeHumidity_phxi(
        p,
        h,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_relativeHumidity_phxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_relativeHumidity_phxi);
  end relativeHumidity_phxi;

  function der_relativeHumidity_phxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_h "Specific enthalpy";
    input Real der_xi[:] "Mass fraction";
    output Real der_phi "Relative humidity";
  external"C" der_phi = TILMedia_GasObjectFunctions_der_relativeHumidity_phxi(
        p,
        h,
        xi,
        der_p,
        der_h,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_relativeHumidity_phxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_relativeHumidity_phxi;

  function relativeHumidity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output TILMedia.Internals.Units.RelativeHumidity phi "Relative humidity";
  external"C" phi = TILMedia_GasObjectFunctions_relativeHumidity_pTxi(
        p,
        T,
        xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_relativeHumidity_pTxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_relativeHumidity_pTxi);
  end relativeHumidity_pTxi;

  function der_relativeHumidity_pTxi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_p "Pressure";
    input Real der_T "Temperature";
    input Real der_xi[:] "Mass fraction";
    output Real der_phi "Relative humidity";
  external"C" der_phi = TILMedia_GasObjectFunctions_der_relativeHumidity_pTxi(
        p,
        T,
        xi,
        der_p,
        der_T,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_relativeHumidity_pTxi(double,double,double*,double,double,double*,void*);",
      Library="TILMedia181ClaRa");

  end der_relativeHumidity_pTxi;

  function humidityRatio_xi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output Real humRatio "Content of condensing component aka humidity ratio";
  external"C" humRatio = TILMedia_GasObjectFunctions_humidityRatio_xi(xi, gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_humidityRatio_xi(double*,void*);",
      Library="TILMedia181ClaRa");

    annotation (derivative(noDerivative=gasPointer) = TILMedia.Internals.GasObjectFunctions.der_humidityRatio_xi);
  end humidityRatio_xi;

  function der_humidityRatio_xi
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    input Real der_xi[:] "Mass fraction";
    output Real der_humRatio "Content of condensing component aka humidity ratio";
  external"C" der_humRatio = TILMedia_GasObjectFunctions_der_humidityRatio_xi(
        xi,
        der_xi,
        gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_der_humidityRatio_xi(double*,double*,void*);",
      Library="TILMedia181ClaRa");
  end der_humidityRatio_xi;

  function fractionSolidWRTnonGaseousMass_phxi "Fraction of solid wrt total non-gaseous mass (solid+liquid)"
    extends TILMedia.BaseClasses.PartialGasObjectFunction;
    input SI.AbsolutePressure p "Pressure";
    input SI.SpecificEnthalpy h "Specific enthalpy";
    input SI.MassFraction[:] xi "Mass fractions of the first nc-1 components";
    input TILMedia.Internals.TILMediaExternalObject gasPointer;
    output SI.MassFraction q_solid "Solid mass fraction";
  external"C" q_solid = TILMedia_GasObjectFunctions_fractionSolidWRTnonGaseousMass_phxi(
      p,
      h,
      xi,
      gasPointer) annotation (
      __iti_dllNoExport=true,
      Include="double TILMedia_GasObjectFunctions_fractionSolidWRTnonGaseousMass_phxi(double,double,double*,void*);",
      Library="TILMedia181ClaRa");
  end fractionSolidWRTnonGaseousMass_phxi;
end GasObjectFunctions;
