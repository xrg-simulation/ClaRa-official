within TILMedia.SolidTypes;
model TILMedia_Steel "TILMedia.Steel"
  extends TILMedia.SolidTypes.BaseSolid(
    final d = 7800.0,
    final cp_nominal = 490.0,
    final lambda_nominal = 40.0,
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);
equation
  cp=cp_nominal;
  lambda=lambda_nominal;
  nu = nu_nominal;
  E = E_nominal;
  G=G_nominal;
  beta = beta_nominal;
end TILMedia_Steel;
