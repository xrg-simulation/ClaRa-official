within ClaRa.Basics.Media.Solids;
model Fireclay "Fireclay material"
  //VDI Waermeatlas for 400°C
  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d = 2150.0,
    final cp_nominal = 956.0,
    final lambda_nominal = 1.05,
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);
equation
  cp=cp_nominal;
  lambda=lambda_nominal;
  nu = nu_nominal;
  E = E_nominal;
  G = G_nominal;
  beta = beta_nominal;
end Fireclay;
