within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model LinearNominalPoint "Linear | Nominal operation point | unchoked flow"
//   "A linear pressure loss using a constant pressure loss coefficient"
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u." annotation(Dialog(group="Valve Characteristics"));
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  parameter Basics.Units.PressureDifference Delta_p_nom=1e5 "Nominal pressure difference for Kv definition" annotation (Dialog(group="Valve Characteristics"));

  parameter Basics.Units.MassFlowRate m_flow_nom=1 "Nominal mass flow rate" annotation (Dialog(group="Valve Characteristics"));
 // parameter SI.PressureDifference Delta_p_check=0;

 // parameter SI.PressureDifference Delta_p_hyst=0;
  Modelica.Blocks.Tables.CombiTable1D ValveCharacteristics(table=CL_valve,
      columns={2});
 // Boolean ValveOpen;
  Real aperture_ "Effective apperture";
  Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";

equation
  flowIsChoked=0 "1 if flow is choked, 0 if not";
  PR_choked=-1 "Pressure ratio at which choking occurs";
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;
//  m_flow = noEvent(if checkValve then if Delta_p >0 then aperture_* m_flow_nom * Delta_p/Delta_p_nom else 0 else aperture_* m_flow_nom * Delta_p/Delta_p_nom);

//   m_flow = noEvent(if checkValve then if Delta_p >=0 then aperture_* m_flow_nom * Delta_p/Delta_p_nom else (if iCom.opening_leak_ >=1e-6 then iCom.opening_leak_* m_flow_nom * Delta_p/Delta_p_nom else Modelica.Constants.eps) else
//                                                                                                     aperture_* m_flow_nom * Delta_p/Delta_p_nom);

//ValveOpen= if m_flow>0 then true else false;

// m_flow = noEvent(
// if checkValve then
//   if Delta_p >Delta_p_check + Delta_p_hyst and not pre(ValveOpen) or Delta_p >= Delta_p_check and pre(ValveOpen)  then
//   aperture_* m_flow_nom * (Delta_p-Delta_p_check)/Delta_p_nom
//   else
//   iCom.opening_leak_* m_flow_nom * Delta_p/Delta_p_nom
//  else
// aperture_* m_flow_nom * (Delta_p-Delta_p_check)/Delta_p_nom);

//m_flow= if checkValve then SM(50,0, Delta_p)*aperture_* m_flow_nom * (Delta_p)/Delta_p_nom + SM(-10,0, Delta_p)*(-1e-5) else aperture_* m_flow_nom * (Delta_p)/Delta_p_nom;
m_flow= if checkValve then SM(50,0, Delta_p)*aperture_* m_flow_nom * (Delta_p)/Delta_p_nom else aperture_* m_flow_nom * (Delta_p)/Delta_p_nom;
//or
end LinearNominalPoint;
