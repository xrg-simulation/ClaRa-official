within ClaRa.Basics.Choices;
type FluidType = enumeration(
    Steam "Steam",
    Condensate "Condensate",
    FlueGas "Flue gas",
    FreshAir "Fresh air") "The expected fluid type like, steam, condensate, gas,..."
                                                             annotation (Icon(
      graphics={Polygon(
        points={{-100,100},{100,-100},{-100,100}},
        lineColor={255,0,0},
        smooth=Smooth.None,
        fillColor={102,198,0},
        fillPattern=FillPattern.Solid), Polygon(
        points={{-100,-100},{100,100},{-100,-100}},
        lineColor={255,0,0},
        smooth=Smooth.None,
        fillColor={102,198,0},
        fillPattern=FillPattern.Solid)}));
