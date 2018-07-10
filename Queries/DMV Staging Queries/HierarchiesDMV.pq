let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_HIERARCHIES"]),
    RenameCol = Table.RenameColumns(Source,{{"Name", "Hierarchy Name"}, {"Description", "Hierarchy Description"}}),
    TablesJoin = Table.NestedJoin(RenameCol,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TablesName = Table.ExpandTableColumn(TablesJoin, "Tables", {"Table Name"}, {"Table Name"}),
    HideBlankMembers = Table.AddColumn(TablesName, "Hide Blank Members", each 
        if [HideMembers] = 1 then "TRUE"
        else "FALSE", type text),
   PreIndexSort = Table.Sort(HideBlankMembers,{{"Table Name", Order.Ascending}}),
   IndexCol = Table.AddIndexColumn(PreIndexSort, "Hierarchy Index ID", 1, 1),
   ReorderCols = Table.ReorderColumns(IndexCol,{"Hierarchy Index ID", "Table Name", "Hierarchy Name", "Hide Blank Members", "ModifiedTime", "StructureModifiedTime"})
in
   ReorderCols