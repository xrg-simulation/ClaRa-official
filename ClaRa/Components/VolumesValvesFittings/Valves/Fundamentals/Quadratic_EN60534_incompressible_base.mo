within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_EN60534_incompressible_base "Quadratic|Kv definition | supercritical flow | incompressible |EN60534"

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//



  extends ClaRa.Basics.Icons.Delta_p;
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;

  parameter Real diameter_inlet=10 "Inlet fitting's diameter"
                                                             annotation(Dialog(group = "Valve Geometry",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/Valve.png"));
  parameter Real diameter_valve=10 "Valve diameter"
                                                   annotation(Dialog(group = "Valve Geometry"));
  parameter Real diameter_outlet=10 "Outlet fitting's diameter"
                                                               annotation(Dialog(group = "Valve Geometry"));


  parameter Real F_L= 0.75 "Liquid pressure recovery factor when no reducers are installed" annotation(Dialog(group = "Valve Geometry"));

  parameter Integer  paraOption=1 "Type of parametrisation" annotation(Dialog(group="Valve Characteristics"), choices(choice = 1 "Kvs_in", choice = 2 "Nominal Point", choice=3 "Zeta"));
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "Effective apperture as function of valve position in p.u." annotation(Dialog(group="Valve Characteristics"));
  parameter Real Kvs_in(unit="m3/h") = 1 "Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))"
                                                                                                                                      annotation(Dialog(group="Valve Characteristics", enable=(paraOption==1)));
  parameter SI.Pressure Delta_p_eps= 100 "Small pressure difference for linearisation around zeor flow" annotation(Dialog(tab="Expert Settings"));

  parameter SI.MassFlowRate m_flow_nom= Kvs_in/1000/3600 "Nominal mass flowrate at full opening" annotation(Dialog(group="Valve Characteristics")); //If paraOption Nominal Point is chosen this value will define the valve characteristic. Otherwise only for homotopy-based initialisation.
  parameter SI.Pressure Delta_p_nom = 1e5 "Nominal pressure difference for Kv definition"
                                                                                         annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));
  parameter SI.DensityMassSpecific rho_in_nom= 1000 "Nominal density for Kv definition"
                                                                                       annotation(Dialog(group="Valve Characteristics", enable=(paraOption==2)));

  parameter Real zeta= 100 "Pressure Loss coefficient"
                                                      annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));
  parameter SI.Area A_cross= 1 "Valve inlet cross section"
                                                          annotation(Dialog(group="Valve Characteristics", enable=(paraOption==3)));


  Real aperture_ "Effective apperture";
  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";
  final parameter Real Kvs(unit="m3/h")=if paraOption==1 then Kvs_in else if paraOption==2 then 3600 * m_flow_nom/rho_in_nom * sqrt(rho_in_nom/1000*1e5/Delta_p_nom) else A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "Actual value of Kvs_in depending on parametrisation option";
  Real Kv(unit="m3/h") "Flow Coefficient (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";
  SI.Pressure Delta_p_choke "Pressure difference at which choking occurs, always positive i.e. independent of flow direction";

  Boolean normIsValid=Kvs/0.865/diameter_valve^2<0.047 "Validity of DIN";
  Modelica.Blocks.Tables.CombiTable1Dv ValveCharacteristics(table=CL_valve, columns={2});
  Real F_P = 1/sqrt(1+(((1-diameter_valve^4/diameter_inlet^4) - (1-diameter_valve^4/diameter_outlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2 + (1-(diameter_valve/diameter_outlet)^2)^2)*Kv^2/diameter_valve^4)/K1) "Pipe geometry correction factor";

protected
  constant Real K1= 0.0016 "Coefficient for calculation of F_P";
  SI.Pressure p_in = max(iCom.p_in, iCom.p_out);
  Real F_LP = F_L / sqrt(1+(F_L^2*((1-diameter_valve^4/diameter_inlet^4) + 0.5*(1-(diameter_valve/diameter_inlet)^2)^2)/K1*(Kv^2/diameter_valve^4)));

equation
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;

 //____________ Pressure drop in design flow direction_______________
  Delta_p_choke =(F_LP/F_P)^2*(p_in - (0.96-0.28*sqrt(iCom.p_vap_in/iCom.p_crit))*iCom.p_vap_in);
//____________Hydraulics____________________________________________
  Kv = aperture_ * Kvs;

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Quadratic_EN60534_incompressible_base;
