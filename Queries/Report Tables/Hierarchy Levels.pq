let
    Source = HierarchyLevelsDMV,
    JoinToHierarchiesDMV = Table.NestedJoin(Source,{"HierarchyID"},HierarchiesDMV,{"ID"},"HierarchiesDMV",JoinKind.Inner),
    HierarchiesDMVCol = Table.ExpandTableColumn(JoinToHierarchiesDMV, "HierarchiesDMV", 
        {"Table Name", "Hierarchy Name"}, {"Table Name","Hierarchy Name"}),
    PreIndexSort = Table.Sort(HierarchiesDMVCol,{{"Hierarchy Name", Order.Ascending}, {"Ordinal", Order.Ascending}}),
    IndexColumn = Table.AddIndexColumn(PreIndexSort, "Hierarchy Level Index ID", 1, 1),
    RemoveColumns = Table.RemoveColumns(IndexColumn,{"ID", "HierarchyID", "ColumnID", "Description"}),
    RenameColumns = Table.RenameColumns(RemoveColumns,{{"Name", "Hierarchy Level Column"}, {"Ordinal", "Hierarchy Level"}}),
    ReorderColumns = Table.ReorderColumns(RenameColumns,{"Hierarchy Level Index ID", "Hierarchy Name", "Hierarchy Level Column", "Hierarchy Level", "Table Name", "ModifiedTime"})
in
    ReorderColumns