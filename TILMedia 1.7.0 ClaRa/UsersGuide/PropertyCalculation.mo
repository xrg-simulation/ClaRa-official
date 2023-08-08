﻿within TILMedia.UsersGuide;
class PropertyCalculation "Property Calculation"
  extends TILMedia.Internals.ClassTypes.Information;
    annotation(DocumentationClass=true,
     Documentation(info="<html><p>
     
     
The calculation of thermo-physical properties with the TILMedia Modelica interface is divided in five groups:
<br>
</p><ul>
  <li> <b>Gas</b> - Ideal gases and mixtures with one component that can condense - gas vapor</li>
  <li> <b>Liquid</b> - Incompressible single phase fluids and mixtures</li>
  <li> <b>VLEFluid</b> - Real fluid or fluid mixture, which can be liquid, vaporous, super-critical or may have a vapor-liquid equilibrium (VLE)</li>
  <li> <b>Solid</b> - Single phase solids</li>
  <li> <b>SLEMedium</b> - can be solid, liquid or may have a solid-liquid equilibrium (SLE)</li>
</ul>
<br>     
There are different options to calculate thermo-physical properties:
<br>
<ul>
  <li> <b>object-oriented</b> [recommended] - An external object is created and all properties are calculated at once (e.g. <a href=\"modelica://TILMedia.Testers.TestGas\">TestGas</a>, <a href=\"modelica://TILMedia.Testers.TestLiquid\">TestLiquid</a>, <a href=\"modelica://TILMedia.Testers.TestVLEFluid\">TestVLEFluid</a>). </li>
  <li> <b>function based</b> [for single evaluations only] - Only one property is calculated. Useful for parameter expressions such as start values. For efficient calculation of time-varying variable use objects or object functions.</li>
  <li> <b>objects with functions</b> [for conditional/additional properties] - The classes without inputs (<a href=\"modelica://TILMedia.Gas\">Gas</a>, <a href=\"modelica://TILMedia.Liquid\">Liquid</a> and <a href=\"modelica://TILMedia.VLEFluid\">VLEFluid</a>) can be used to calculate conditional or additional properties efficiently.</li>
  <li> <b>object functions</b> [for additional properties] - Using the pointer to an existing external object additional properties can be computed efficiently.</li>
</ul>
<br>
The use of functions, objects with functions and object functions is shown in the example: <a href=\"modelica://TILMedia.Testers.TestVLEFluidObjectFunctions\">TestVLEFluidObjectFunctions</a>.
Equivalent to the shown VLEFluid calculations are the use of Gas, Liquid and corresponding functions are possible.
<br>
The object-oriented calculation is recommended.
The Fluid properties are calculated with independent variables that are declared as input.
Depending on which variables are known, different classes are available with a corresponding ending:
<br>
<ul>
  <li> _ph pressure and enthalpy</li>
  <li> _ps pressure and entropy</li>
  <li> _pT pressure and temperature</li>
  <li> _dT density and temperature</li>
</ul>
<br>
The mass fraction vector is needed additionally, if the fluid is a mixture.
For more information see the models itself and the testers.
<br>
<br>
</html>"));
end PropertyCalculation;
