within ClaRa.Basics.Interfaces;
model CycleSummaryPort
  Real mass_fluid=vleFluidPort.mass_fluid;
  ClaRa.Basics.Interfaces.vleFluidMassPort vleFluidPort;
end CycleSummaryPort;
