﻿within TILMedia.Testers;
model TestSolid
  extends TILMedia.Internals.ClassTypes.ExampleModel;

  // This tester demonstrates the calclation of thermodynamic properties of carbon steel (St35.8)

  SI.Temperature T;

 //Instance of a Solid object that requires the Temperature T as input
  Solid solid(T=T, redeclare model SolidType =
        TILMedia.SolidTypes.TILMedia_St35_8)
              annotation (Placement(transformation(extent={{-20,0},{0,20}},
          rotation=0)));

equation
  T = 273.15 + 1000*time;

  annotation (experiment(StopTime=1));
end TestSolid;
