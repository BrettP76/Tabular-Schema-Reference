let
    Source = ColumnsDMV,
    RemoveCols = Table.RemoveColumns(Source,{"ID", "TableID","SummarizeBy", "InferredName", 
"ExplicitDataType","IsUnique","IsDefaultImage","EncodingHint", 
"InferredDataType", "State", "IsKey", "IsNullable", "Alignment", "TableDetailPosition", 
"ColumnStorageID", "ColumnOriginID", "SortByColumnID", "DisplayOrdinal", "ErrorMessage", 
"SourceProviderType", "KeepUniqueRows", "SystemFlags", "RefreshedTime", "IsDefaultLabel", "Type", "AttributeHierarchyID"}),
    PreIndexSort = Table.Sort(RemoveCols,{{"Table Name", Order.Ascending}, {"Column Name", Order.Ascending}}),
    AddColIndex = Table.AddIndexColumn(PreIndexSort, "Column Index ID", 1, 1),
    ReorderCols = Table.ReorderColumns(AddColIndex,
{"Column Index ID", "Column Name", "Column Description", "Table Name", 
"Data Category", "IsHidden", "Source Column Name", "Expression", 
"FormatString", "IsAvailableInMDX","Summarize By", "ModifiedTime", "StructureModifiedTime", 
"Display Folder", "Sort By Column Name", "Table Description", "Data Type", "Column Type", "Encoding Hint"})

in
    ReorderCols