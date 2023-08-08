within ClaRa.Basics.Functions;
function maxAbs "Returns signed maximum of the absolute input values"
  extends ClaRa.Basics.Icons.Function;
  input Real x1 "Real input 1";
  input Real x2 "Real input 2";
  input Real eps = 1e-6 "Linearisation region";
  output Real maxOfx1x2 "Output";
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
algorithm
  // if abs(x1) > abs(x2) then
  //   maxOfx1x2 := x1;
  // else
  //   maxOfx1x2 :=x2;
  // end if;
  maxOfx1x2 :=SZT(
    x1,
    x2,
    abs(x1) - abs(x2),
    eps);

end maxAbs;
