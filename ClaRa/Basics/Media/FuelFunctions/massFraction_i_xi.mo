within ClaRa.Basics.Media.FuelFunctions;
function massFraction_i_xi "Elementary composition as function of fuel xi"
  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition of fuel";
   input Integer compNo "Component number";
   input ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";

  output ClaRa.Basics.Units.MassFraction xi_element "Composition of elements";

protected
  ClaRa.Basics.Units.MassFraction xi_elements[fuelType.N_e - 1];
algorithm
     xi_elements:=zeros(fuelType.N_e - 1);
   if fuelType.N_c==fuelType.N_e then
     xi_elements :=xi_c;
   else

     for i in 1:fuelType.N_e-3 loop
       for j in 1: fuelType.N_c-2 loop
         xi_elements[i] := xi_elements[i] + xi_c[j].* fuelType.xi_e_waf[j,i];
       end for;
     end for;
     for j in 1: fuelType.N_c-2 loop
       xi_elements[fuelType.N_e-2] := xi_elements[fuelType.N_e-2] +  xi_c[j] .* (1 - sum(fuelType.xi_e_waf[j, :]));
     end for;
     xi_elements[fuelType.N_e-1]:=ashMassFraction_xi(xi_c, fuelType);
   end if;
   xi_element :=xi_elements[compNo];
end massFraction_i_xi;
