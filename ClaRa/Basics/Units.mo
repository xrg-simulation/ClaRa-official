within ClaRa.Basics;
package Units
//___________________________________________________________________________//
// Package of the ClaRa library, version: 1.3.1                              //
// Models of the ClaRa library are tested under DYMOLA v2018 FD01.           //
// It is planned to support alternative Simulators like SimulationX in the   //
// future                                                                    //
//___________________________________________________________________________//
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2018, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// This Modelica package is free software and the use is completely at your  //
// own risk; it can be redistributed and/or modified under the terms of the  //
// Modelica License 2. For license conditions (including the disclaimer of   //
// warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
// http://www.modelica.org/licenses/ModelicaLicense2                         //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.Icons.PackageIcons.Basics80;
  type AbsolutePressure = Real(final quantity= "PressureDifference", final unit="Pa", displayUnit="Pa", nominal= 1e5, min=0);
  type Angle = Real(final quantity= "Angle", final unit="rad", displayUnit="deg", nominal= Modelica.Constants.pi);
  type AngularVelocity = Real (final quantity="AngularVelocity", final unit="rad/s");
  type Area = Real(final quantity= "Area", final unit="m2", displayUnit="m2", nominal= 1, min=0);
  type AreaFraction = Real(final quantity= "AreaFraction", final unit="m2/m2", displayUnit="m2/m2", nominal= 1, min=0);
  type CoefficientOfHeatTransfer = Real(final quantity= "CoefficientOfHeatTransfer", final unit="W/(m2.K)", displayUnit="W/(m2.K)", nominal= 1, min=0);
  type DerivativeOfDensityMassSpecific = Real(final quantity= "DerivativeOfDensityVolumeSpecific", final unit="kg/(m3.s)", displayUnit="kg/(m3.s)", nominal= 1);
  type DensityMassSpecific = Real(final quantity= "DensityVolumeSpecific", final unit="kg/m3", displayUnit="kg/m3", nominal= 1000,min=0);
  type DensityMolSpecific = Real(final quantity= "DensityMolSpecific", final unit="mol/m3", displayUnit="mol/m3", nominal= 50,min=0);
  type DensityVolumeSpecific=Real(final quantity= "DensityVolumeSpecific", final unit="kg/m3", displayUnit="kg/m3", nominal= 1000,min=0);
  type DynamicViscosity = Real (final quantity="DynamicViscosity", final unit="Pa.s",      min=0);
  type Efficiency = Real(final quantity= "Efficiency", final unit="1", displayUnit="1", nominal= 1,min=0);
  type ElasticityModule = Real ( final quantity="ElasticityModule", final unit="Pa", displayUnit="Pa", nominal=1e11);
  type ElectricCurrent = Real(final quantity= "Current", final unit="A", displayUnit="A", nominal= 1,min=0);
  type ElectricResistance = Real(final quantity= "Resistance", final unit="Ohm", displayUnit="Ohm", nominal= 1);
  type ElectricVoltage = Real(final quantity= "Voltage", final unit="V", displayUnit="V", nominal= 1);
  type Energy = Real(final quantity= "Energy", final unit="J", displayUnit="J", nominal= 1e3,min=0);
  type EnergyMassSpecific = Real(final quantity= "MassSpecificEnergy", final unit="J/kg", displayUnit="J/kg", nominal= 1e3,min=0);
  type Enthalpy = Real(final quantity= "Enthalpy", final unit="J", displayUnit="J", nominal= 1e5,min=0);
  type EnthalpyFlowRate = Real(final quantity= "EnthalpyFlowRate", final unit="W", displayUnit="W", nominal= 1e5);
  type EnthalpyVolumeSpecific = Real(final quantity= "VolumeSpecificEnthalpy", final unit="J/m3", displayUnit="J/m3", nominal= 1e5,min=0);
  type EnthalpyMassSpecific = Real(final quantity= "MassSpecificEnthalpy", final unit="J/kg", displayUnit="J/kg", nominal= 1e3);
  type EnthalpyMolSpecific = Real(final quantity= "MolSpecificEnthalpy", final unit="J/mol", displayUnit="J/mol", nominal= 1e3,min=0);
  type EntropyMassSpecific = Real(final quantity= "MassSpecificEntropy", final unit="J/(kg.K)", displayUnit="J/(kg.K)", nominal= 1e3,min=0);
  type EntropyFlowRate =     Real(final quantity= "EntropyFlowRate", final unit="J/(K.s)", displayUnit="J/(K.s)");
  type Force = Real(final quantity= "Force", final unit="N", displayUnit="N", nominal=1);
  type Frequency = Real(final quantity= "Frequency", final unit="1/s", displayUnit="1/min", nominal= 1000);
  type HeatCapacityFlowRate = Real(final quantity= "HeatCapacityFlow", final unit="W/(K)", displayUnit="W/(K)", nominal= 1e3);
  type HeatCapacityMassSpecific = Real(final quantity= "SpecificHeatCapacity", final unit="J/(kg.K)", displayUnit="J/(kg.K)", nominal= 1e3);
  type HeatExpansionRateLinear = Real (final quantity="HeatExpansionRateLinear", final unit="1/K", displayUnit="1/K", nominal=1e-6);
  type HeatFlowRate = Real(final quantity= "Power", final unit="W", displayUnit="W", nominal= 1e5);
  type HeatFlux = Real(final quantity= "HeatFlux", final unit="W/m2", displayUnit="W/m2", nominal= 1e5);
  type InternalEnergy = Energy;
  type Inductance = Real (final quantity="Inductance",final unit="H");
  type KinematicViscosity = Real (final quantity="KinematicViscosity", final unit="m2/s", min=0);
  type Length = Real(final quantity= "Length", final unit="m", displayUnit="m", nominal= 1);
  type MassFlowDensity = Real(final quantity= "MassFlowDensity", final unit="kg/(m2.s)", displayUnit="kg/(m2.s)", nominal=1);
  type Mass =         Real(final quantity= "Mass", final unit="kg", displayUnit="kg", nominal=1, min=0);
  type MassFlowRate = Real(final quantity= "MassFlowRate", final unit="kg/s", displayUnit="kg/s", nominal=1);
  type MassFlux = Real(final quantity= "MassFlux", final unit="kg/(m2.s)", displayUnit="kg/(m^2.s)", nominal=1);
  type MassFraction = Real(final quantity= "MassFraction", final unit="kg/kg", displayUnit="kg/kg", nominal=1, min=0);
  type MassFraction_ppm =  Real(final quantity= "MassFraction", final unit="ug/kg", displayUnit="ug/kg", nominal=1, min=0);
  type MolFraction = Real(final quantity= "MassFraction", final unit="kg/kg", displayUnit="kg/kg", nominal=1, min=0);
  type MolarMass =   Real(final quantity= "MolarMass", final unit="kg/mol", displayUnit="kg/mol", nominal=1, min=0);
  type Momentum =    Real(final quantity= "Momentum", final unit="kg.m/s", displayUnit="kg.m/s", nominal=1);
  type MomentumFlowRate = Real(final quantity= "MomentumFlowRate", final unit="kg.m/s2", displayUnit="N", nominal=1);
  type MomentOfInertia = Real (final quantity="MomentOfInertia", final unit="kg.m2");
  type NusseltNumber = Real(final quantity= "NusseltNumber", final unit="1", displayUnit="1");
  type Power = Real(final quantity= "Power", final unit="W", displayUnit="W", nominal= 1e5);
  type PrandtlNumber = Real(final quantity= "PrandtlNumber", final unit="1", displayUnit="1");
  type Pressure = Real(final quantity= "Pressure", final unit="Pa", displayUnit="Pa", nominal= 1e5, min=0);
  type PressureDifference = Real(final quantity= "PressureDifference", final unit="Pa", displayUnit="Pa", nominal= 0);
  type RelativeHumidity = Real(final quantity= "RelativeHumidity", final unit="1", displayUnit="1", nominal= 0, min=0);
  type RPM = Real(final quantity= "RotationsPerMinute", final unit="1/min", displayUnit="rpm", nominal= 0);
  type ReynoldsNumber = Real(final quantity= "ReynoldsNumber", final unit="1", displayUnit="1");
  type ShearModulus =     Real ( final quantity="ShearModulus", final unit="Pa", displayUnit="Pa", nominal=1e11);
  type Stress = Real ( final quantity="Stress", final unit="Pa", displayUnit="Pa", nominal=1e11);
  type SurfaceTension = Real ( final quantity="SurfaceTension", final unit="kg/s2", displayUnit="kg/s2", nominal=1e-3);
  type ThermalConductivity = Real (final quantity="ThermalConductivity", final unit="W/(m.K)");
  type Temperature = Real(final quantity= "Temperature", final unit="K", min=0, displayUnit="K") "Absolute thermodynamic temperature";
  type TemperatureDifference = Real(final quantity= "TemperatureDifference", final unit="K", start=0, displayUnit="K") "Temperature diference";
  type Temperature_DegC =   Real(final quantity= "Temperature",  final unit="degC",displayUnit="degC",  min=-273.15, start=20) "Temperature in degree Celsius";
  type Torque = Real(final quantity= "Torque", final unit="N.m", displayUnit="N.m", nominal=1);
  type Time =  Real(final quantity= "Time", final unit="s", displayUnit="s", nominal= 1);
  type Velocity = Real(final quantity= "Velocity", final unit="m/s", displayUnit="m/s", nominal= 1);
  type Volume = Real(final quantity= "Volume", final unit="m3", displayUnit="m3", nominal= 1, min=0);
  type VolumeFlowRate = Real(final quantity= "VolumeFlowRate", final unit="m3/s", displayUnit="m3/s", nominal= 1);
  type VolumeFraction = Real(final quantity= "VolumeFraction", final unit="m3/m3", displayUnit="m3/m3", nominal=1, max=1, min=0);
  type VolumeMassSpecific = Real(final quantity= "MassSpecificVolume", final unit="m3/kg", displayUnit="m3/kg", nominal= 1/1000,min=0);
  type VolumeMolSpecific =  Real(final quantity= "MolSpecificVolume", final unit="m3/mol", displayUnit="m3/mol", nominal= 1/50,min=0);
  type Voltage =Real(final quantity = "Voltage", final unit = "V", displayUnit="V");
end Units;
