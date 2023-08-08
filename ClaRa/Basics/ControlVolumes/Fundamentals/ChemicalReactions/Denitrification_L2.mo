within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model Denitrification_L2 "Gas || L2 || Denitrification"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DenitrificationBase;
  extends ChemicalReactionsBaseGas(final i=1, final use_signal=false);


parameter Modelica.SIunits.Temperature T_NH3_O2_mixture = 273.15+200 "Temperature of ammonia oxygen inlet"
                                                                                                          annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
parameter Real separationRate(min = 0, max = 1) = 0.995 "Efficiency of NOx separation"
                                                                                      annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

// standard formation enthalpy (T = 298.15K /p = 1.0 bar) for  components involved in deNOx catalysis
final parameter Modelica.SIunits.MolarInternalEnergy Delta_f_H_NO = 91.271e3 "Standrad formation enthalpy nitric oxide";
final parameter Modelica.SIunits.MolarInternalEnergy Delta_f_H_NH3 = -45.940e3 "Standrad formation  enthalpy ammonia";
final parameter Modelica.SIunits.MolarInternalEnergy Delta_f_H_H2O = -241.826e3 "Standrad formation  enthalpy water";

//## V A R I A B L E   P A R T##################################################################################

// Quantaties for deNOx catalysis
Modelica.SIunits.MassFlowRate NH3_O2_m_flow "Mass flow of ammoinia oxygen mix";
//Molar flow rates
Modelica.SIunits.MolarFlowRate n_flow_NOx_in "Molar flow rate of nitric oxides at inlet";
Modelica.SIunits.MolarFlowRate n_flow_O2_in "Molar flow rate of oxygen at inlet";
Modelica.SIunits.MolarFlowRate n_flow_NH3_req "Required molar flow rate of ammonia";
Modelica.SIunits.MolarFlowRate n_flow_O2_req "Required molar flow rate of oxygen";
// standard reaction enthalpy
Modelica.SIunits.MolarInternalEnergy Delta_R_H "Reaction enthalpy";

Modelica.SIunits.MassFraction NH3_O2_in_xi[iCom.mediumModel.nc-1] "Inlet composition of ammonia oxygen mix";


    TILMedia.Gas_pT     NH3_O2_in(
    p=iCom.p_in,
    T=T_NH3_O2_mixture,
    xi=NH3_O2_in_xi,
    gasType = iCom.mediumModel)
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));

Real reaction_heat;

equation


  reaction_heat=(-n_flow_NH3_req*NH3_O2_in.M_i[5] - 6/4.*n_flow_NH3_req*NH3_O2_in.M_i[8])* Delta_R_H/(0.1*(4.0*NH3_O2_in.M_i[5] + 6*NH3_O2_in.M_i[8])); //Not considered in the energy balance

  Q_flow_reaction = 0;
  m_flow_reaction[1] =  NH3_O2_m_flow;
  h_reaction[1] = NH3_O2_in.h;

  //No auxillary step
  xi_aux=xi;
  m_flow_aux=iCom.m_flow_in;
  h_aux=TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);



  for i in 1:(iCom.mediumModel.nc-1) loop
      if i==6 then
        NH3_O2_in_xi[i] = if separationRate > 0 then NH3_O2_in.M_i[6]*n_flow_O2_req/NH3_O2_m_flow else 0;
        else
        NH3_O2_in_xi[i] = 0;
      end if;
  end for;

  // determination of required NH3 and O2 for deNOx catalysis
  n_flow_NOx_in = iCom.m_flow_in*iCom.xi_in[7]/NH3_O2_in.M_i[7];
  n_flow_O2_in = iCom.m_flow_in*iCom.xi_in[6]/NH3_O2_in.M_i[6];
  n_flow_NH3_req = separationRate*n_flow_NOx_in;
  n_flow_O2_req = if n_flow_O2_in >= 1/4.*n_flow_NH3_req then 1e-12 else 1/4.*n_flow_NH3_req-n_flow_O2_in;

  NH3_O2_m_flow =NH3_O2_in.M_i[6]*n_flow_O2_req +NH3_O2_in.M_i[9]*n_flow_NH3_req;


  //____________________________/ deNOx Catalysis \_______________________________________
  if use_dynamicMassbalance then

  for i in 1:(iCom.mediumModel.nc-1) loop
    if i == 5 then
       der(xi[5]) = 1/mass * (iCom.m_flow_in*(iCom.xi_in[5] - xi[5]) + iCom.m_flow_out*(iCom.xi_out[5] - xi[5]) + n_flow_NH3_req*NH3_O2_in.M_i[5]*(1-xi[5]));
      else if i == 6 then
       der(xi[6]) = 1/mass * (iCom.m_flow_in*(iCom.xi_in[6] - xi[6]) + iCom.m_flow_out*(iCom.xi_out[6] - xi[6]) - 1/4.*n_flow_NH3_req*NH3_O2_in.M_i[6]*(1-xi[6]));
      else if i == 7 then
       der(xi[7]) = 1/mass * (iCom.m_flow_in*(iCom.xi_in[7] - xi[7]) + iCom.m_flow_out*(iCom.xi_out[7] - xi[7]) - iCom.m_flow_in* xi[7]*separationRate*(1- xi[7]));
      else if i == 8 then
       der(xi[8]) = 1/mass * (iCom.m_flow_in*(iCom.xi_in[8] - xi[8]) + iCom.m_flow_out*(iCom.xi_out[8] - xi[8]) + 6/4.*n_flow_NH3_req*NH3_O2_in.M_i[8]*(1- xi[7]));
      else
       der(xi[i]) = 1/mass * (iCom.m_flow_in*(iCom.xi_in[i] - xi[i]) + iCom.m_flow_out*(iCom.xi_out[i] - xi[i]));
     end if;
    end if;
   end if;
  end if;
end for;

else

  for i in 1:(iCom.mediumModel.nc-1) loop
    if i == 5 then
       xi[5]*iCom.m_flow_out + iCom.xi_in[5]*iCom.m_flow_in + n_flow_NH3_req*
        NH3_O2_in.M_i[5]                                                                                                = 0;
      else if i == 6 then
       xi[6]*iCom.m_flow_out  +  iCom.xi_in[6]*iCom.m_flow_in - 1/4.*n_flow_NH3_req*
          NH3_O2_in.M_i[6]                                                                                                    = 0;
      else if i == 7 then
       xi[7]*iCom.m_flow_out + iCom.xi_in[7]*iCom.m_flow_in*(1-separationRate)  = 0;
      else if i == 8 then
       xi[8]*iCom.m_flow_out  +  iCom.xi_in[8]*iCom.m_flow_in + 6/4.*n_flow_NH3_req*
              NH3_O2_in.M_i[8]                                                                                                  = 0;
    else
    xi[i]*iCom.m_flow_out  +  iCom.xi_in[i]*iCom.m_flow_in  = 0;
     end if;
    end if;
   end if;
  end if;
end for;
end if;

Delta_R_H = (4*Delta_f_H_NH3 + 4*Delta_f_H_NO  - 6*Delta_f_H_H2O);

  annotation (Diagram(graphics={
        Text(
          extent={{-39,4},{39,-4}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={55,12},
          rotation=180,
          textString="4NH3 +4NO +O2"),
        Text(
          extent={{92,16},{134,8}},
          lineColor={0,0,0},
          textString="4N2 +6H2O"),
        Rectangle(
          extent={{-48,54},{46,-52}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5),
        Line(
          points={{-82,0},{-32,0},{-30,0},{-30,0},{-30,0},{-32,0},{-30,0},{-30,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{0,22},{0,16},{0,12},{0,14},{0,14},{0,12},{0,12},{0,14}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Polygon(
          points={{0,10},{-2,14},{2,14},{0,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{-2,2},{2,2},{0,-2}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-30,0},
          rotation=90),
        Line(
          points={{20,0},{54,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{0,-2},{-2,2},{2,2},{0,-2}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={92,0},
          rotation=90),
        Line(
          points={{82,12},{90,12},{90,12}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{0,-2},{-2,2},{2,2},{0,-2}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={90,12},
          rotation=90),
        Rectangle(
          extent={{28,18},{132,6}},
          lineColor={0,0,0},
          pattern=LinePattern.Solid,
          lineThickness=0.5)}));
end Denitrification_L2;
