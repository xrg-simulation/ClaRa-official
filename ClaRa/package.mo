within ;
package ClaRa "Simulation of Clausius-Rankine Cycles"
  extends ClaRa.Basics.Icons.PackageIcons.ClaRab100;
  import SI = ClaRa.Basics.Units;
























  annotation (preferedView="info",version="1.4.0",
                           uses(
      ClaRa_Obsolete(version="1.4.0"),
    TILMedia(version="1.4.0 ClaRa"),
    Modelica(version="3.2.2")),  Icon(graphics,
                                      coordinateSystem(preserveAspectRatio=
          false, extent={{-100,-100},{100,100}})),
  conversion(from(version="0.0",to="0.1 alpha",  script="modelica://ClaRa/Resources/Scripts/ConvertFrom000.mos"),
    from(version="0.1 alpha",to="0.2 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom010.mos"),
    from(version="0.2 alpha",to="0.2.1 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom020.mos"),
    from(version="0.2.1 alpha",to="0.2.2 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom021.mos"),
    from(version="0.2.2 alpha",to="1.0.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom022.mos"),
    from(version="1.0.1",to="1.1.2", script="modelica://ClaRa/Resources/Scripts/ConvertFrom101.mos"),
    from(version="1.1.2",to="1.2.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom112_to_121.mos"),
    from(version="1.2.1",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.2.2",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.2.3",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.3.1",to="1.4.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom131_to_140.mos")),
  Documentation(info="<html>
<p><img src=\"modelica://ClaRa/Resources/Images/ClaRaLibraryInfo.png\"/></p>
</html>"));
end ClaRa;
