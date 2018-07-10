let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_DATA_SOURCES"]),
    RemoveCols = Table.RemoveColumns(Source,{"ID", "ModelID", "Description", "Account", "Password"}),
    ColRename = Table.RenameColumns(RemoveCols,{{"Name", "Data Source Name"},{"ConnectionString", "Connection String"}, {"Type", "Data Source Type"}, {"ImpersonationMode", "Impersonation Mode"}, {"Credential", "Data Source Credential"}, {"ContextExpression", "Context Expression"}, {"ConnectionDetails", "Connection Details"}, {"ModifiedTime", "Modified Time"}, {"MaxConnections", "Max Connections"}}),
    AddIndex = Table.AddIndexColumn(ColRename, "Data Source Index ID", 1, 1),
    ReorderCols = Table.ReorderColumns(AddIndex,{"Data Source Index ID", "Data Source Name", "Data Source Type", "Connection String", "Impersonation Mode", "Max Connections", "Isolation", "Timeout", "Provider", "Modified Time", "Connection Details", "Options", "Data Source Credential", "Context Expression"})
in
    ReorderCols