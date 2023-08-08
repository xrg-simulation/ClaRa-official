within ClaRa.Basics.Functions.ClaRaDelay;
function getDelayValuesAtTime
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.7.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  input ClaRa.Basics.Functions.ClaRaDelay.ExternalTable table;
  input Real simulationTime;
  input Real value;
  input Real getTime;
  output Real result;
  //annotation(derivative=getXRGDelayValuesAtTimes_der);
external"C" result = getXRGDelayValuesAtTime(table, simulationTime, value, getTime)
annotation (__iti_dll="ITI_Delay-V1.dll",Library={"Delay-V1","ModelicaExternalC"});
  // annotation (derivative(
  //     zeroDerivative=simulationTime,
  //     zeroDerivative=getTimes) = getXRGDelayValuesAtTimes_der);

end getDelayValuesAtTime;
