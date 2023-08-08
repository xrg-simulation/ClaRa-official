within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp;
model InputOnly "Use the 1st input instead of an average"
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

  extends GeneralMean;
  import TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;

  SI.HeatCapacityMassSpecific cp_i_in[3] =  {specificIsobaricHeatCapacity_phxi(iCom.p_i, iCom.h_i_in[i], fill(0,0), iCom.ptr_i_in[i]) for i in 1:3};
  SI.HeatCapacityMassSpecific cp_o_in[3] =  {specificIsobaricHeatCapacity_phxi(iCom.p_o, iCom.h_o_in[i], fill(0,0), iCom.ptr_o_in[i]) for i in 1:3};

equation
  cp_i = cp_i_in;
  cp_o = cp_o_in;
end InputOnly;
