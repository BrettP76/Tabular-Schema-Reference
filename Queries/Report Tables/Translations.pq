let
    Source = CulturesDMV,
    RenamedCols = Table.RenameColumns(Source,{{"Name", "Language Translation"}}),
    RemovedColumns = Table.RemoveColumns(RenamedCols,{"ID", "ModelID", "LinguisticMetadataID", "StructureModifiedTime"}),
    SortedRows = Table.Sort(RemovedColumns,{{"Language Translation", Order.Ascending}}),
    AddedIndex = Table.AddIndexColumn(SortedRows, "Translation Index ID", 1, 1),
    ReorderedColumns = Table.ReorderColumns(AddedIndex,
        {"Translation Index ID", "Language Translation", "ModifiedTime"})

in
    ReorderedColumns