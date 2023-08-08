within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp;
model InputOnly "Use the 1st input instead of an average"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends GeneralMean;
  import vle_cp = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import gas_cp = TILMedia.GasObjectFunctions.specificIsobaricHeatCapacity_phxi;

  SI.HeatCapacityMassSpecific cp_i_in[3];
  SI.HeatCapacityMassSpecific cp_o_in[3];

equation
  if iCom.media[2] == "vle" then
    cp_i_in =  {vle_cp(iCom.p_i, iCom.h_i_in[i], iCom.xi_i, iCom.ptr_i_in[i]) for i in 1:3};
  else
    cp_i_in =  {gas_cp(iCom.p_i, iCom.h_i_in[i], iCom.xi_i, iCom.ptr_i_in[i]) for i in 1:3};
  end if;
  if iCom.media[1] == "vle" then
    cp_o_in =  {vle_cp(iCom.p_o, iCom.h_o_in[i], iCom.xi_o, iCom.ptr_o_in[i]) for i in 1:3};
  else
    cp_o_in =  {gas_cp(iCom.p_o, iCom.h_o_in[i], iCom.xi_o, iCom.ptr_o_in[i]) for i in 1:3};
  end if;
  cp_i = cp_i_in;
  cp_o = cp_o_in;
        annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end InputOnly;
