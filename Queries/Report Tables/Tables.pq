let
    Source = TablesDMV,
    RemoveColumns = Table.RemoveColumns(Source,{"ID", "ModelID", "DataCategory", "TableStorageID", "SystemFlags", "ShowAsVariationsOnly", "IsPrivate", "DefaultDetailRowsDefinitionID"}),
    AddIndexCol = Table.AddIndexColumn(RemoveColumns, "Table Index ID", 1, 1),
    ReorderCols = Table.ReorderColumns(AddIndexCol,{"Table Index ID", "Table Name", "Table Description", "IsHidden", "ModifiedTime", "StructureModifiedTime"})
in
    ReorderCols