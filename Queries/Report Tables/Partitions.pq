let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PARTITIONS"]),
    Rename = Table.RenameColumns(Source,{{"Name", "Partition Name"},{"Description", "Partition Description"}, {"QueryDefinition", "Partition Query"}}),
    TablesJoin = Table.NestedJoin(Rename,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TablesColumns = Table.ExpandTableColumn(TablesJoin, "Tables", {"Table Name"}, {"Table Name"}),    
    RemoveCols = Table.RemoveColumns(TablesColumns,{"ID", "TableID","Type", "DataSourceID", "State", "PartitionStorageID", "RefreshedTime", "SystemFlags", "ErrorMessage", "RetainDataTillForceCalculate"}),
    PreIndexSort = Table.Sort(RemoveCols,{{"Table Name", Order.Ascending}, {"Partition Name", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Partition Index ID", 1, 1),
    ColumnOrder = Table.ReorderColumns(IndexCol,{"Partition Index ID", "Table Name", "Partition Name", 
"Partition Query", "Partition Description", "Mode", "DataView", "ModifiedTime"})
in
    ColumnOrder