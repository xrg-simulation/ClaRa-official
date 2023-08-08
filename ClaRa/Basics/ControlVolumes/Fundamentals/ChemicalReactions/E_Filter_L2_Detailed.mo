within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model E_Filter_L2_Detailed "Gas || L2 || Detailed E-Filter"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.3.1                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_FilterBase;
  extends ChemicalReactionsBaseGas(final i=1, final use_signal=true);

  //parameter Real separationRate(max = 0.99995) = 0.9995 "Separation rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real epsilon_r = 10 "Dielectric number of flueGas";
  parameter Real specific_powerConsumption(unit="W.h/m3") = 0.15 "Specific power consumption" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Area A_filter = 100 "Collector area of E-Filter" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length d_plate = 0.2 "Distance  Plate-to-Plate or Plate-to-Wire, repectivaly"
                                                                                            annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_particle = 50e-6 "Average diameter of ash particles"
                                                                                                   annotation(Dialog(group="Geometry"));
  final parameter Real A1 = 1.257 "Auxiliary Area"
                                                  annotation(Dialog(group="Geometry"));
  final parameter Real A2 = 0.4 "Auxiliary Area" annotation(Dialog(group="Geometry"));
  final parameter Real A3 = 0.55 "Auxiliary Area"
                                                 annotation(Dialog(group="Geometry"));


  SI.Velocity w_m "Migration speed of dust particles in the E-field";
  SI.Length lambda "Mean free path of particles";
  Modelica.SIunits.ElectricFieldStrength E_applied "E-Field in Filter estimated as E = U/d with U being the applied potential and d the distance between elektrodes, refer to Riehle 1997";

  ClaRa.Basics.Units.DynamicViscosity mu_flueGas "Dynamic viscosity of flueGas in E-Filter";
  Real Cu "Cunningham slip correction factor Cu = 1 + 2lambda/d *(A1 +A2exp[-A3*diameter_particle/lambda]])";

  Modelica.SIunits.ElectricCharge Q_sat "Saturation charge of particles";

  SI.Power powerConsumption "Power consumption";
  SI.DensityMassSpecific d_flueGas_in;
  SI.DensityMassSpecific d_flueGas_out;
  SI.MassFraction xi_dust[iCom.mediumModel.nc-1];

  Real separationRate "Separation rate";
  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate of flue Gas entering the E-Filter";

 outer Real U_applied;

equation


  Q_flow_reaction = 0;

  //No auxillary step
  xi_aux=iCom.xi_in;
  m_flow_aux=iCom.m_flow_in;
  h_aux=TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  xi_dust = {if i==1  then 0.99999 else if i==5 then 0.00001 else 0 for i in 1:iCom.mediumModel.nc-1}; //Dust removed is treated as ash

  h_reaction[1] = TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_bulk,iCom.T_bulk,xi_dust,iCom.fluidPointer_bulk);
  d_flueGas_in = TILMedia.GasObjectFunctions.density_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);
  d_flueGas_out = TILMedia.GasObjectFunctions.density_pTxi(iCom.p_out,iCom.T_out,iCom.xi_out,iCom.fluidPointer_out);

  E_applied = U_applied/d_plate;

  // calculation of the migration velocity refering to Riehle "Basic and theoretical operation of ESPs" (1997)
  w_m = Q_sat*E_applied*Cu/(3.0*Modelica.Constants.pi*mu_flueGas*diameter_particle);
  // with
  Q_sat = ((1.0+2.0*lambda/diameter_particle)^2 + (2.0/(1.0+2.0*lambda/diameter_particle))*(epsilon_r-1.0)/(epsilon_r+2.0)) * Modelica.Constants.pi*Modelica.Constants.epsilon_0*diameter_particle^2*E_applied;
  //and
  Cu = 1 + 2.0*lambda/diameter_particle*(A1 + A2*Modelica.Math.exp(-A3*diameter_particle/lambda));
  //with lambda the mean free path of molecules/paticles in the flueGas (check, which diameter is physical plausible)
  lambda = 1.0/(4.0*Modelica.Constants.pi*sqrt(2.0)*diameter_particle^2*Modelica.Constants.N_A/(Modelica.Constants.R*iCom.T_in/iCom.p_in));

  mu_flueGas  = TILMedia.GasObjectFunctions.dynamicViscosity_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  separationRate =  1- Modelica.Math.exp(-w_m*A_filter/V_flow);
  powerConsumption = V_flow * specific_powerConsumption*3600.;

  if iCom.m_flow_in > 0 and iCom.m_flow_out <=0 then
    V_flow = iCom.V_flow_in;
    m_flow_reaction[1] = separationRate *(-iCom.xi_in[1]*iCom.m_flow_in);
  elseif  iCom.m_flow_in > 0 and iCom.m_flow_in > 0 then
    V_flow = iCom.V_flow_in + iCom.V_flow_out;
    m_flow_reaction[1] = separationRate * (-iCom.xi_out[1]*iCom.m_flow_out-iCom.xi_in[1]*iCom.m_flow_in);
  elseif iCom.m_flow_in <= 0 and iCom.m_flow_out <= 0 then
    V_flow = 1e-20;
    m_flow_reaction[1] = 1e-20;
  else
    V_flow = iCom.V_flow_out;
    m_flow_reaction[1] = separationRate *(-iCom.xi_out[1]*iCom.m_flow_out);
   end if;

  if use_dynamicMassbalance then
     der(xi) =
      1/mass * (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi) + m_flow_reaction[1]*(xi_dust-xi));
  else
     zeros(iCom.mediumModel.nc-1) =
       (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi) + m_flow_reaction[1]*(xi_dust-xi));
  end if;

end E_Filter_L2_Detailed;
