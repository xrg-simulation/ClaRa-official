within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_regenerativeAirPreheater_L4 "Gas || Convection Air Preheater Channels"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.3.0                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L4;
  //ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Special.HeatTransfer_array;
  import ClaRa.Basics.Functions.Stepsmoother;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  parameter Real CF_fouling=1 "Scaling factor accounting for the fouling of the wall";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha[iCom.N_cv] "Heat transfer coefficient";
  outer TILMedia.Gas_ph fluid[iCom.N_cv];

  Real w[iCom.N_cv] "Medium velocity";
  Real Re[iCom.N_cv] "Reynolds number";
  Real smooth[iCom.N_cv] "Smoothing factor";

equation
  if m_flow[1] >= 0 then
    T_mean[1] = (iCom.T_in[1] + fluid[1].T)/2;
  else
    T_mean[1] = (fluid[1].T + fluid[2].T)/2;
  end if;

  if m_flow[iCom.N_cv] >= 0 then
    T_mean[iCom.N_cv] = (fluid[iCom.N_cv - 1].T + fluid[iCom.N_cv].T)/2;
  else
    T_mean[iCom.N_cv] = (iCom.T_out[1] + fluid[iCom.N_cv].T)/2;
  end if;

  for i in 2:iCom.N_cv - 1 loop
    if m_flow[i] >= 0 then
      T_mean[i] = (fluid[i - 1].T + fluid[i].T)/2;
    else
      T_mean[i] = (fluid[i].T + fluid[i + 1].T)/2;
    end if;
  end for;

  for i in 1:iCom.N_cv loop
    w[i] = (abs(m_flow[i]) ./ fluid[i].d) ./ geo.A_cross[iCom.N_cv];
    Re[i] = w[i] .* geo.diameter_hyd[i] .* fluid[i].d ./ fluid[i].transp.eta;
  end for;

  smooth = Stepsmoother(
    5180,
    5220,
    Re);

  for i in 1:iCom.N_cv loop
    alpha[i] = CF_fouling*smooth[i]*(0.0061*fluid[i].transp.lambda/geo.diameter_hyd[i]*Re[i]*fluid[i].transp.Pr^0.4) + (1 - smooth[i])*(0.029*fluid[i].transp.lambda/geo.diameter_hyd[i]*Re[i]^0.8*fluid[i].transp.Pr^0.4);
  end for;
  //heat.Q_flow = alpha.*geo.A_heat_CF[heatSurfaceAlloc]./iCom.N_cv .*(heat.T - T_mean);
  heat.Q_flow = alpha .* geo.A_heat_CF[iCom.N_cv, heatSurfaceAlloc] .* (heat.T - T_mean);
  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer inside regenerative air preheaters</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>Equations according to: H. Effenberger: Dampferzeugung, chapter 9.34</li>
</ul></p>
</html>"));
end Convection_regenerativeAirPreheater_L4;
