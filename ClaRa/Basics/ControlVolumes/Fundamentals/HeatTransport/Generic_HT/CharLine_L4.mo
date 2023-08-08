within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model CharLine_L4 "Medium independent || Characteristic Line"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.0                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4;

  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));

  parameter Real PL_alpha[:, 2]={{0,0.2},{0.5,0.6},{0.7,0.72},{1,1}} "Correction factor for heat transfer in part load" annotation (Dialog(group="Heat Transfer"));

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv] annotation (HideResult=false);


  parameter String temperatureDifference="Outlet" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
      choice="Logarithmic mean",
      choice="Outlet"));

  Units.Temperature Delta_T_wi[iCom.N_cv] "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo[iCom.N_cv] "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean[iCom.N_cv] "Mean temperature difference used for heat transfer calculation";

  Units.Temperature Delta_T_u[iCom.N_cv] "Upper temperature difference";
  Units.Temperature Delta_T_l[iCom.N_cv] "Lower temperature difference";
protected
  Real alpha_corr_u[iCom.N_cv];
  ClaRa.Components.Utilities.Blocks.ParameterizableTable1D table_block(table=PL_alpha, columns=fill(2,iCom.N_cv));
equation
    if temperatureDifference == "Logarithmic mean" then
      if m_flow[1] > 0 then
      for i in 2:iCom.N_cv loop
        Delta_T_wi[i] = heat[i].T - iCom.T[i-1];
        Delta_T_wo[i] = heat[i].T - iCom.T[i];

        Delta_T_mean[i] = noEvent(if abs(Delta_T_wo[i]) <= 1e-6 or abs(Delta_T_wi[i]) <= 1e-6 then 0 elseif (heat[i].T < iCom.T[i] and heat[i].T > iCom.T[i-1]) or (heat[i].T > iCom.T[i] and heat[i].T < iCom.T[i-1]) then 0 elseif abs(Delta_T_wo[i] - Delta_T_wi[i]) <= eps then Delta_T_wi[i] else (Delta_T_u[i] - Delta_T_l[i])/log(Delta_T_u[i]/Delta_T_l[i]));

      end for;

      Delta_T_wi[1] = heat[1].T - iCom.T_in[1];
      Delta_T_wo[1] = heat[1].T - iCom.T[1];

      Delta_T_mean[1] = noEvent(if abs(Delta_T_wo[1]) <= 1e-6 or abs(Delta_T_wi[1]) <= 1e-6 then 0 elseif (heat[1].T < iCom.T[1] and heat[1].T > iCom.T_in[1]) or (heat[1].T > iCom.T[1] and heat[1].T < iCom.T_in[1]) then 0 elseif abs(Delta_T_wo[1] - Delta_T_wi[1]) <= eps then Delta_T_wi[1] else (Delta_T_u[1] - Delta_T_l[1])/log(Delta_T_u[1]/Delta_T_l[1]));

      else

        for i in 1:iCom.N_cv - 1 loop
          Delta_T_wi[i] = heat[i].T - iCom.T[i+1];
          Delta_T_wo[i] = heat[i].T - iCom.T[i];

          Delta_T_mean[i] = noEvent(if abs(Delta_T_wo[i]) <= 1e-6 or abs(Delta_T_wi[i]) <= 1e-6 then 0 elseif (heat[i].T < iCom.T[i] and heat[i].T > iCom.T[i+1]) or (heat[i].T > iCom.T[i] and heat[i].T < iCom.T[i+1]) then 0 elseif abs(Delta_T_wo[i] - Delta_T_wi[i]) <= eps then Delta_T_wi[i] else (Delta_T_u[i] - Delta_T_l[i])/log(Delta_T_u[i]/Delta_T_l[i]));

        end for;

        Delta_T_wi[iCom.N_cv] = heat[iCom.N_cv].T - iCom.T_out[1];
        Delta_T_wo[iCom.N_cv] = heat[iCom.N_cv].T - iCom.T[iCom.N_cv];

        Delta_T_mean[iCom.N_cv] = noEvent(if abs(Delta_T_wo[iCom.N_cv]) <= 1e-6 or abs(Delta_T_wi[iCom.N_cv]) <= 1e-6 then 0 elseif (heat[iCom.N_cv].T < iCom.T[iCom.N_cv] and heat[iCom.N_cv].T > iCom.T_out[1]) or (heat[iCom.N_cv].T > iCom.T[iCom.N_cv] and heat[iCom.N_cv].T < iCom.T_out[1]) then 0 elseif abs(Delta_T_wo[iCom.N_cv] - Delta_T_wi[iCom.N_cv]) <= eps then Delta_T_wi[iCom.N_cv] else (Delta_T_u[iCom.N_cv] - Delta_T_l[iCom.N_cv])/log(Delta_T_u[iCom.N_cv]/Delta_T_l[iCom.N_cv]));

      end if;

    for i in 1:iCom.N_cv loop
      Delta_T_u[i] = max(Delta_T_wi[i], Delta_T_wo[i]);
      Delta_T_l[i] = min(Delta_T_wi[i], Delta_T_wo[i]);

    end for;
    elseif temperatureDifference == "Outlet" then
      for i in 1:iCom.N_cv loop
      Delta_T_mean[i]=(heat[i].T - T_mean[i]);
      Delta_T_wi[i]=(heat[i].T - T_mean[i]);
      Delta_T_wo[i]=(heat[i].T - T_mean[i]);
      Delta_T_u[i]=(heat[i].T - T_mean[i]);
      Delta_T_l[i]=(heat[i].T - T_mean[i]);
      end for;
    else
      for i in 1:iCom.N_cv loop
      Delta_T_mean[i]=-1;
      end for;
      assert(true, "Unknown temperature difference option in HT model");
    end if;

  T_mean = iCom.T;

  heat.Q_flow = alpha .* A_heat .* Delta_T_mean;

  for i in 1:iCom.N_cv loop
    alpha_corr_u[i] = noEvent(max(1e-3, abs(m_flow[i]))/iCom.m_flow_nom);
    table_block.u[i] = alpha_corr_u[i];
    alpha[i] = table_block.y[i]*alpha_nom;
  end for;

  annotation (Diagram(graphics));
end CharLine_L4;
