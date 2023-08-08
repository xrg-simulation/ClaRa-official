within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
partial model HeatTransfer_L3 "L3 || HT-BaseClass"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L3;
  extends ClaRa.Basics.Icons.Alpha;
  outer ClaRa.Basics.Records.IComBase_L3 iCom;

  outer parameter Boolean useHomotopy;

  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter String temperatureDifference="Zonal temperatures" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(choice="Zonal tempartures"));

  //   SI.Temperature Delta_T_wi
  //     "Temperature difference between wall and fluid inlet temperature";
  //   SI.Temperature Delta_T_wo
  //     "Temperature difference between wall and fluid outlet temperature";

  SI.Temperature Delta_T_mean[iCom.N_cv] "Mean temperature difference between wall and fluid";

  //   SI.Temperature Delta_T_U;
  //   SI.Temperature Delta_T_L;
  //   //constant Real eps=1e-4;
  //   //SI.Temperature T_mean;

equation
  //   Delta_T_wi = heat[1].T-iCom.T_in;
  //   Delta_T_wo = heat[iCom.N_cv].T-iCom.T_out;
  //   Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  //   Delta_T_L= min(Delta_T_wi,Delta_T_wo);

  //    DT_mean= noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0
  //     elseif
  //           (DT_wo<-eps and DT_wi>eps) or (DT_wo>eps and DT_wi<-eps) then 0 elseif  floor(abs(DT_wo-DT_wi)*1/eps)<1 then DT_wi
  //                          else (DTU-DTL)/log(DTU/DTL));
  //   DT_mean= (if abs(DT_wo)<=1e-6 or abs(DT_wi)<=1e-6 then 0
  //    elseif
  //          (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  abs(DT_wo-DT_wi)<1e-6 then DT_wi
  //                         else (DTU-DTL)/log(DTU/DTL));
  //

  //    T_mean= if useHomotopy then homotopy(((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3))), iCom.T)
  //                           else          ((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3)));

  if temperatureDifference == "Zonal temperatures" then
    for i in 1:iCom.N_cv loop
      Delta_T_mean[i] = heat[i].T - iCom.T[i];
    end for;
  else
    Delta_T_mean = fill(0, iCom.N_cv);
    assert(false, "unknown option for temperature difference");
  end if;

  annotation (Icon(graphics), Diagram(graphics));
end HeatTransfer_L3;
