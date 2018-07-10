let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_MODEL"]),
    ColRename = Table.RenameColumns(Source,{{"Name", "Model Name"}, {"Culture", "Language"}}),
    StorageMode = Table.AddColumn(ColRename, "Storage Mode", each 
           if [DefaultMode] = 1 then "DirectQuery"
           else if [DefaultMode] = 0 then "Import"
            else "Other Storage Mode", type text),
    RemovedColumns = Table.RemoveColumns(StorageMode,{"ID", "Description", "StorageLocation", "DefaultMode", "DefaultDataView", "Collation", "DataAccessOptions", "DefaultMeasureID"}),
    ReorderColumns = Table.ReorderColumns(RemovedColumns,{"Model Name", "Language", "Storage Mode", "ModifiedTime", "StructureModifiedTime", "Version"})
in
    ReorderColumns