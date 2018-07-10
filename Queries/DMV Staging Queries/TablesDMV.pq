let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_TABLES"]),
    RenameColumns = Table.RenameColumns(Source,{{"Name", "Table Name"}, {"Description", "Table Description"}}),
    ColumnTypes = Table.TransformColumnTypes(RenameColumns,{{"ID", Int64.Type}, {"DefaultDetailRowsDefinitionID", Int64.Type}, {"TableStorageID", Int64.Type}, {"ModelID", Int64.Type}})
in
    ColumnTypes