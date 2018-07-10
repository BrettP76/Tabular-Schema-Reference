let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_EXPRESSIONS"]),
    RemoveCols = Table.RemoveColumns(Source,{"ID", "ModelID", "Kind"}),
    RenameCols = Table.RenameColumns(RemoveCols,{{"Name", "M Expression Name"}, {"Description", "M Expression Description"}, {"Expression", "M Expression"}}),
    AddIndex = Table.AddIndexColumn(RenameCols, "M Expression Index ID", 1, 1),
    OrderColumns = Table.ReorderColumns(AddIndex,{"M Expression Index ID", "M Expression Name", "M Expression Description", "M Expression", "ModifiedTime"})
in
    OrderColumns