within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Constant_L2 "All Geo || L2 || HTC || Constant"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
  final parameter Integer HT_type = 0;

  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.HeatTransferGas;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectiveHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.RadiantHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Special.SpecialHeatTransfer;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
   import SM = ClaRa.Basics.Functions.Stepsmoother;
   import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

   outer ClaRa.Basics.Records.IComBase_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));
  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom=1/(alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]) "Nominal convective heat resistance";

  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  input Real CF_fouling=1 "Scaling factor accounting for the fouling of the wall" annotation (Dialog(group="Heat Transfer"));

   parameter String temperatureDifference="Logarithmic mean - smoothed" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
       choice = "Arithmetic mean",
       choice = "Logarithmic mean - smoothed",
       choice = "Inlet",
       choice = "Outlet",
       choice = "Bulk"));

  Units.TemperatureDifference Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.TemperatureDifference Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.TemperatureDifference Delta_T_mean "Mean temperature difference used for heat transfer calculation";

  Units.TemperatureDifference Delta_T_U "Upper temperature difference";
  Units.TemperatureDifference Delta_T_L "Lower temperature difference";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient used for heat transfer calculation";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";

equation
   Delta_T_wi = heat.T - iCom.T_in;
   Delta_T_wo = heat.T - iCom.T_out;
   Delta_T_U = ClaRa.Basics.Functions.maxAbs(Delta_T_wi, Delta_T_wo, 0.1);
   Delta_T_L = ClaRa.Basics.Functions.minAbs(Delta_T_wi, Delta_T_wo, 0.1);

   if temperatureDifference == "Logarithmic mean" then
     //The following equation is only supported due to an backward compatibility issue - avoid its usage
     Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/eps) <= 1 or floor(abs(Delta_T_wi)*1/eps) <= 1 then 0 elseif (heat.T < iCom.T_out and heat.T > iCom.T_in) or (heat.T > iCom.T_out and heat.T < iCom.T_in) then 0 elseif floor(abs(Delta_T_wo - Delta_T_wi)*1/eps) < 1 then Delta_T_wi else (Delta_T_U - Delta_T_L)/log(Delta_T_U/Delta_T_L));
   elseif temperatureDifference == "Logarithmic mean - smoothed" then
     Delta_T_mean = SM(0.1,eps, abs(Delta_T_L))*SM(0.01,eps, Delta_T_U*Delta_T_L) * SZT((Delta_T_U - Delta_T_L)/log(abs(Delta_T_U)/(abs(Delta_T_L)+1e-9)), Delta_T_wi, (abs(Delta_T_U)-abs(Delta_T_L))-0.01, 0.001);
   elseif temperatureDifference == "Arithmetic mean" then
     Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
   elseif temperatureDifference == "Bulk" then
     Delta_T_mean = heat.T - iCom.T_bulk;
   elseif temperatureDifference == "Inlet" then
     Delta_T_mean = heat.T - iCom.T_in;
   else
     Delta_T_mean = heat.T - iCom.T_out;
   end if;

  alpha = alpha_nom*CF_fouling;

  HR = 1/max(Modelica.Constants.eps,alpha*geo.A_heat_CF[heatSurfaceAlloc]);

  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

end Constant_L2;
