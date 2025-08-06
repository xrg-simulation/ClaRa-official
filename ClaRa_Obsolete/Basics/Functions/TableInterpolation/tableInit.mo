within ClaRa_Obsolete.Basics.Functions.TableInterpolation;
function tableInit "Initialize 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
  input String tableName;
  input String fileName;
  input Real table[ :, :];
  input Modelica.Blocks.Types.Smoothness smoothness;
  output Integer tableID;
external "C" tableID = ModelicaTables_CombiTable1D_init(
               tableName, fileName, table, size(table, 1), size(table, 2),
               smoothness);
  annotation(Library="ModelicaExternalC");
end tableInit;
