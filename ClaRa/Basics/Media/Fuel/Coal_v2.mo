within ClaRa.Basics.Media.Fuel;
record Coal_v2 " {C,H,O,N,S,Ash,H2O} a coal with 6.8 percent of water"
 extends ClaRa.Basics.Media.Fuel.PartialFuel(
    final nc=7,
    final cp=1278,
    final defaultComposition={0.732,0.05,0.05,0.05,0.025,0.025}); //LHV=29e6
                                                                // cp is identified uying the hard coal mill validation scenario by
 // Piotr Niemczyk and Palle Andersen, Jan Dimon Bendtsen, Tom Sndergaard Pedersen, Anders Peter Ravn: "Derivation and validation of a coal mill model for control",
 // IFAC Symposium for Power Plant Simulation and Control, Tampere, Finland, 2009.

end Coal_v2;
