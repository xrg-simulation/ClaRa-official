within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model E_Filter_L2_Empirical "Gas || L2 || Empirical E-Filter"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.4.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
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
  extends ChemicalReactionsBaseGas(final i=1, final use_signal=false);

  //parameter Real separationRate(max = 0.99995) = 0.9995 "Separation rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real specific_powerConsumption(unit="W.h/m3") = 0.15 "Specific power consumption" annotation (Dialog(group="Fundamental Definitions"));
  parameter Units.Velocity w_m=0.15 "Migration speed of dust particles in the E-field" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Area A_el=100 "Collector area of E-Filter" annotation (Dialog(group="Geometry"));

  Units.Power powerConsumption "Power consumption";
  Units.DensityMassSpecific d_flueGas_in;
  Units.DensityMassSpecific d_flueGas_out;
  Units.MassFraction xi_dust[iCom.mediumModel.nc - 1];

  Real separationRate "Separation rate";
  Real k_eff "inverse of specific collector surface";
  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate of flue Gas entering the E-Filter";

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

  k_eff = 1e-30+V_flow/A_el;
  separationRate = 1-Modelica.Math.exp(-0.2*w_m/sqrt(k_eff^2));
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

end E_Filter_L2_Empirical;
