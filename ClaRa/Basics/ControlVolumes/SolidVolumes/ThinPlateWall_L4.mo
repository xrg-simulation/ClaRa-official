within ClaRa.Basics.ControlVolumes.SolidVolumes;
model ThinPlateWall_L4 "A thin wall with discretisation in axial direction"
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

  extends ClaRa.Basics.Icons.WallThin;
 replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));

parameter ClaRa.Basics.Units.Length thickness_wall "Wall thickness"
                                  annotation(Dialog(group="Geometry"));

public
  parameter ClaRa.Basics.Units.Length length=1 "Length of plate"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=1 "Width of plate"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Additional to mass calculated by density*plate volume length*width*thicknesswall"
                                                                                                                                   annotation(Dialog(group="Geometry"));
  parameter Real CF_area=1 "Correction factor for additional heat transfer area" annotation(Dialog(group="Geometry"));
  parameter Integer N_pathes=1 "Number of pathes in parallel" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Temperature T_start[N_ax]=293.15*ones(N_ax) "Start values of wall temperature"  annotation(Dialog(group="Initialisation"));
  parameter Integer N_ax=1 "Number of axial elements" annotation (Dialog(group="Discretisation"));
  parameter Modelica.SIunits.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));

  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  ClaRa.Basics.Units.Temperature T[N_ax](start=T_start,nominal=500*ones(N_ax));
  ClaRa.Basics.Units.InternalEnergy U[N_ax](nominal = 4e6*ones(N_ax));

  ClaRa.Basics.Interfaces.HeatPort_a outerPhase[N_ax] "outer side of the cylinder" annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(extent={{-10,40},{10,60}})));
   TILMedia.Solid solid[N_ax](redeclare each replaceable model SolidType = Material, T=T) annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase[N_ax] "Inner side of the cylinder" annotation (Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(extent={{-10,-60},{10,-40}})));

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Integer N_ax;
  input ClaRa.Basics.Units.Area A_heat[N_ax] "Mean area of heat transfer (single tube)";
  input ClaRa.Basics.Units.Length thickness_wall "Wall thickness";
  input ClaRa.Basics.Units.Mass mass[N_ax] "Wall mass";
  input ClaRa.Basics.Units.InternalEnergy U[N_ax] "Inner energy of wall";
  input Units.Temperature T_i[N_ax] "Inner phase temperature";
  input Units.Temperature T_o[N_ax] "Outer phase temperature";
  input ClaRa.Basics.Units.Temperature T[N_ax] "Wall temperature";
  input Real lambda[N_ax] "Heat conductivity";
  input Units.HeatFlowRate Q_flow_i[N_ax] "Heat flow rate to inner phase";
  input Units.HeatFlowRate Q_flow_o[N_ax] "Heat flow rate to outer phase";
  input Units.HeatCapacityMassSpecific cp[N_ax] "Specific heat capacity";
  input Units.DensityMassSpecific d[N_ax] "Material density";
end Summary;

Summary summary(N_ax=N_ax,A_heat=A_heat, thickness_wall=thickness_wall, mass=mass, U=U, T_i=innerPhase.T, T_o=outerPhase.T,T=T, lambda=solid.lambda, Q_flow_i=innerPhase.Q_flow, Q_flow_o=outerPhase.Q_flow, cp=solid.cp, d=solid.d)
                                                                                                                                                                                                annotation (Placement(transformation(extent={{-60,-40},{-40,-22}})));

protected
   final parameter ClaRa.Basics.Units.Mass mass[N_ax]={Delta_x[i]*width*thickness_wall*sum(solid[i].d)*N_pathes/N_ax+mass_struc*Delta_x[i]/length for i in 1:N_ax} "Fixed mass";
   final parameter ClaRa.Basics.Units.Area A_heat[N_ax]={Delta_x[i]*width*CF_area*N_pathes for i in 1:N_ax} "Area for heat transfer";

equation
  for i in 1:N_ax loop
  U[i]=T[i]*mass[i]*solid[i].cp;
  der(U[i]) = (innerPhase[i].Q_flow+outerPhase[i].Q_flow);

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
  if stateLocation == 1 then //states are located at inner phase
    outerPhase[i].T = outerPhase[i].Q_flow/(solid[i].lambda*CF_lambda * A_heat[i]) * thickness_wall + T[i];
    innerPhase[i].T = T[i];
  elseif stateLocation == 2 then //states are located in center phase
    innerPhase[i].Q_flow = solid[i].lambda*CF_lambda/(thickness_wall * 0.5) * A_heat[i] * (innerPhase[i].T-T[i]);
    outerPhase[i].Q_flow = solid[i].lambda*CF_lambda/(thickness_wall * 0.5) * A_heat[i] * (outerPhase[i].T-T[i]);
  else // states are located at outer phase
    outerPhase[i].T = T[i];
    innerPhase[i].T = innerPhase[i].Q_flow/(solid[i].lambda*CF_lambda * A_heat[i]) * thickness_wall + T[i];
  end if;
  end for;
initial equation
    if initOption == 1 then //steady state
      der(U)=0*ones(N_ax);
    elseif initOption == 203 then //steady temperature
      der(T)=0*ones(N_ax);
    elseif initOption == 0 then //no init
     T=T_start; // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

  annotation (Documentation(info="<html>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -50},{100,50}})),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-50},{100,50}}),
         graphics));
end ThinPlateWall_L4;
