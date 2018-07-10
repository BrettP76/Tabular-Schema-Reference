let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.DBSCHEMA_CATALOGS"]),
    FilterByCatalog = Table.SelectRows(Source, each [CATALOG_NAME] = Database),
    RemoveColumns = Table.RemoveColumns(FilterByCatalog,{"DESCRIPTION", "TYPE", "VERSION", "DATABASE_ID", "DATE_QUERIED", "CURRENTLY_USED", "POPULARITY", "WEIGHTEDPOPULARITY"}),
    RenameColumns = Table.RenameColumns(RemoveColumns,
        {{"COMPATIBILITY_LEVEL", "Compatibility Level"}, 
         {"ROLES", "Database Roles"}, {"DATE_MODIFIED", "Last Modified"},
        {"CATALOG_NAME", "Database"}}),
    ServerColumn = Table.AddColumn(RenameColumns, "Server", each Server, type text),
    ColumnReorder = Table.ReorderColumns(ServerColumn,{"Server", "Database", "Database Roles", "Last Modified", "Compatibility Level"})
in
    ColumnReorder