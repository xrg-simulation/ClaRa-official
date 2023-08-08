within ClaRa.Basics.Choices;
type Position = enumeration(
    TopLeft "Top left",
    TopMid "Top middle",
    TopRight "Top right",
    BotRight "Bottom right") "The position of a connector , e.g. top left or bottom right"
                                                                annotation (
    Icon(graphics={Polygon(
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
