within ClaRa.Basics.Icons;
model ChemicalReactions

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),     Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/Resources/Images/Components/ChemicalReactions.png")}));

end ChemicalReactions;