within ClaRa.StaticCycles.Check;
model TestStacy7

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2024, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.InitSteamCycle_T_4_Pr_F1_C1 staCy annotation (Placement(transformation(extent={{-80,-80},{80,80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  annotation (experiment(StopTime=2, method="dassl"),
              Diagram(graphics,
                      coordinateSystem(initialScale=0.1)), Icon(graphics,
                                                                coordinateSystem(initialScale=0.1)));
end TestStacy7;
