within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model IdeallyStirred "Volume is ideally stirred"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases(final level_rel_start=0, final modelType="IdeallyStirred");
  extends ClaRa.Basics.Icons.IdealMixing;
  parameter String position_Delta_p_geo="inlet" "Position of geostatic pressure difference" annotation (choices(choice="mid", choice="inlet"), Dialog(group="Expert Settings"));
  parameter Boolean provideDensityDerivative=true "True if density derivative shall be provided" annotation (Dialog(group="Expert Settings"));
protected
  ClaRa.Basics.Units.DensityMassSpecific rho "Density used for geostatic pressure loss calculation";
equation
  //_________________________Calculation of the outflowing enthalpy _________________
  h_inflow = iCom.h_bulk;
  h_outflow = iCom.h_bulk;
  //__________________Calculation of the geostatic pressure differences_______________
  if provideDensityDerivative then
    rho = TILMedia.Internals.VLEFluidObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
  else
    rho = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
  end if;

  if position_Delta_p_geo == "mid" then
    Delta_p_geo_in = (geo.z_out[1] - geo.z_in[1])/2*Modelica.Constants.g_n*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
    Delta_p_geo_out = -Delta_p_geo_in;
  elseif position_Delta_p_geo == "inlet" then
    Delta_p_geo_in = (geo.z_out[1] - geo.z_in[1])*Modelica.Constants.g_n*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
    Delta_p_geo_out = 0;
  else
    Delta_p_geo_in = -1;
    Delta_p_geo_out = -1;
    assert(false, "Unknown option for positioning of geostatic pressure difference in phaseBorder model of type 'IdeallySeparated'!");
  end if;
  level_abs = 0;
  level_rel = 0;
  annotation (Icon(graphics), Diagram(graphics));
end IdeallyStirred;
