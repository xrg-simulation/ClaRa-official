within ClaRa.Components.BoundaryConditions;
model BoundaryElectricFrequency
  extends ClaRa.Basics.Icons.FlowSink;

  parameter Boolean variable_f = false "True, if frequency defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter ClaRa.Basics.Units.Frequency f_const = 50 "Constant frequency"  annotation(Dialog(group="Constant Boundaries", enable= not variable_p));

protected
  ClaRa.Basics.Units.Frequency f_in;
public
  outer ClaRa.SimCenter simCenter;
  Basics.Interfaces.ElectricPortIn electricPortIn annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput f(value=f_in) if (variable_f) "Variable fequency"
                                                                                        annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
equation
  if (not variable_f) then
    f_in = f_const;
  end if;
  electricPortIn.f = f_in;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end BoundaryElectricFrequency;
