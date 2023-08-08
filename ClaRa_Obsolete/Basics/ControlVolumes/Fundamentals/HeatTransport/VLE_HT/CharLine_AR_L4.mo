within ClaRa_Obsolete.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model CharLine_AR_L4 "Obsolete HT Model || Heat transfer coefficient defined by a characteristic line and a nominal value"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  import Modelica.Constants.eps;
  outer TILMedia.VLEFluid_ph fluidInlet;
  outer TILMedia.VLEFluid_ph fluidOutlet;
  outer TILMedia.VLEFluid_ph fluid[iCom.N_cv];
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L4;
  extends Icons.Obsolete_v1_1;
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));
  parameter Real PL_kc[:, 2]={{0,0.2},{0.5,0.6},{0.7,0.72},{1,1}} "Correction factor for heat transfer in part load" annotation (Dialog(group="Heat Transfer"));

  Modelica.Units.SI.CoefficientOfHeatTransfer alpha[iCom.N_cv] annotation (HideResult=false);

  ClaRa.Basics.Units.TemperatureDifference Delta_T_wi[iCom.N_cv] "Temperature difference between wall and fluid inlet temperature";
  ClaRa.Basics.Units.TemperatureDifference Delta_T_wo[iCom.N_cv] "Temperature difference between wall and fluid outlet temperature";
  ClaRa.Basics.Units.TemperatureDifference Delta_T_mean[iCom.N_cv];

  ClaRa.Basics.Units.TemperatureDifference Delta_T_u[iCom.N_cv];
  ClaRa.Basics.Units.TemperatureDifference Delta_T_l[iCom.N_cv];

protected
  Real alpha_corr_u[iCom.N_cv];
  Integer tableID;
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "smoothness of table interpolation" annotation (Dialog(group="table data interpretation"));

  function tableInit "Initialize 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
    input String tableName;
    input String fileName;
    input Real table[:, :];
    input Modelica.Blocks.Types.Smoothness smoothness;
    output Integer tableID;
  external"C" tableID = ModelicaTables_CombiTable1D_init(
        tableName,
        fileName,
        table,
        size(table, 1),
        size(table, 2),
        smoothness);
    annotation (Library="ModelicaExternalC");
  end tableInit;

  function tableIpo "Interpolate 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
    input Integer tableID;
    input Integer icol;
    input Real u;
    output Real value;
  external"C" value = ModelicaTables_CombiTable1D_interpolate(
        tableID,
        icol,
        u);
    annotation (Library="ModelicaExternalC");
  end tableIpo;

equation
  if m_flow[1] > 0 then
    for i in 2:iCom.N_cv loop
      Delta_T_wi[i] = heat[i].T - fluid[i - 1].T;
      Delta_T_wo[i] = heat[i].T - fluid[i].T;

      Delta_T_mean[i] = noEvent(if abs(Delta_T_wo[i]) <= 1e-6 or abs(Delta_T_wi[i]) <= 1e-6 then 0 elseif (heat[i].T < fluid[i].T and heat[i].T > fluid[i - 1].T) or (heat[i].T > fluid[i].T and heat[i].T < fluid[i - 1].T) then 0 elseif abs(Delta_T_wo[i] - Delta_T_wi[i]) <= eps then Delta_T_wi[i] else (Delta_T_u[i] - Delta_T_l[i])/log(Delta_T_u[i]/Delta_T_l[i]));

    end for;

    Delta_T_wi[1] = heat[1].T - fluidInlet.T;
    Delta_T_wo[1] = heat[1].T - fluid[1].T;

    Delta_T_mean[1] = noEvent(if abs(Delta_T_wo[1]) <= 1e-6 or abs(Delta_T_wi[1]) <= 1e-6 then 0 elseif (heat[1].T < fluid[1].T and heat[1].T > fluidInlet.T) or (heat[1].T > fluid[1].T and heat[1].T < fluidInlet.T) then 0 elseif abs(Delta_T_wo[1] - Delta_T_wi[1]) <= eps then Delta_T_wi[1] else (Delta_T_u[1] - Delta_T_l[1])/log(Delta_T_u[1]/Delta_T_l[1]));

  else

    for i in 1:iCom.N_cv - 1 loop
      Delta_T_wi[i] = heat[i].T - fluid[i + 1].T;
      Delta_T_wo[i] = heat[i].T - fluid[i].T;

      Delta_T_mean[i] = noEvent(if abs(Delta_T_wo[i]) <= 1e-6 or abs(Delta_T_wi[i]) <= 1e-6 then 0 elseif (heat[i].T < fluid[i].T and heat[i].T > fluid[i + 1].T) or (heat[i].T > fluid[i].T and heat[i].T < fluid[i + 1].T) then 0 elseif abs(Delta_T_wo[i] - Delta_T_wi[i]) <= eps then Delta_T_wi[i] else (Delta_T_u[i] - Delta_T_l[i])/log(Delta_T_u[i]/Delta_T_l[i]));

    end for;

    Delta_T_wi[iCom.N_cv] = heat[iCom.N_cv].T - fluidOutlet.T;
    Delta_T_wo[iCom.N_cv] = heat[iCom.N_cv].T - fluid[iCom.N_cv].T;

    Delta_T_mean[iCom.N_cv] = noEvent(if abs(Delta_T_wo[iCom.N_cv]) <= 1e-6 or abs(Delta_T_wi[iCom.N_cv]) <= 1e-6 then 0 elseif (heat[iCom.N_cv].T < fluid[iCom.N_cv].T and heat[iCom.N_cv].T > fluidOutlet.T) or (heat[iCom.N_cv].T > fluid[iCom.N_cv].T and heat[iCom.N_cv].T < fluidOutlet.T) then 0 elseif abs(Delta_T_wo[iCom.N_cv] - Delta_T_wi[iCom.N_cv]) <= eps then Delta_T_wi[iCom.N_cv] else (Delta_T_u[iCom.N_cv] - Delta_T_l[iCom.N_cv])/log(Delta_T_u[iCom.N_cv]/Delta_T_l[iCom.N_cv]));

  end if;

  for i in 1:iCom.N_cv loop
    Delta_T_u[i] = max(Delta_T_wi[i], Delta_T_wo[i]);
    Delta_T_l[i] = min(Delta_T_wi[i], Delta_T_wo[i]);

  end for;

  T_mean = fluid.T;
  heat.Q_flow = alpha .* A_heat .* Delta_T_mean;

  //heat.Q_flow = alpha.*A_heat.*(heat.T-T_mean);

  for i in 1:iCom.N_cv loop
    alpha_corr_u[i] = noEvent(max(1e-3, abs(m_flow[i]))/iCom.m_flow_nom);
    alpha[i] = tableIpo(
      tableID,
      2,
      alpha_corr_u[i])*alpha_nom;
  end for;

  when initial() then
    tableID = tableInit(
      "NoName",
      "NoName",
      PL_kc,
      smoothness);
  end when;

  annotation (Diagram(graphics));
end CharLine_AR_L4;
