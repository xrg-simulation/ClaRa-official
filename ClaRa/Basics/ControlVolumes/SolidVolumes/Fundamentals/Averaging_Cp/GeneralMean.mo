within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp;
partial model GeneralMean "Base class for mean value calculation"

  outer ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3 iCom;
  SI.HeatCapacityMassSpecific cp_i[3];
  SI.HeatCapacityMassSpecific cp_o[3];
end GeneralMean;
