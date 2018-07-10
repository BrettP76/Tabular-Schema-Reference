let
    Source = HierarchiesDMV,
    RemoveCols = Table.RemoveColumns(Source,{"ID", "TableID", "IsHidden","Hierarchy Description", 
"HideMembers", "State", "HierarchyStorageID", "RefreshedTime", "DisplayFolder"})

in
   RemoveCols