let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_MEASURES"]),
    ColumnRename = Table.RenameColumns(Source,{{"Name", "Measure Name"},{"Description", "Measure Description"}, 
    {"Expression", "DAX Expression"}, {"FormatString", "Format"}, {"DisplayFolder", "Display Folder"}}),
    ColTypes = Table.TransformColumnTypes(ColumnRename,{{"ID", Int64.Type}, {"TableID", Int64.Type}}),
    JoinToTables = Table.NestedJoin(ColTypes,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TableColumns = Table.ExpandTableColumn(JoinToTables, "Tables", {"Table Name", "Table Description"}, {"Table Name", "Table Description"})
   
in
    TableColumns