﻿within TILMedia;
package UsersGuide "User's Guide"
  extends TILMedia.Internals.ClassTypes.Information;


  annotation(__Dymola_DocumentationClass=true,
     Documentation(info="<html>
     
TILMedia Suite provides methods of calculation, which express thermo-physical properties of incompressible liquids, ideal gases as well as real fluids containing a vapor liquid equilibrium.
For gases and real fluids, mixtures may be created.
The mathematical equations of substance properties are optimized for stable and fast dynamic simulations of systems.
You may select substance data from different sources for your calculation:
<br>
<ul>
  <li> TLK developments: 62 substances</li>
  <li> External library REFPROP: 208 substances</li>
  <li> VDI Heat Atlas: 275 substances</li>
  <li> VDI-Guideline 4670: 10 substances</li>
  <li> External library CoolProp: 114 substances</li>
  <li> NASA Glenn Coefficients: 2024 substances</li>
</ul>
<br>
All available substances are listed in the User's Guide: <a href=\"Modelica:TILMedia.UsersGuide.SubstanceNames\">Substance Names</a>.
On demand it is also possible to get interpolated property data, which are faster than TILMedia and REFPROP data.
<br>
<br>
</html>"));
end UsersGuide;
