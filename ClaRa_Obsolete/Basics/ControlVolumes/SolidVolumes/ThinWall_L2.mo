within ClaRa_Obsolete.Basics.ControlVolumes.SolidVolumes;
model ThinWall_L2 "A thin wall involving one volume element in heat flow direction"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.Icons.WallThin;
 replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));

 parameter ClaRa.Basics.Units.Area A_heat "Surface area"
                                 annotation(Dialog(group="Geometry"));

parameter ClaRa.Basics.Units.Length thickness_wall "Wall thickness"
                                  annotation(Dialog(group="Geometry"));

public
  parameter ClaRa.Basics.Units.Mass mass "Fixed mass"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Temperature T_start=293.15 "Start values of wall temperature"  annotation(Dialog(group="Initialisation"));

  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));

  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  ClaRa.Basics.Units.Temperature T(start=T_start,nominal=500);
  ClaRa.Basics.Units.InternalEnergy U(nominal = 4e6);

  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase "outer side of the cylinder"
                                 annotation (Placement(transformation(extent={{-10,40},
            {10,60}}),      iconTransformation(extent={{-10,40},{10,60}})));
   TILMedia.Solid solid(redeclare each replaceable model SolidType = Material, T=T)
     annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase "Inner side of the cylinder"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}}),
        iconTransformation(extent={{-10,-60},{10,-40}})));

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Area A_heat "Mean area of heat transfer (single tube)";
  input ClaRa.Basics.Units.Length thickness_wall "Wall thickness";
  input ClaRa.Basics.Units.Mass mass "Wall mass";
  input ClaRa.Basics.Units.InternalEnergy U "Inner energy of wall";
  input ClaRa.Basics.Units.Temperature T_i "Inner phase temperature";
  input ClaRa.Basics.Units.Temperature T_o "Outer phase temperature";
  input ClaRa.Basics.Units.Temperature T "Wall temperature";
  input Real lambda "Heat conductivity";
  input ClaRa.Basics.Units.HeatFlowRate Q_flow_i "Heat flow rate to inner phase";
  input ClaRa.Basics.Units.HeatFlowRate Q_flow_o "Heat flow rate to outer phase";
  input ClaRa.Basics.Units.HeatCapacityMassSpecific cp "Specific heat capacity";
  input ClaRa.Basics.Units.DensityMassSpecific d "Material density";
end Summary;

Summary summary(A_heat=A_heat, thickness_wall=thickness_wall, mass=mass, U=U, T_i=innerPhase.T, T_o=outerPhase.T,T=T, lambda=solid.lambda, Q_flow_i=innerPhase.Q_flow, Q_flow_o=outerPhase.Q_flow, cp=solid.cp, d=solid.d);

 extends ClaRa_Obsolete.Basics.Icons.Obsolete_v1_3;
equation
  U=T*mass*solid.cp;
  der(U) = (innerPhase.Q_flow+outerPhase.Q_flow);

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
  if stateLocation == 1 then //states are located at inner phase
    outerPhase.T = outerPhase.Q_flow/(solid.lambda*CF_lambda * A_heat) * thickness_wall + T;
    innerPhase.T = T;
  elseif stateLocation == 2 then //states are located in center phase
    innerPhase.Q_flow = solid.lambda*CF_lambda/(thickness_wall * 0.5) * A_heat * (innerPhase.T-T);
    outerPhase.Q_flow = solid.lambda*CF_lambda/(thickness_wall * 0.5) * A_heat * (outerPhase.T-T);
  else // states are located at outer phase
    outerPhase.T = T;
    innerPhase.T = innerPhase.Q_flow/(solid.lambda*CF_lambda * A_heat) * thickness_wall + T;
  end if;

initial equation
    if initOption == 1 then //steady state
      der(U)=0;
    elseif initOption == 203 then //steady temperature
      der(T)=0;
    elseif initOption == 0 then //no init
     T=T_start; // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

  annotation (Documentation(info="<html>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -50},{100,50}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-50},{100,50}}),
         graphics));
end ThinWall_L2;
