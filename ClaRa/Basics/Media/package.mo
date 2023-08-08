within ClaRa.Basics;
package Media "Media data (properties of air, water, steam, ...)"
//___________________________________________________________________________//
// Package of the ClaRa library, version: 1.4.0                              //
// Models of the ClaRa library are tested under DYMOLA v2019.           //
// It is planned to support alternative Simulators like SimulationX in the   //
// future                                                                    //
//___________________________________________________________________________//
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// This Modelica package is free software and the use is completely at your  //
// own risk; it can be redistributed and/or modified under the terms of the  //
// Modelica License 2. For license conditions (including the disclaimer of   //
// warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
// http://www.modelica.org/licenses/ModelicaLicense2                         //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//


  extends ClaRa.Basics.Icons.PackageIcons.Basics80;






annotation (Documentation(info="<html>
<p><h2><font color=\"#008000\">AP 2.6 Implementierung der bentigten Stoffdaten</font></h2></p>
<p>Ziel dieses Arbeitspaketes ist die Implementierung der f&uuml;r die Simulation aller anderen Kom-ponenten ben&ouml;tigten Stoffdaten in die zu erstellende ClaRa-Modelica-Bibliothek. Dabei geht es insbesondere darum, die relevanten physikalischen Effekte f&uuml;r den jeweiligen Teilbe-reich der Gesamtmodelle mit hinreichender Genauigkeit abzubilden. Gleichzeitig ist es not-wendig, einen transparenten und schnell rechnenden Programmecode zu erzeugen.</p>
<p>Zur Simulation des konventionellen Kraftwerksprozesses wird beispielsweise die genaue Abbildung der Stoffdaten von Wasser ben&ouml;tigt, um eine hinreichende Genauigkeit der Simu-lationsergebnisse f&uuml;r den Wasser-Dampfkreislauf zu gew&auml;hrleisten. Diese Stoffdaten sind zwar grunds&auml;tzlich vorhanden, m&uuml;ssen aber ggf. noch bzgl. Rechengeschwindigkeit optimiert und in die ClaRa-Modelica-Bibliothek eingebunden werden. In anderen Bereichen, wie der CO2-Rauchgasw&auml;sche, der Rauchgasseite des Kraftwerks oder der CO2-Aufreinigung werden neue Stoffdatenmodelle ben&ouml;tigt. Die Vielzahl vorhandener Modellen f&uuml;r die Berechnung von Stoffdaten macht die Auswahl eines ad&auml;quaten Ansatzes schwierig. Hierbei kann die Validierung der Modellergebnisse durch Literaturquellen unterst&uuml;tzt werden.</p>
</html>"));
end Media;
