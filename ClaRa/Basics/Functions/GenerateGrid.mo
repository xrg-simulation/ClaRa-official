within ClaRa.Basics.Functions;
function GenerateGrid "Generate grid discretization from scale functions"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.3.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.Function;

  input Real SizeFunc[:] "array determining number and kind of different stretchings to be applied";
  input Real L "length in discretization direction";
  input Integer N "number of cells in grid";

  output Real dx[N] "resulting grid";

protected
  Integer N_sub "number of regions into which the grid shall be subdivided";
  Integer N_cv_sub[N]=zeros(N);
  //number of cells in each subdivision
  Integer offset "Offset for discretization interval used in computation of dx[N] by going through the subdivisions";
  //auxiliary variables......
  //Integer NextElem;
  Real remainder "Auxilliary variable: normalised remainder";
  Real normalConst "Auxilliary variable: normalising constant";

algorithm
  assert(L > 0, "Length of discretisation interval must be greater than zero!");

  N_sub := size(SizeFunc, 1);
  //get number of subdivisions.

  // /*----------get all size functions via a string---------------*/
  // //for now we use  Modelica.Utilities.Examples.expression here as string parser.
  // //Maybe we need to write our own in the mid term perspective?
  //   NumElem:=1;
  //   while NumElem<=N_sub loop
  //     (SizeFunc[NumElem],NextElem):=Modelica.Utilities.Examples.expression(SizeFuncString,startIndex=NextElem+1);
  //     NumElem:=NumElem+1;
  //   end while;

  /*-if too many subdivisions are used the scaling of each sub-interval becomes meaningless!------*/
  // assert(N_sub <= div(N, 2), "Number of subdivisions of grid exceeds N/2.
  // This makes any choice of stretching ineffective. Either lower the number of subdivisions of the grid or increase the number of grid cells!");

  /*----------compute the number of cells in each subdivision---------------*/
  remainder := 0;
  if N_sub == 1 then
    N_cv_sub[N_sub] := N;
  else
    for i in 1:N_sub - 1 loop
      remainder := remainder + rem(N, N_sub)/N_sub;
      if remainder > 0.5 then
        N_cv_sub[i] := div(N, N_sub) + 1;
        remainder := remainder - 1;
      else
        N_cv_sub[i] := div(N, N_sub);
      end if;
    end for;
    N_cv_sub[N_sub] := N;
    for i in 1:N_sub - 1 loop
      N_cv_sub[N_sub] := N_cv_sub[N_sub] - N_cv_sub[i];
    end for;
    //again the following gives problems during compilation..: -sum({N_cv_sub[i] for i in 1:N_sub-1});
    //need to check the algorithm further, in principle this could be integrated into one loop statement.
    //For now I leave it in this state, this ensures that no overcounting occurs due to rounding of numbers.
  end if;

  /*----------compute the length of the cells in each subdivision and write to dx[N]!---------------*/
  offset := 0;
  for i in 1:N_sub loop
    //go through every subdivision of the grid
    normalConst := 0;

    for k in 1:N_cv_sub[i] loop
      // somehow the usual normalConst:=sum({k^SizeFunc[i] for k in 1:N_cv_sub[i]}); gives an compiler error!
      normalConst := normalConst + k^abs(SizeFunc[i]);
    end for;

    if SizeFunc[i] >= 0 then

      for j in 1:N_cv_sub[i] loop
        dx[offset + j] := L/N_sub*(j^SizeFunc[i])/normalConst;
      end for;
    else
      for j in 1:N_cv_sub[i] loop
        dx[offset + j] := L/N_sub*(N_cv_sub[i] + 1 - j)^(-SizeFunc[i])/normalConst;
      end for;
    end if;
    offset := offset + N_cv_sub[i];
  end for;
  /*--enable the lines below for debugging purposes!-------------------------------------------------*/
  //   dx[1]:=N_cv_sub[1];
  //   dx[2]:=N_cv_sub[2];
  //   dx[3]:=N_sub;
  //   dx:=N_cv_sub;

  annotation (Documentation(info="<html>
<p><h4>This function computes the discretization of a given interval I of length L into N cells.  </h4></p>
<p> The input SizeFunc[:] consists of a vector of signed reals, e.g 
 {i_1,i_2,....,i_K}. The number K of reals corresponds to a subdivision of I into K subintervals I_K of length L/K.
 Accordingly every subinterval I_K contains (up to rounding) N/K cells. For each I_K the number i_K prescribes a distribution of cells. 
 Here i_K=0 corresponds to equidistant cell spacing, i_K &gt; 0 to increasing cell width from beginning to the end of I_K, i_K &lt; 
 0 to decreasing cell width from beginning to the end of I_K. The modulus |i_K| determines the stretching rate.  </p>
</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-08-12: Initial implementation. Johannes Brunnemann, XRG Simulation GmbH</li>
</ul></p>
</html>"));
end GenerateGrid;
