within ClaRa.Basics.Functions;
function CalculateStateChangeFraction "Calculate the fraction of state change in two-phase region to total state change"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_in "Inlet spec. enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Outlet spec.  enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_dew "Dew spec. enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_bub "Bubble spec. enthalpy";

  output Real yps_2ph "Fraction of state change in two-phase region";
  output Integer case;
algorithm
    if abs(h_in-h_out)<1e-3 then
          yps_2ph:=0;
          case:=0 "in=out";
    else
      if h_in < h_bub then //---------------------------------one point is liquid
        if h_out  < h_bub then //neighbour point is liquid
            yps_2ph:=0;
            case:=1 "liq - liq";
        elseif h_out > h_dew then //neighbour point is superheated
            yps_2ph :=min(1, max(0, abs((h_dew - h_bub)/(h_out - h_in))));
            case:=2 "liq - vap";
        else
            yps_2ph :=min(1, max(0, abs((h_out - h_bub)/(h_out - h_in))));
            case:=3 "liq - 2ph";
        end if;
      elseif  h_in >  h_dew then //----------------------------one point is superheated
        if h_out  < h_bub then //neighbour point is liquid
            yps_2ph:=min(1, max(0, abs((h_dew - h_bub)/(h_out - h_in))));
            case:=4 "vap - liq";
        elseif h_out > h_dew then //neighbour point is superheated
            yps_2ph:=0;
            case:=5 "vap - vap";
        else // neighbour point is two phase
            yps_2ph:=min(1, max(0, abs((h_out - h_dew)/(h_out - h_in))));
            case:=6 "vap - 2ph";
        end if;
      else //--------------------------------------------------------------one point is two phase
        if h_out < h_bub then //neighbour point is liquid
          yps_2ph :=min(1, max(0, abs((h_in - h_bub)/(h_out - h_in))));
          case:=7 "2ph - liq";
        elseif h_out > h_dew then //neighbour point is superheated
          yps_2ph:=min(1, max(0, abs((h_in - h_dew)/(h_out - h_in))));
          case:=8 "2ph - vap";
        else // neighbour point is two phase
          yps_2ph:=1;
          case:=9 "2ph - 2ph";
        end if;
      end if;
    end if;
end CalculateStateChangeFraction;
