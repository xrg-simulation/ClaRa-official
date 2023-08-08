within ClaRa.Components.VolumesValvesFittings.Fittings;
model SplitFuel_L1_flex "A voluminous split for an arbitrary number of inputs NOT CAPABLE FOR PHASE-CHANGE"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.3.0                            //
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

//  extends ClaRa.Basics.Interfaces.DataInterfaceVector(N_sets=N_ports_out);
  extends ClaRa.Basics.Icons.Adapter5_fw;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  outer ClaRa.SimCenter simCenter;



  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer N_ports_out(min=1)=1 "Number of outlet  ports" annotation(Evaluate=true, Dialog(tab="General",group="Fundamental Definitions"));//connectorSizing=true,
  parameter Real K_split[N_ports_out-1] = fill(0, N_ports_out-1) "fixed split ratio" annotation(Dialog(tab="General",group="Fundamental Definitions"));


  Basics.Interfaces.Fuel_inlet        inlet(fuelModel=fuelModel)               "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.Fuel_outlet        outlet[N_ports_out](each fuelModel=fuelModel)                    "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  for i in 1:N_ports_out-1 loop
    outlet[i].T_outflow = inStream(inlet.T_outflow);
    outlet[i].m_flow = -K_split[i]*inlet.m_flow;
    outlet[i].xi_outflow = inStream(inlet.xi_outflow);

  end for;
    outlet[N_ports_out].T_outflow = inStream(inlet.T_outflow);
    outlet[N_ports_out].m_flow = -(1-sum( K_split))*inlet.m_flow;
     outlet[N_ports_out].xi_outflow = inStream(inlet.xi_outflow);


     inlet.p = outlet[1].p;
    inlet.T_outflow=1000; // dummy, backflow is not supported
     inlet.xi_outflow = fuelModel.defaultComposition; // dummy, backflow is not supported;





  annotation (Icon(graphics), Diagram(graphics));
end SplitFuel_L1_flex;
