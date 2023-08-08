within ClaRa.Components.Electrical.Check;
model TestAsynchronousMotorWithPump
 extends ClaRa.Components.TurboMachines.Pumps.Check.TestPump_L1_WithEMotor;
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    experiment(
      StopTime=500,
      __Dymola_NumberOfIntervals=1001,
      Tolerance=1e-006));
end TestAsynchronousMotorWithPump;
