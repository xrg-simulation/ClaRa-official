within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
partial model HeatTransfer_L2
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectiveHeatTransfer;
  extends ClaRa.Basics.Icons.Alpha;

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

  outer parameter Boolean useHomotopy;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;

  ClaRa.Basics.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter String temperatureDifference="Logarithmic mean - smoothed" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
      choice="Arithmetic mean",
      choice="Logarithmic mean",
      choice="Logarithmic mean - smoothed",
      choice="Inlet",
      choice="Outlet",
      choice = "Bulk"));
  input Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall" annotation (Dialog);

  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean "Mean temperature";
  Units.Temperature Delta_T_U "Upper temperature difference";
  Units.Temperature Delta_T_L "Lower temperature difference";




equation
  Delta_T_wi = heat.T - iCom.T_in;
  Delta_T_wo = heat.T - iCom.T_out;
  Delta_T_U = ClaRa.Basics.Functions.maxAbs(Delta_T_wi, Delta_T_wo);
  Delta_T_L = ClaRa.Basics.Functions.minAbs(Delta_T_wi, Delta_T_wo);

  if temperatureDifference == "Logarithmic mean" then
    //The following equation is only supported due to an backward compatibility issue - avoid its usage
    Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/eps) <= 1 or floor(abs(Delta_T_wi)*1/eps) <= 1 then 0 elseif (heat.T < iCom.T_out and heat.T > iCom.T_in) or (heat.T > iCom.T_out and heat.T < iCom.T_in) then 0 elseif floor(abs(Delta_T_wo - Delta_T_wi)*1/eps) < 1 then Delta_T_wi else (Delta_T_U - Delta_T_L)/log(Delta_T_U/Delta_T_L));
  elseif temperatureDifference == "Logarithmic mean - smoothed" then
    Delta_T_mean = if useHomotopy then homotopy(SM(0.1,eps, abs(Delta_T_L))*SM(0.01,eps, Delta_T_U*Delta_T_L) * SZT((Delta_T_U - Delta_T_L)/log(abs(Delta_T_U)/(abs(Delta_T_L)+1e-9)), Delta_T_wi, (abs(Delta_T_U)-abs(Delta_T_L))-0.01, 0.001), heat.T - iCom.T_out) else     SM(0.1,eps, abs(Delta_T_L))*SM(0.01,eps, Delta_T_U*Delta_T_L) * SZT((Delta_T_U - Delta_T_L)/log(abs(Delta_T_U)/(abs(Delta_T_L)+1e-9)), Delta_T_wi, (abs(Delta_T_U)-abs(Delta_T_L))-0.01, 0.001);
  elseif temperatureDifference == "Arithmetic mean" then
    Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
  elseif temperatureDifference == "Inlet" then
    Delta_T_mean = heat.T - iCom.T_in;
  elseif temperatureDifference == "Outlet" then
    Delta_T_mean = heat.T - iCom.T_out;
  elseif temperatureDifference == "Bulk" then
    Delta_T_mean = heat.T - iCom.T_bulk;
  else
    Delta_T_mean = -1;
    assert(true, "Unknown temperature difference option in HT model");
  end if;


  annotation (
    Icon(graphics),
    Diagram(graphics),
    Documentation(info="<html>
<p><b>Model description: </b>Base class for heat transfer correlations</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
</html>"));
end HeatTransfer_L2;
