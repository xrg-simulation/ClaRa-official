within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Transport_Velocity;
model Transport_complex "Coal transport velocity depending on pile friction angle"
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

  extends Transport_base;

protected
  parameter Real coeff_slope = 0.5 "0.3 ... 0.8";  // for a chosen base value of selection s0 use this coeff_slope to "strech" the shape of m_flow-curve to burner following a step on the conveyor
  parameter ClaRa.Basics.Units.Length delta_radius = iCom.radius_table/n "width of circular ring element";
  parameter Integer n = iCom.n;
public
  parameter ClaRa.Basics.Units.Angle alpha_start_vec[n-1] = alpha_start * linspace(1,0.7,n-1) "";

  ClaRa.Basics.Units.Length delta_height[n-1] "height of (i)th transported volume element";
  ClaRa.Basics.Units.Angle alpha[n-1](start = alpha_start_vec,fixed=true) "angle auf coal pile between two ring elements";
  ClaRa.Basics.Units.Velocity w_r[n] "radial transport velocity of coal on table due to pile angle";
  ClaRa.Basics.Units.Angle delta_height_crit;

equation

  tan(alpha_crit) = delta_height_crit/delta_radius;

  for i in 1:n-1 loop

    delta_height[i] = iCom.height_sum[i] - iCom.height_sum[i+1];
    tan(alpha[i]) = delta_height[i]/delta_radius;

    w_r[i] = coeff_slope * max(0,delta_height[i] - delta_height_crit) / delta_radius;

  end for;

  //define remaining elements
  w_r[n] = w_r[n-1];

end Transport_complex;
