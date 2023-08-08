within ClaRa.Components.Furnace.FlameRoom;
model FlameRoomWithTubeBundle_L2_Static "Model for a combustion chamber section with inner tube bundle heating surfaces"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.1                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2023, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase(redeclare replaceable model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes);

extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase_additional_HPs(redeclare replaceable model HeatTransfer_CarrierTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_finnedTubes_L2);
extends ClaRa.Basics.Icons.FlameRoomTubeBundle;

    //## S U M M A R Y   D E F I N I T I O N ###################################################################
  model Outline
    //  parameter Boolean showExpertSummary annotation(Dialog(hide));
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume "Volume";
    input ClaRa.Basics.Units.Area A_cross "Free cross sectional area";
    input ClaRa.Basics.Units.Area A_wall "Wall area";
    input ClaRa.Basics.Units.Length height "Height of volume";
    input ClaRa.Basics.Units.Mass m "Mass inside volume";
    input ClaRa.Basics.Units.MassFlowRate m_flow_fuel_burned "Burned fuel mass flow rate";
    input ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_burned "Burned oxygen mass flow rate";
    input ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_req "Required O2 flow rate for stochiometric combustion";
    input ClaRa.Basics.Units.MassFlowRate m_flow_air_req "Required air flow rate for stochiometric combustion";
    input Real lambdaComb "Excess air";
    input Real NOx_fraction "NOx fraction at outlet";
    input Real CO_fraction "CO fraction at outlet";
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value";
    input ClaRa.Basics.Units.HeatFlowRate Q_combustion "Combustion Heat";
    input ClaRa.Basics.Units.Velocity w_migration "Particle migration speed";
    input ClaRa.Basics.Units.Time t_dwell_flueGas "Flue gas dwelltime";
    input ClaRa.Basics.Units.Time burning_time "Burning time";
    input Real unburntFraction "Fuel diffusity";
    input ClaRa.Basics.Units.Temperature T_out "Outlet temperature";
    input ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Flue gas enthalpy at outlet";
  end Outline;

  model Fuel
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.HeatCapacityMassSpecific cp "Specific heat capacity" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value" annotation (Dialog);

  end Fuel;

  model Slag
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  end Slag;

  model Flow
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeGas flueGas;
    Fuel fuel;
    Slag slag;
  end Flow;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    Flow inlet;
    Flow outlet;
  end Summary;

//## P A R A M E T E R S #######################################################################################
inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGas_out_del "Gas outlet specific enthalpy - delayed";

inner TILMedia.Gas_ph        flueGasOutlet(p(start = p_start_flueGas_out)=outlet.flueGas.p,xi=xi_flueGas,
      gasType=flueGas, h=h_flueGas_out_del)
      annotation (Placement(transformation(extent={{-130,74},{-110,94}})));

//## V A R I A B L E   P A R T##################################################################################
//___________________/ iCom record \\__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=inlet.flueGas.p,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=inStream(inlet.flueGas.T_outflow),
    m_flow_in=inlet.flueGas.m_flow,
    V_flow_in=V_flow_flueGas_in,
    xi_in=inStream(inlet.flueGas.xi_outflow),
    p_out=outlet.flueGas.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.flueGas.m_flow,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas,
    xi_nom=flueGas.xi_default,
    xi_bulk=xi_flueGas,
    h_bulk=h_flueGas_out,
    mass=mass) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

//___________________/ Summary \\__________________
  Summary summary(
    outline(
      volume=geo.volume,
      A_cross=geo.A_front,
      A_wall=if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then 2*(geo.width + geo.length)*geo.height else 2*(geo.width + geo.height)*geo.length,
      height=geo.height,
      m=mass,
      m_flow_fuel_burned=m_flow_fuel_burned,
      m_flow_oxygen_burned=m_flow_oxygen_burned,
      m_flow_oxygen_req=m_flow_oxygen_req,
      m_flow_air_req=m_flow_air_req,
      lambdaComb=lambdaComb,
      NOx_fraction=reactionZone.xi_NOx,
      CO_fraction=reactionZone.xi_CO,
      LHV=LHV,
      Q_combustion=m_flow_fuel_burned*LHV,
      w_migration=particleMigration.w,
      t_dwell_flueGas=t_dwell_flueGas,
      burning_time=burning_time.t,
      unburntFraction=unburntFraction,
      T_out=flueGasOutlet.T,
      h_out=flueGasOutlet.h),
    inlet(
      flueGas(mediumModel=flueGas,
        m_flow=inlet.flueGas.m_flow,
        T=noEvent(actualStream(inlet.flueGas.T_outflow)),
        p=inlet.flueGas.p,
        h=flueGasInlet.h,
        xi=noEvent(actualStream(inlet.flueGas.xi_outflow)),
        H_flow=flueGasInlet.h*inlet.flueGas.m_flow),
      fuel(
        m_flow=inlet.fuel.m_flow,
        T=noEvent(actualStream(inlet.fuel.T_outflow)),
        p=inlet.fuel.p,
        cp=fuelInlet.cp,
        LHV=fuelInlet.LHV),
      slag(
        m_flow=inlet.slag.m_flow,
        T=noEvent(actualStream(inlet.slag.T_outflow)),
        p=inlet.slag.p)),
    outlet(
      flueGas(mediumModel=flueGas,
        m_flow=-outlet.flueGas.m_flow,
        T=noEvent(actualStream(outlet.flueGas.T_outflow)),
        p=outlet.flueGas.p,
        h=h_flueGas_out,
        xi=noEvent(actualStream(outlet.flueGas.xi_outflow)),
        H_flow=-h_flueGas_out*outlet.flueGas.m_flow),
      fuel(
        m_flow=-outlet.fuel.m_flow,
        T=noEvent(actualStream(outlet.fuel.T_outflow)),
        p=outlet.fuel.p,
        cp=fuelOutlet.cp,
        LHV=fuelOutlet.LHV),
      slag(
        m_flow=outlet.slag.m_flow,
        T=noEvent(actualStream(outlet.slag.T_outflow)),
        p=outlet.slag.p))) annotation (Placement(transformation(extent={{274,-102},{300,-76}})));

initial equation
  unburntFraction = 0;
  h_flueGas_out_del = h_start;

equation

  der(h_flueGas_out_del) = 1/Tau*(h_flueGas_out-h_flueGas_out_del);

  if noEvent(t_dwell_flueGas < burning_time.t) then
    der(unburntFraction) = 1/Tau * ((1.0 - t_dwell_flueGas/burning_time.t) - unburntFraction);
  else
    der(unburntFraction) = 1/Tau * (0-unburntFraction);
  end if;

  mass = geo.volume * (flueGasOutlet.d + flueGasInlet.d)/2;

  //____________/ Resulting Xi for entire fuel mass in the volume \______________
  elementaryComposition_fuel_in =fuelInlet.xi_e;


  //________________/ Mass balance - flue gas \______________________________________
  0 =m_flow_fuel_burned*(1 - elementaryComposition_fuel_in[6]*reactionZone.xi_slag) + inlet.flueGas.m_flow + outlet.flueGas.m_flow;

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 =inlet.slag.m_flow + m_flow_fuel_burned*elementaryComposition_fuel_in[6]*reactionZone.xi_slag + outlet.slag.m_flow;

  //______________/ Mass balance - Fuel \____________________________
  0 =outlet.fuel.m_flow + inlet.fuel.m_flow - m_flow_fuel_burned;

  //__________/ molar flow rates of combustable components (educts) into the whole burner system (maybe not all of it is burned) \________
  n_flow_C = elementaryComposition_fuel_in[1]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_C;
  n_flow_H = elementaryComposition_fuel_in[2]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_H;
  n_flow_O = elementaryComposition_fuel_in[3]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_O;
  n_flow_N = elementaryComposition_fuel_in[4]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_N;
                                                             // N not N2!!!!!!
  n_flow_S = elementaryComposition_fuel_in[5]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_S;
  n_flow_Ash = elementaryComposition_fuel_in[6]*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_Ash;
  n_flow_H2O = (1-sum(elementaryComposition_fuel_in))*inlet.fuel.m_flow /ClaRa.Basics.Constants.M_H2O;

  //_______________/ determination of lambda \_________________________
  // theoretically required oxygen mass flow rate to burn all the fuel
   m_flow_oxygen_req = (1-unburntFraction)*(n_flow_C + n_flow_H/4.0 + n_flow_S + n_flow_N*reactionZone.xi_NOx/2 - n_flow_O/2)*ClaRa.Basics.Constants.M_O
                                                                                            *2.0;
   m_flow_air_req*max(1e-32,flueGasInlet.xi[6]) = m_flow_oxygen_req;

    if noEvent(m_flow_oxygen_req <= 0) then
    lambdaComb = 1.0e3;
    else
    lambdaComb = (inlet.flueGas.m_flow*flueGasInlet.xi[6])/max(1e-12, m_flow_oxygen_req);
    end if;

  //calculation of actual fuel and oxygen mass flow rates that are burned
  if noEvent(lambdaComb > 1) then
    m_flow_fuel_burned = (1 - unburntFraction)*inlet.fuel.m_flow;
    m_flow_oxygen_burned = m_flow_oxygen_req;
  else
    m_flow_fuel_burned = lambdaComb*(1 - unburntFraction)*inlet.fuel.m_flow;
    m_flow_oxygen_burned = lambdaComb*m_flow_oxygen_req;
  end if;

  //_____________/ Calculation of the LHV \______________________________________
  LHV = fuelInlet.LHV;

  //______________________________/ mass balance of flue gas components \__________________________
  zeros(flueGas.nc-1) =inlet.flueGas.m_flow*flueGasInlet.xi + outlet.flueGas.m_flow*xi_flueGas + m_flow_fuel_burned*reactionZone.prod_comp;

  //_____________/ Calculation of fuel formation enthalpy with LHV for an ideal combustion\__________________
  m_flow_fuel_id = 1.0;
  m_flow_flueGas_id =(m_flow_fuel_id*(1 - elementaryComposition_fuel_in[6]*reactionZone.xi_slag));           //ideal flue gas mass flow
   xi_flueGas_id =1/m_flow_flueGas_id*reactionZone.prod_comp;   //products of an ideal combustion

   sum_comp = sum(xi_flueGas_id);
  Delta_h_f - LHV =m_flow_flueGas_id*((ideal_combustion.h_i)*cat(1,xi_flueGas_id,{1 - sum(xi_flueGas_id)})) + elementaryComposition_fuel_in[6]*reactionZone.xi_slag*outlet.slagType.cp*T_0; //formation enthalpy of used fuel

  //_______________/ Energy Balance flueGasCombustion \__________________________
  0 =Q_flow_wall + Q_flow_top + Q_flow_bottom + Q_flow_CarrierTubes + Q_flow_TubeBundle + inlet.flueGas.m_flow*flueGasInlet.h + inlet.fuel.m_flow*(fuelInlet.cp*(inStream(inlet.fuel.T_outflow) - T_0) + Delta_h_f) + outlet.fuel.m_flow*(fuelOutlet.cp*(outlet.fuel.T_outflow - T_0) + Delta_h_f) + outlet.slag.m_flow*outlet.slagType.cp*(noEvent(actualStream(outlet.slag.T_outflow)) - T_0) + inlet.slag.m_flow*inlet.slagType.cp*(noEvent(actualStream(inlet.slag.T_outflow)) - T_0) + outlet.flueGas.m_flow*h_flueGas_out;

  //______________/Properties for heat transfer corellation\_________

  der(V_flow_flueGas_out) = 1/Tau*(outlet.flueGas.m_flow/flueGasOutlet.d - V_flow_flueGas_out);
  V_flow_flueGas_in = inlet.flueGas.m_flow/flueGasInlet.d;

  sum_xi = sum(flueGasOutlet.xi);

  xi_fuel_out = inStream(inlet.fuel.xi_outflow);//xi_fuel_in; //no change of fuel composition during combustion

  xi_fuel = (inlet.fuel.m_flow)/(inlet.flueGas.m_flow);// amount of fuel per flue gas mass

  //___________/ T_outflows \__________________________________________
  outlet.fuel.T_outflow = flueGasOutlet.T;
  outlet.flueGas.T_outflow = flueGasOutlet.T;
  heat_bottom.T = iCom.T_out;

  if slagTemperature_calculationType==1 then
    inlet.slag.T_outflow = T_slag;
    outlet.slag.T_outflow = T_slag;
  elseif slagTemperature_calculationType==2 then
    inlet.slag.T_outflow = flueGasOutlet.T;
    outlet.slag.T_outflow = flueGasOutlet.T;
  elseif slagTemperature_calculationType==3 then
    inlet.slag.T_outflow = (flueGasOutlet.T + flueGasInlet.T)/2;
    outlet.slag.T_outflow = (flueGasOutlet.T + flueGasInlet.T)/2;
  elseif slagTemperature_calculationType==4 then
    inlet.slag.T_outflow = flueGasInlet.T;
    outlet.slag.T_outflow = flueGasInlet.T;
  else
    inlet.slag.T_outflow = T_slag;
    outlet.slag.T_outflow = T_slag;
    assert(slagTemperature_calculationType==1 or slagTemperature_calculationType==2 or slagTemperature_calculationType==3 or slagTemperature_calculationType==4, "Invalid slag temperature calculation type");
  end if;

  //___________/ Dummy T_outflows \__________________________________________
  inlet.fuel.T_outflow = outlet.flueGas.T_outflow;
  inlet.flueGas.T_outflow  = outlet.flueGas.T_outflow;

  inlet.flueGas.xi_outflow = xi_flueGas;
  outlet.flueGas.xi_outflow = xi_flueGas;
  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.flueGas.m_flow;
  eye_int[1].T = flueGasOutlet.T-273.15;
  eye_int[1].s = flueGasOutlet.s/1e3;
  eye_int[1].p = flueGasOutlet.p/1e5;
  eye_int[1].h = flueGasOutlet.h/1e3;
  eye_int[1].xi = flueGasOutlet.xi;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-100},
            {300,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{32,74},{240,44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "T_out="+String(bulk.T,format="1.0f") +" K")),
        Text(
          extent={{32,-6},{240,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "Q_wall="+String(Q_flow_wall/1e6,format="1.0f")+" MW")),
        Text(
          extent={{32,34},{240,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "lambda="+String(min(99,lambdaComb),format="1.1f"))),
        Text(
          extent={{32,-46},{240,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "Q_bundle="+String(Q_flow_TubeBundle/1e6,format="1.0f")+" MW"))}),
    Documentation(info="<html>
<p><b>Model description: </b>A stationary model for furnace sections with convective tube bundles inside (additional heat ports)</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>Tube bundles are regarded with replaceable geometry models</li>
<li>Additional heat transfer ports to regard heat transfer for tube banks and carrier tubes</li>
<li>The formation enthalpy of the used fuel is calculated with the given Lower heating value and and ideal combustion with the given elemental composition of the fuel</li>
<li>Lower heating can be regarded with a fixed value or calculated according to the &QUOT;Verbandsformel&QUOT;</li>
<li>Different heat transfer correlations can be chosen</li>
<li>Capable to burn unburnt fuel from lower burner sections</li>
<li>Amount of burnable fuel mass is calculated with particle diffusity which depends on models used to determine the mean migration speed according to the volume flow rates of the flue gas</li>
</ul></p>
</html><html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2023.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end FlameRoomWithTubeBundle_L2_Static;
