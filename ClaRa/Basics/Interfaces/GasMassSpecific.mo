within ClaRa.Basics.Interfaces;
connector GasMassSpecific "A connector featuring T,p,X,m_dot"

  TILMedia.GasTypes.BaseGas                 Medium "Medium model";

  flow Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  Modelica.SIunits.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Modelica.SIunits.Temperature  T_outflow "Temperature close to the connection point if m_flow < 0";
  stream Modelica.SIunits.MassFraction xi_outflow[Medium.nc-1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";

end GasMassSpecific;
