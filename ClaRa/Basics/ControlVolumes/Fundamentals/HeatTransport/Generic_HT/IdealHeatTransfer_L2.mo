within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model IdealHeatTransfer_L2 "All Geo || L2 || Ideal Heat Transfer"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.HeatTransferGas;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectiveHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.RadiantHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Special.SpecialHeatTransfer;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
  outer ClaRa.Basics.Records.IComBase_L2 iCom;
  constant Modelica.SIunits.CoefficientOfHeatTransfer alpha=Modelica.Constants.inf;

  //  final parameter ClaRa.Basics.Units.Area A_heat=1 "Heat transfer surface";
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

equation
  heat.T = iCom.T_bulk;

  annotation (Diagram(graphics));
end IdealHeatTransfer_L2;
