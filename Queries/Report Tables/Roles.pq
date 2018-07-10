let
    Source = RolesDMV,
    RemoveCols = Table.RemoveColumns(Source,{"ID", "ModelID", "ModelPermission"}),
    SortRows = Table.Sort(RemoveCols,{{"Model Permission", Order.Ascending}}),
    AddIndex = Table.AddIndexColumn(SortRows, "Role Index ID", 1, 1),
    ReorderColumns = Table.ReorderColumns(AddIndex,{"Role Index ID", "Role", "Model Permission", "Role Description", "ModifiedTime"})  
in
    ReorderColumns