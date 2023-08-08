within ClaRa_Obsolete.Basics.Functions.TableInterpolation;
function tableIpo "Interpolate 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
  input Integer tableID;
  input Integer icol;
  input Real u;
  output Real value;
external "C" value=ModelicaTables_CombiTable1D_interpolate(tableID, icol, u);
  annotation(Library="ModelicaExternalC");
end tableIpo;
