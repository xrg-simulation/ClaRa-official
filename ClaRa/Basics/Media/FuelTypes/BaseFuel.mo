within ClaRa.Basics.Media.FuelTypes;
record BaseFuel "Chose fuel below:"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.7.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
  // Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Media.FuelTypes.EmptyFuel;
  extends ClaRa.Basics.Icons.RecordIcon;
  constant Integer N_c=5 "Number of components";
  constant Integer N_e=5 "Number of elements";
  parameter Real C_LHV[N_c] = {1,1,1,1,1} "Coefficients for LHV calculation";
  parameter Real C_cp[N_c] = {1,1,1,1,1} "Coefficients for cp calculation";
  constant Real C_rho[N_c] = {1,1,1,1,1} "Coefficients for rho calculation";
  constant Integer waterIndex "Index of water in composition";
  constant Integer ashIndex "Index of ash in composition";
  constant ClaRa.Basics.Units.MassFraction defaultComposition[N_c - 1] "Elemental compostion of combustible, e.g. {C,H,O,N,S, H2O, ash}";
  parameter ClaRa.Basics.Units.MassFraction xi_e_waf[:,:] "water and ash free elementary composition of the two pure fuels";
  constant ClaRa.Basics.Units.Temperature T_ref=273.15 "Reference temperature";
  //
      annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end BaseFuel;
