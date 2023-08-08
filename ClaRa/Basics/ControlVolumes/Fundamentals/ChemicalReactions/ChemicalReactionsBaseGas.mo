within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model ChemicalReactionsBaseGas "Gas || L2 || Chemical Reactions Base Class"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.4.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2019, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.ChemicalReactions;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;

  parameter Boolean use_signal;
  parameter Boolean use_dynamicMassbalance;
  constant Integer i "Number of separation mas flows involved";

  ClaRa.Basics.Units.HeatFlowRate Q_flow_reaction;
                                   //Reaction heat
  ClaRa.Basics.Units.MassFlowRate m_flow_reaction[i];
                                      //Mass flow of additional reaction components
  ClaRa.Basics.Units.MassFraction xi[iCom.mediumModel.nc - 1];
                                             //Cleansed composition
  ClaRa.Basics.Units.EnthalpyMassSpecific h_reaction[i];
  ClaRa.Basics.Units.MassFraction xi_aux[iCom.mediumModel.nc - 1];
  ClaRa.Basics.Units.MassFlowRate m_flow_aux;
  ClaRa.Basics.Units.EnthalpyMassSpecific h_aux;
  ClaRa.Basics.Units.Mass mass;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));

end ChemicalReactionsBaseGas;
