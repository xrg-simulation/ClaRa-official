within ClaRa.Basics.Functions;
function SmoothZeroTransition "Ensure a smooth transition from y(x<0) to y(x>0) with linear behaviour around x=0"
  extends ClaRa.Basics.Icons.Function;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  input Real posValue "Value for x > eps";
  input Real negValue "Value for x < -eps";
  input Real x "Input for evaluation";
  input Real eps=1e-4 "Linearisation between -eps and +eps";
  output Real result "Output of evaluation";
algorithm
  result := SM( eps,-eps, x)*posValue
     + SM(-eps, eps, x)*negValue;
end SmoothZeroTransition;
