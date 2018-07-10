let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.DISCOVER_STORAGE_TABLES"]),
    FilterSystemRows = Table.SelectRows(Source, each 
           Text.Range([TABLE_ID],1,1) <> "$"),
    RemoveCols = Table.SelectColumns(FilterSystemRows,{"DIMENSION_NAME", "TABLE_PARTITIONS_COUNT", "ROWS_COUNT"}),
    RenameCols = Table.RenameColumns(RemoveCols,{{"DIMENSION_NAME", "Table"}, {"TABLE_PARTITIONS_COUNT", "Partitions"}, {"ROWS_COUNT", "Rows"}}),
    SortByRowCount = Table.Sort(RenameCols,{{"Rows", Order.Descending}}),
    OrderCols = Table.ReorderColumns(SortByRowCount,{"Table", "Rows", "Partitions"})
in
    OrderCols