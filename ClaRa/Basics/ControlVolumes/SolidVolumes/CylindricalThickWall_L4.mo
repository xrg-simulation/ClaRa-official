within ClaRa.Basics.ControlVolumes.SolidVolumes;
model CylindricalThickWall_L4 "A thick cylindric wall with radial discretisation"
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

  extends ClaRa.Basics.Icons.WallThick;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");

  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder" annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));
protected
  parameter Integer N_A_heat=N_rad*2 "Number of surfaces used in order to model heat flow";

public
  parameter Integer N_rad = 1 "Number of radial elements" annotation(Dialog(group="Discretisation"));
  parameter Real sizefunc = 0 "Stretching of the volume elements (+1: inner elements are smaller)" annotation(Dialog(group="Discretisation"));
  parameter ClaRa.Basics.Units.Length diameter_o "Outer diameter" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i "Inner diameter" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length length "Length of cylinder" annotation(Dialog(group="Geometry"));
  parameter Integer N_tubes= 1 "Number of tubes in parallel" annotation(Dialog(group="Geometry"));
  parameter Integer N_passes= 1 "Number of passes per tube" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Temperature T_start[N_rad]=ones(N_rad)*293.15 "Start values of wall temperature inner --> outer"
                                                                                            annotation(Dialog(group="Initialisation"));
 //Area of Heat Transfer
  final parameter ClaRa.Basics.Units.Area A_heat_m=(N_tubes*Modelica.Constants.pi*length*(diameter_o - diameter_i))/log(diameter_o/diameter_i) "Mean area of heat transfer per pass";

  //Conductive heat resistance of the wall material
  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom=(diameter_o - diameter_i)/(2*solid[1].lambda_nominal*A_heat_m) "Nominal conductive heat resistance";

  inner parameter Integer initOption=213 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));

  final parameter ClaRa.Basics.Units.Mass mass = mass_struc+solid[N_rad].d*Modelica.Constants.pi/4*(diameter_o^2-diameter_i^2)*length*N_tubes "Wall mass";
  ClaRa.Basics.Units.Length Delta_radius[N_rad] "Thicknes of the volume elements";
  ClaRa.Basics.Units.Length radius[N_rad+1] "Radii of the heat transfer areas";
  ClaRa.Basics.Units.Temperature T[N_rad](start=T_start, each nominal=300) "Solid material temperature";
  ClaRa.Basics.Units.InternalEnergy U[N_rad] "Internal energy";
  ClaRa.Basics.Units.HeatFlowRate Q_flow[N_rad+1] "Heat flow through material";
  ClaRa.Basics.Units.Area A_heat[N_A_heat];
  ClaRa.Basics.Units.Length radius_m[N_A_heat];
  ClaRa.Basics.Units.Length radius_v[N_rad+2] "Radial position of the volume elements";


  Real Tdr[N_rad+1] "Integral(Tdr)";
  ClaRa.Basics.Units.ThermalResistance HR_rad[N_rad] "Conductive heat resistance of each radial volume element";
  ClaRa.Basics.Units.ThermalResistance HR "Conductive heat resistance of the wall";
  ClaRa.Basics.Units.Area A_heat_m_rad[N_rad] "Mean area of heat transfer per radial volume element";

  ClaRa.Basics.Units.Temperature T_mean "Mean temperature";



public
  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase "outer side of the cylinder"
                                 annotation (Placement(transformation(extent={{-10,66},
            {10,86}}),      iconTransformation(extent={{-10,66},{10,86}})));
   TILMedia.Solid solid[N_rad](T=T, redeclare each model SolidType =
        Material)
     annotation (Placement(transformation(extent={{38,-2},{58,18}})));

  ClaRa.Basics.Interfaces.HeatPort_b innerPhase "Inner sider of the cylinder"
    annotation (Placement(transformation(extent={{-8,-48},{12,-28}}),
        iconTransformation(extent={{-12,-82},{8,-62}})));

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   parameter Integer N_rad "Number of radial elements";
   parameter Integer N_A_heat "Number of surfaces used in order to model heat flow";
   input ClaRa.Basics.Units.Length diameter_o "Outer diameter";
   input ClaRa.Basics.Units.Length diameter_i "Inner diameter";
   input ClaRa.Basics.Units.Length length "Length of cylinder";
   input Integer N_tubes "Number of tubes in parallel";
   input ClaRa.Basics.Units.Length Delta_radius[N_rad] "Thicknes of the volume elements";
   input ClaRa.Basics.Units.Length radius[N_rad+1] "Radii of the heat transfer areas";
   input ClaRa.Basics.Units.Temperature T[N_rad] "Solid material temperature";
   input ClaRa.Basics.Units.InternalEnergy U[N_rad] "Internal energy";
   input ClaRa.Basics.Units.HeatFlowRate Q_flow[N_rad+1] "Heat flow through material";
   input ClaRa.Basics.Units.Area A_heat[N_A_heat];
   input ClaRa.Basics.Units.Length radius_m[N_A_heat];
   input ClaRa.Basics.Units.Length radius_v[N_rad+2] "Radial position of the volume elements";
   input ClaRa.Basics.Units.Mass mass;
    input ClaRa.Basics.Units.HeatCapacityMassSpecific cp[N_rad] "Specific heat capacity";
    input ClaRa.Basics.Units.DensityMassSpecific d[N_rad] "Material density";
 end Summary;

Summary summary(N_rad=N_rad, N_A_heat=N_A_heat, diameter_o=diameter_o, diameter_i=diameter_i, length=length, N_tubes=N_tubes, Delta_radius=Delta_radius, radius=radius, T=T, U=U, Q_flow=Q_flow, A_heat=A_heat, radius_m=radius_m, radius_v=radius_v,mass=mass, cp=solid.cp, d=solid.d);

equation
//symmetric discretization
      if sizefunc>=0 then
        Delta_radius ={(diameter_o-diameter_i)/2*i^sizefunc for i in 1:N_rad}/sum({i^sizefunc for i in 1:N_rad});
      else
        Delta_radius ={(diameter_o-diameter_i)/2*(N_rad+1-i)^(-sizefunc) for i in 1:N_rad}/sum({i^(-sizefunc) for i in 1:N_rad});
    end if;
  assert(diameter_o>diameter_i,"Outer diameter of tubes must be greater than inner diameter");

// Definition of the control volumes:
  radius[1]=diameter_i/2;
  for i in 2:N_rad+1 loop
    radius[i]=radius[i-1]+Delta_radius[i-1];
  end for;

  radius_v[1]=radius[1];
  radius_v[N_rad+2]=diameter_o/2;
  for i in 2:N_rad+1 loop
    radius_v[i]= radius[i-1]+Delta_radius[i-1]/2;
  end for;

  for i in 1:N_A_heat loop
     A_heat[i]=radius_m[i]*2*Modelica.Constants.pi*length*N_tubes;
  end for;

 // Energy balacce:
   for i in 1: N_rad loop
     U[i]=(mass_struc/N_rad*solid[i].cp+solid[i].cp*solid[i].d * Modelica.Constants.pi*(radius[i+1]^2-radius[i]^2) * length *N_tubes) * T[i];
     der(U[i]) = Q_flow[i]-Q_flow[i+1];
   end for;
// boundary conditions:
  innerPhase.Q_flow =  Q_flow[1];
  outerPhase.Q_flow = -Q_flow[N_rad+1];

//Calculate logarithmic mean temperature
  for i in 2:N_rad loop
    Tdr[i] = radius_v[i+1]*T[i]-radius_v[i]*T[i-1] -(T[i]-T[i-1])*(radius_v[i+1]-radius_v[i])/log(radius_v[i+1]/radius_v[i]);
  end for;
  Tdr[1] = radius_v[2]*T[1]-radius_v[1]*innerPhase.T -(T[1]-innerPhase.T)*(radius_v[2]-radius_v[1])/log(radius_v[2]/radius_v[1]);
  Tdr[N_rad+1] = radius_v[N_rad+2]*outerPhase.T-radius_v[N_rad+1]*T[N_rad] -(outerPhase.T-T[N_rad])*(radius_v[N_rad+2]-radius_v[N_rad+1])/log(radius_v[N_rad+2]/radius_v[N_rad+1]);
  T_mean=sum(Tdr)/((diameter_o-diameter_i)/2);
   //effective radii for heat conduction
   for i in 1:N_rad loop
    radius_m[2*i-1]=(radius_v[i+1]-radius[i])/Modelica.Math.log(radius_v[i+1]/radius[i]);
    radius_m[2*i]=(radius[i+1]-radius_v[i+1])/Modelica.Math.log(radius[i+1]/radius_v[i+1]);
   end for;

   //Heat conduction according to Fourier. The A_heat[i] are computed in base class from radius_m[i]
   Q_flow[1]  =solid[1].lambda*CF_lambda*2/Delta_radius[1] * A_heat[1] * (innerPhase.T-T[1]);
   Q_flow[N_rad+1]=solid[N_rad].lambda*CF_lambda*2/Delta_radius[N_rad] * A_heat[2*N_rad] * (T[N_rad]-outerPhase.T);
   for i in 2:N_rad loop
     Q_flow[i]= 2*(solid[i].lambda*CF_lambda*A_heat[2*i-1] * solid[i-1].lambda*CF_lambda*A_heat[2*i-2])
           /(solid[i-1].lambda*CF_lambda*Delta_radius[i]*A_heat[2*i-2] + solid[i].lambda*CF_lambda*Delta_radius[i-1]*A_heat[2*i-1]) * (T[i-1]-T[i]);
   end for;

   //Conductive heat resistance of the wall material
   HR = sum(HR_rad);
   for i in 1:N_rad loop
     HR_rad[i] = Delta_radius[i]/(solid[i].lambda*A_heat_m_rad[i]);
     A_heat_m_rad[i] = 2*Modelica.Constants.pi*length*N_tubes*(radius[i+1] - radius[i]) / log(radius[i+1]/radius[i]);
   end for;

initial equation
   if initOption == 1 then //steady state
     der(U)=zeros(N_rad);
   elseif initOption == 203 then //steady temperature
     der(T)=zeros(N_rad);
   elseif initOption == 0 then //no init
     T=T_start; // fixed temperature
   elseif initOption == 213 then // fixed temperature
     T=T_start;
   else
    assert(initOption == 0,"Invalid init option");
   end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-75},
            {100,75}}),
                   graphics), Documentation(info="<html>
<p>A_heat cylinder that:</p>
<p><ul>
<li>involves heat conduction and heat storage</li>
<li>only temperature-independent material data</li>
<li>allows equidistant and single-side refined dicretisation schemes</li>
<li>uses a second order discretisation for the spacial derivation</li>
<li>comprehends both, full cylinders and hollow cylinders</li>
</ul></p>
<p><br/>This model is validated against Fischer et. al &QUOT;Taschenbuch der technischen Formeln&QUOT;, pp 313-314. see test case <a href=\"ClaRa.Components.ThermalElements.TestThermalElements.testCylinder\">testCylinder</a> </p>
<p><br/>Contact: Johannes Brunnemann, Frierich Gottelt, XRG Simulation GmbH</p>
</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-07-14: Initial implementation. Friedrich Gottelt, Johannes Brunnemann, XRG Simulation GmbH</li>
</ul></p>
</html>"),
    Diagram(graphics));
end CylindricalThickWall_L4;
