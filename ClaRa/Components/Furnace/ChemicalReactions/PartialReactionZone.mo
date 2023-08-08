within ClaRa.Components.Furnace.ChemicalReactions;
partial model PartialReactionZone "Model to regard chemical reactions"
  extends ClaRa.Basics.Icons.Box;

parameter TILMedia.GasTypes.BaseGas flueGas;
parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel;


  input ClaRa.Basics.Units.MassFraction elementaryComposition_fuel_in[fuelModel.N_e - 1];
  ClaRa.Basics.Units.MassFraction prod_comp[flueGas.nc - 1] "Resulting composition of products";


//_________/Educts\__________________
protected
  Modelica.SIunits.AmountOfSubstance n_C "Amount of elemental carbon inside 1 kg of coal";
  Modelica.SIunits.AmountOfSubstance n_H "Amount of elemental hydrogen inside 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_O "Amount of elemental oxygen inside 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_N "Amount of elemental nitrogen inside 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_S "Amount of elemental sulfur inside 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_Ash "Amount of ash inside 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_H2O "Amount of water inside 1 kg of coal";

//_________/Products\__________________
Modelica.SIunits.AmountOfSubstance n_CO "Amount of carbon monoxide produced by 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_CO2 "Amount of carbon dioxide produced by 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_H2O_prod "Amount of water produced by 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_SO2 "Amount of sulfur dioxide produced by 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_N2 "Amount of nitrogen produced by 1 kg of coal";
Modelica.SIunits.AmountOfSubstance n_NO "Amount of nitric oxides produced by 1 kg of coal";

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                   graphics={
                       Text(
          extent={{-58,12},{62,-8}},
          lineColor={0,131,169},
          textString="Reaction Zone",
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));

end PartialReactionZone;
