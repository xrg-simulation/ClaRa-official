within ClaRa.Basics.Media.Fuel;
record Coal_v1 " {C,H,O,N,S,Ash,H2O}"
 extends ClaRa.Basics.Media.Fuel.PartialFuel(
    final nc=7,
    final cp=1260,
    final defaultComposition={0.8,0.05,0.05,0.05,0.025,0.025}); //LHV=29e6
end Coal_v1;
