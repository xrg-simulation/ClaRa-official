within ClaRa.Basics.Interfaces;
connector FluidPortIn

  TILMedia.VLEFluidTypes.BaseVLEFluid  Medium "Medium model";
public
  flow Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  Modelica.SIunits.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Modelica.SIunits.SpecificEnthalpy h_outflow "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
  stream Modelica.SIunits.MassFraction xi_outflow[Medium.nc-1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  annotation (Icon(graphics={             Ellipse(
          extent={{-100,100},{100,-100}},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Solid,
          lineColor={0,131,169},
          lineThickness=0.5)}));
end FluidPortIn;
