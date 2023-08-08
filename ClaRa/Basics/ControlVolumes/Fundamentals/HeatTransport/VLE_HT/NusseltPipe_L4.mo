within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltPipe_L4 "Pipe || VLE || Nusselt || 1ph"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.3.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L4;

  import fluidObjectFunction_cp = TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluidObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluidObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluidObjectFunctions.density_phxi;
  import sm = ClaRa.Basics.Functions.Stepsmoother;

  Modelica.SIunits.CoefficientOfHeatTransfer alpha[iCom.N_cv] "Heat transfer coefficient";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha_lam[iCom.N_cv] "Heat transfer coefficient - laminar part";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha_turb[iCom.N_cv] "Heat transfer coefficient - turbolent part";
  Real failureStatus[iCom.N_cv] "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";

  parameter Integer boundary = 1 "Choice of heat transfer boundary condition, relevant for laminar flow heat transfer" annotation(choices(choice=1 "Uniform wall temperature in developed fluid flow (UWT+DFF)",
                           choice=2 "Uniform heat flux in developed fluid flow (UHF+DFF)",
                           choice=3 "Uniform wall temperature in undeveloped fluid flow (UWT+UFF)",
                           choice=4 "Uniform heat flux in undeveloped fluid flow (UHF+UFF)"));
  parameter Integer correlation = 1 "Cprrelation type" annotation(choices(choice=1 "Gnielinski | VDI Heat Atlas | roughness considered", choice = 2 "Ditttus and Boelter | Bejan | roughness neglected"));

  ClaRa.Basics.Units.Velocity velocity[geo.N_cv] "Mean velocity";
  ClaRa.Basics.Units.ReynoldsNumber Re[geo.N_cv] "Reynolds number";
  ClaRa.Basics.Units.PrandtlNumber Pr[geo.N_cv]  "Prandtl number";

protected
  constant   ClaRa.Basics.Units.ReynoldsNumber laminar=2200 "Maximum Reynolds number for laminar regime";
  constant ClaRa.Basics.Units.ReynoldsNumber turbulent=1e4 "Minimum Reynolds number for turbulent regime";
  Real MIN=Modelica.Constants.eps "Limiter";

  ClaRa.Basics.Units.NusseltNumber Nu0=if boundary == 1 or boundary == 3 then
            0.7 else if boundary == 2 or boundary == 4 then
            0.6 else 0 "Help variable for mean Nusselt number";
  ClaRa.Basics.Units.NusseltNumber Nu1=if boundary == 1 or boundary == 3 then
            3.66 else if boundary == 2 or boundary == 4 then
            4.364 else 0 "Help variable for mean Nusselt number";

  ClaRa.Basics.Units.NusseltNumber Nu2[geo.N_cv] "Help variable for mean Nusselt number";
  ClaRa.Basics.Units.NusseltNumber Nu3[geo.N_cv] "Help variable for mean Nusselt number";

   ClaRa.Basics.Units.NusseltNumber Nu_lam[geo.N_cv] "Mean laminar Nusselt number";
   ClaRa.Basics.Units.NusseltNumber Nu[geo.N_cv] "Mean overall Nusselt number";

  ClaRa.Basics.Units.ThermalConductivity lambda[geo.N_cv];
  ClaRa.Basics.Units.DensityMassSpecific rho[geo.N_cv];
  ClaRa.Basics.Units.DynamicViscosity eta[geo.N_cv];
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp[geo.N_cv];
  Real zeta[geo.N_cv] "Pressure loss coefficient";
equation
//   m_flow=abs(iCom.m_flow)./geo.N_tubes;
  T_mean = iCom.T;
  heat.Q_flow = alpha .* A_heat .* (heat.T - T_mean);

  for i in 1:iCom.N_cv loop
//////////////MEDIA DATA CALCULATION ////////////////////////
    lambda[i] = fluidObjectFunction_lambda(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    rho[i]=fluidObjectFunction_rho(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    eta[i]=fluidObjectFunction_eta(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    cp[i]=fluidObjectFunction_cp(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
//////////////////////////LAMINAR ALPHA /////////////////////
    velocity[i]= abs(m_flow[i])./max(MIN, rho[i]*geo.A_cross[i]) "Mean velocity";
    Re[i]=(rho[i]*velocity[i]*geo.diameter_hyd[i]/max(MIN,eta[i])) "Reynolds number";
    Pr[i] = abs(eta[i]*cp[i]/max(MIN, lambda[i])) "Prandtl number";
    Nu2[i] = if boundary == 1 or boundary == 3 then  1.615 *(Re[i]*Pr[i]*geo.diameter_hyd[i]/geo.length*geo.N_passes)^(1/3)
                                                   else if boundary ==  2 or boundary == 4 then 1.953 *(Re[i].*Pr[i]*geo.diameter_hyd[i]/geo.length*geo.N_passes)^(1/3)
                                                        else 0 "Help variable for mean Nusselt number";
    Nu3[i] = if boundary == 3 then (2 /(1 + 22 *Pr[i]))^(1/6)*(Re[i]*Pr[i]*geo.diameter_hyd[i]/geo.length*geo.N_passes)^0.5
                                                   else if boundary == 4 then  (0.924) *(Pr[i]^(1/3))*(Re[i]*geo.diameter_hyd[i]/geo.length*geo.N_passes)^(1/2)
                                                        else 0 "Help variable for mean Nusselt number";

    Nu_lam[i]=(Nu1^3 + Nu0^3 + (Nu2[i] - Nu0)^3 + Nu3[i].^3)^(1/3) "Mean Nusselt number";
    alpha_lam[i] =  Nu_lam[i]*lambda[i]/max(MIN, geo.diameter_hyd[i]);

//////////////////////////TURBULENT ALPHA ///////////////////
    zeta[i]=abs(1/max(MIN, 1.8*Modelica.Math.log10(max(abs(Re[i]),MIN)) - 1.5)^2)
    "Pressure loss coefficient";
    alpha_turb[i] = if correlation == 2 then abs(lambda[i]/geo.diameter_hyd[i])*0.023*Re[i]^0.8*Pr[i]^(1/3)
               else if correlation == 1 then abs(lambda[i]/geo.diameter_hyd[i])*(abs(zeta[i])/8)*abs(Re[i])*abs(Pr[i])/(1 + 12.7*(abs(zeta[i])/8)^0.5*(abs(Pr[i])^(2/3) - 1))*(1 + (geo.diameter_hyd[i]/geo.length*geo.N_passes)^(2/3))
               else 0;


/////////////////////////OVERALL ALPHA //////////////////////
    alpha[i] = sm(laminar, turbulent, Re[i])*alpha_lam[i]
             + sm(turbulent, laminar, Re[i])*alpha_turb[i];
    Nu[i]=alpha[i]/lambda[i]*geo.diameter_hyd[i];

  //failure status
    if noEvent(Re[i] > 1e6) then
      failureStatus[i] =  1;
    else
       if noEvent(Pr[i] < 0.6 or Pr[i] > 1e3) then
         failureStatus[i] = 1;
       else
         if noEvent(geo.diameter_hyd[i]/max(MIN, geo.length*geo.N_passes) > 1) then
            failureStatus[i] = 1;
         else
            failureStatus[i] = 0;
         end if;
       end if;
    end if;
  end for;
end NusseltPipe_L4;
