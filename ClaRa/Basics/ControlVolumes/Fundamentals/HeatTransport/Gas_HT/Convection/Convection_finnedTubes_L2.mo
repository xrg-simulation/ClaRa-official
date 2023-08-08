within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_finnedTubes_L2 "Shell Geo || L2 || Convection Finned Tube Bank VDI WA"
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
  //Equations based on VDI Waermeatlas

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  final parameter Integer HT_type = 1;

  //Equations according to VDI-Waermeatlas/Effenberger Dampferzeugung
  parameter ClaRa.Basics.Units.Length h_f=0.04 "Fin heigth" annotation (Dialog(group="Fin geometry"));
  parameter ClaRa.Basics.Units.Length s_f=0.002 "Fin thickness" annotation (Dialog(group="Fin geometry"));
  parameter ClaRa.Basics.Units.Length t_f=0.01 "Fin spacing" annotation (Dialog(group="Fin geometry"));
  parameter String finGeometryType="Circular fins" "Fin geometry" annotation (Dialog(group="Fin geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/fins.png"), choices(choice="Circular fins" "Circular fin geometry",
                                                                                      choice="Quadratic fins" "Quadratic fin geometry"));

  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  replaceable model solidType = TILMedia.SolidTypes.TILMedia_Steel
    constrainedby TILMedia.SolidTypes.BaseSolid "Fin material"
    annotation (choicesAllMatching=true, Dialog(group="Fin material"));
public
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.Velocity w_0 "Flue gas  velocity at narrowed cross section";
  ClaRa.Basics.Units.Velocity w "Flue gas  velocity at free cross section";
  ClaRa.Basics.Units.Temperature T_f "Fin temperature";
  final parameter Real N_f=geo.N_tubes*geo.N_passes*geo.length_tubes/t_f "Number of fins";
  final parameter Real N_tubes_p=geo.N_tubes_parallel "Number of parallel tubes";
  Real Nu "Nusselt number";
  Real Re "Reynolds number";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";
  ClaRa.Basics.Units.ThermalResistance HR_nom "Nominal convective heat resistance";
  final parameter ClaRa.Basics.Units.Area A_finned=A_f*N_f + A_ts*(N_f + 1) "Finned surface (overall)";
  final parameter ClaRa.Basics.Units.Area A_tubes=geo.A_heat[2] "Tube surface (overall, as it were without fins)";

protected
  final parameter ClaRa.Basics.Units.Area A_f=(2*Modelica.Constants.pi/4*((geo.diameter_t + 2*h_f)^2 - (geo.diameter_t)^2) + Modelica.Constants.pi*(geo.diameter_t + 2*h_f)*s_f) "Surface of one fin";
  final parameter ClaRa.Basics.Units.Area A_ts=Modelica.Constants.pi*geo.diameter_t*t_f "Tube segment surface between fins";
  final parameter ClaRa.Basics.Units.Area A_narrowed=(geo.A_front) - N_tubes_p*(geo.length_tubes*geo.diameter_t + h_f*s_f*N_f/(geo.N_tubes*geo.N_passes)*2)
                                                                                                                                                           "Narrowed cross section for velocity calculation";
  Real eff_fins "Fin efficiency";
  Real X "Parameter for fin efficiency calculation";
  final parameter Real phi = if finGeometryType == "Circular fins" then ((geo.diameter_t + 2*h_f)/geo.diameter_t - 1)*(1 + 0.35*log((geo.diameter_t + 2*h_f)/geo.diameter_t)) else (phi_st - 1)*(1 + 0.35*log(phi_st)) "Parameter for fin efficiency calculation";
  final parameter Real phi_st = if finGeometryType == "Circular fins" then 0 else 1.28*(geo.diameter_t + 2*h_f)/geo.diameter_t*sqrt(1 - 0.2) "Parameter for fin efficiency calculation";
  Real f_al "Factor for aligned tubes";
  Real f_st "Factor for staggered tubes";

  ClaRa.Basics.Units.Temperature T_prop_am "Arithmetic mean for calculation of substance properties";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean medium composition";

  TILMedia.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TILMedia.Solid solid_f(T=T_f, redeclare model SolidType =
        solidType)                                                     annotation (Placement(transformation(extent={{-10,20},{10,40}}, rotation=0)));
    Real x1;
    Real x2;
equation

  assert(A_narrowed < geo.A_front,
            "************Convection_finnedTubes_L2: A_narrowed > geo.A_front, please check geometry************");

  T_prop_am = (iCom.T_out + iCom.T_in)/2;

  xi_mean = iCom.xi_bulk;

  x1 = SM(0.01,0,iCom.V_flow_in);
  x2 = SM(0,0.01,-iCom.V_flow_out);

  w_0 = (x1*iCom.V_flow_in/geo.A_front + x2*iCom.V_flow_out/geo.A_front)/max((x1)+(x2),1);
  w = w_0*geo.A_front/A_narrowed;

  Re = max(eps,properties.d*w*geo.diameter_t/properties.transp.eta);

  if geo.N_rows >= 4 then
    f_al = 1.0;
    f_st = 1.0;
  elseif geo.N_rows == 3 then
    f_al = 0.91;
    f_st = 0.95;
  elseif geo.N_rows == 2 then
    f_al = 0.91;
    f_st = 0.87;
  elseif geo.N_rows == 1 then
    f_al = 0.91;
    f_st = 0.87;
  else
    f_al = 0;
    f_st = 0;
  end if;

  if geo.staggeredAlignment == false then
    Nu = 0.22*Re^0.6*properties.transp.Pr^(1/3)*(A_finned/A_tubes)^(-0.15)*f_al;
  else
    Nu = 0.38*Re^0.6*properties.transp.Pr^(1/3)*(A_finned/A_tubes)^(-0.15)*f_st;
  end if;

  alpha = Nu*properties.transp.lambda/geo.diameter_t;

  X = phi*geo.diameter_t/2*sqrt(2*alpha/(solid_f.lambda*s_f));
  eff_fins*X = tanh(X);
  T_f = eff_fins*(heat.T - (iCom.T_in + iCom.T_out)/2) + (iCom.T_in + iCom.T_out)/2;

  heat.Q_flow = alpha*(A_ts*(N_f + 1) + eff_fins*A_f*N_f)*CF_fouling*Delta_T_mean;

//calculation of NOMINAL heat resistance
  HR_nom = -1;

//calculation of ACTUAL heat resistance
  HR=1/max(Modelica.Constants.eps,alpha*(A_ts*(N_f + 1) + eff_fins*A_f*N_f));

  annotation (DymolaStoredErrors, Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer inside finned tube banks</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned and staggered tubes supported</li>
<li>Supports circular or quadratic fins only</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Mb1-4 and H. Effenberger: Dampferzeugung, chapter 9.3.5</li>
</ul></p>
</html>"));
end Convection_finnedTubes_L2;
