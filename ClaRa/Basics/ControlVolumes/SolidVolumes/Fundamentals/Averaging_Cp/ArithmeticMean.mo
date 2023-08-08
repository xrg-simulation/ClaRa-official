within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp;
model ArithmeticMean "Use arithmetic mean, i.e. (In1 + In2)/2"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.4.1                            //
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

  extends GeneralMean;
  import vle_cp = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import gas_cp = TILMedia.GasObjectFunctions.specificIsobaricHeatCapacity_phxi;
  SI.HeatCapacityMassSpecific cp_i_in[3];
  SI.HeatCapacityMassSpecific cp_i_out[3];
  SI.HeatCapacityMassSpecific cp_o_in[3];
  SI.HeatCapacityMassSpecific cp_o_out[3];
equation
if iCom.media[2] == "vle" then
  cp_i_in =  {vle_cp(iCom.p_i, iCom.h_i_in[i], iCom.xi_i, iCom.ptr_i_in[i]) for i in 1:3};
  cp_i_out =  {vle_cp(iCom.p_i, iCom.h_i_out[i], iCom.xi_i, iCom.ptr_i_out[i])  for i in 1:3};
else
  cp_i_in =  {gas_cp(iCom.p_i, iCom.h_i_in[i], iCom.xi_i, iCom.ptr_i_in[i]) for i in 1:3};
  cp_i_out =  {gas_cp(iCom.p_i, iCom.h_i_out[i], iCom.xi_i, iCom.ptr_i_out[i])  for i in 1:3};
end if;
if iCom.media[1]=="vle" then
  cp_o_in =  {vle_cp(iCom.p_o, iCom.h_o_in[i], iCom.xi_o, iCom.ptr_o_in[i]) for i in 1:3};
  cp_o_out = {vle_cp(iCom.p_o, iCom.h_o_out[i], iCom.xi_o, iCom.ptr_o_out[i]) for i in 1:3};
else
  cp_o_in =  {gas_cp(iCom.p_o, iCom.h_o_in[i], iCom.xi_o, iCom.ptr_o_in[i]) for i in 1:3};
  cp_o_out = {gas_cp(iCom.p_o, iCom.h_o_out[i], iCom.xi_o, iCom.ptr_o_out[i]) for i in 1:3};
end if;

  for i in 1:3 loop
    cp_i[i] = (cp_i_in[i] + cp_i_out[i])/2;
    cp_o[i] = (cp_o_in[i] + cp_o_out[i])/2;
  end for;
end ArithmeticMean;
