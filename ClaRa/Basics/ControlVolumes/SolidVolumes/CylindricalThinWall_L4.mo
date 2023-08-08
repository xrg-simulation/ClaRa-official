within ClaRa.Basics.ControlVolumes.SolidVolumes;
model CylindricalThinWall_L4 "A thin cylindric wall with axial discretisation"
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

  extends ClaRa.Basics.Icons.WallThinLarge;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation (Dialog(group="Fundamental Definitions"));

  import SI = ClaRa.Basics.Units;
public
  parameter Integer N_ax=3 "Number of axial elements" annotation (Dialog(group="Discretisation"));
  parameter ClaRa.Basics.Units.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
  parameter Units.Length diameter_o "Outer diameter" annotation (Dialog(group="Geometry"));
  parameter Units.Length diameter_i "Inner diameter" annotation (Dialog(group="Geometry"));
  parameter Units.Length length "Length of cylinder" annotation (Dialog(group="Geometry"));
  parameter Integer N_tubes=1 "Number of tubes in parallel" annotation (Dialog(group="Geometry"));
  parameter Units.Temperature T_start[N_ax]=ones(N_ax)*293.15 "Start values of wall temperature" annotation (Dialog(group="Initialisation"));
  inner parameter Integer initOption=213 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));
  parameter Integer stateLocation=2 "Location of states" annotation (Dialog(group="Numerical Efficiency"), choices(
      choice=1 "Inner location of states",
      choice=2 "Central location of states",
      choice=3 "Outer location of states",
      choice=0 "No init, use T_start as guess values"));
  parameter String suppressChattering="True" "Enable to suppress possible chattering" annotation (Dialog(group="Numerical Efficiency"), choices(choice="False" "False (faster if no chattering occurs)",
                                                                                            choice="True" "True (faster if chattering occurs)"));
  final parameter Units.Mass mass=sum(solid.d .* (Modelica.Constants.pi/4*(diameter_o^2 - diameter_i^2)*Delta_x*N_tubes)) "Wall mass";
protected
  final parameter Units.HeatFlowRate Q_flow_nom=1;
  constant Real Q_flow_eps=1e-9;

public
  Units.Temperature T[N_ax](start=T_start, each nominal=500) "Axial temperatures";

protected
  Units.HeatFlowRate Delta_Q_flow[N_ax](each nominal=1e5);
  Units.InternalEnergy U[N_ax](each nominal=4e6);

public
  ClaRa.Basics.Interfaces.HeatPort_a outerPhase[N_ax](T(start=T_start)) "outer side of the cylinder" annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(extent={{-10,40},{10,60}})));
  TILMedia.Solid solid[N_ax](T(start=T_start) = T, redeclare each replaceable model SolidType = Material) annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase[N_ax](T(start=T_start)) "Inner sider of the cylinder" annotation (Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(extent={{-10,-60},{10,-40}})));

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Length diameter_o "Outer diameter";
    input ClaRa.Basics.Units.Length diameter_i "Inner diameter";
    input Units.Length length "Length of cylinder";
    input Integer N_tubes "Number of tubes in parallel";
    input ClaRa.Basics.Units.Mass mass "Wall mass";
    parameter Integer N_ax "Number of axial elements";
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

Summary summary(diameter_o=diameter_o,
                diameter_i=diameter_i,
                length=length,
                N_tubes=N_tubes,
                mass=mass,
                N_ax=N_ax,
                U=U,
                T_i=innerPhase.T,
                T_o=outerPhase.T,
                T=T,
                lambda=solid.lambda,
                Q_flow_i=innerPhase.Q_flow,
                Q_flow_o=outerPhase.Q_flow,
                cp=solid.cp,
                d=solid.d);

equation
  assert(diameter_o > diameter_i, "The outer diameter has to be greater then the inner diameter!");
  for i in 1:N_ax loop
    U[i] = T[i]*solid[i].d*(Modelica.Constants.pi/4*(diameter_o^2 - diameter_i^2)*Delta_x[i]*N_tubes)*solid[i].cp;
    if suppressChattering == "True" then
      der(U[i]) = Delta_Q_flow[i]*Q_flow_nom;
      Delta_Q_flow[i] = noEvent(if abs(innerPhase[i].Q_flow + outerPhase[i].Q_flow) > Q_flow_eps then (innerPhase[i].Q_flow + outerPhase[i].Q_flow) else 0)/Q_flow_nom;
    else
      der(U[i]) = Delta_Q_flow[i];
      Delta_Q_flow[i] = innerPhase[i].Q_flow + outerPhase[i].Q_flow;
    end if;

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
    if stateLocation == 1 then
      //states are located at inner phase
      outerPhase[i].T = outerPhase[i].Q_flow .* log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi) + T[i];
      innerPhase[i].T = T[i];
    elseif stateLocation == 2 then
      //states are located in center phase
      innerPhase[i].Q_flow = solid[i].lambda*CF_lambda*(2*Modelica.Constants.pi*Delta_x[i]*N_tubes)/log((diameter_o + diameter_i)/(2*diameter_i))*(innerPhase[i].T - T[i]);
      outerPhase[i].Q_flow = solid[i].lambda*CF_lambda*(2*Modelica.Constants.pi*Delta_x[i]*N_tubes)/log((2*diameter_o)/(diameter_o + diameter_i))*(outerPhase[i].T - T[i]);
    else
      // states are located at outer phase
      outerPhase[i].T = T[i];
      innerPhase[i].T = innerPhase[i].Q_flow .* log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi) + T[i];
    end if;

  end for;

initial equation

   if initOption == 1 then //steady state
     der(U)=zeros(N_ax);
   elseif initOption == 203 then //steady temperature
     der(T)=zeros(N_ax);
   elseif initOption == 0 then //no init
     //do nothing
   elseif initOption == 213 then // fixed temperature
     T=T_start;
   else
    assert(initOption == 0,"Invalid init option");
   end if;

  annotation (
    Documentation(info="<html>
<p><h4>This hollow cylinder uses a combination of arithmetic and logarithmic averaging for the definition of the heat transfer surfaces</h4></p>
<p>This refined averaging leads to better grrement with the analytical solution, especially when considering thick-walled components and a small number of nodes</p>
</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-07-14: Initial implementation. Friedrich Gottelt, Johannes Brunnemann, XRG Simulation GmbH</li>
</ul></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-50},{140,50}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-140,-50},{140,50}}), graphics));
end CylindricalThinWall_L4;
