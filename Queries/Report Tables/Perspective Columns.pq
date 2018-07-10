let

//Perspective DMVs

    PColumns = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVE_COLUMNS"]),
    PTables = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVE_TABLES"]),
    P = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVES"]),

//Perspective and tables
    
    TableJoin = Table.NestedJoin(PTables,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TableName = Table.ExpandTableColumn(TableJoin, "Tables", {"Table Name"}, {"Table Name"}),
    PerspectiveJoin = Table.NestedJoin(TableName,"PerspectiveID",P,"ID","Perspectives",JoinKind.Inner),
    PerspectiveColumns = Table.ExpandTableColumn(PerspectiveJoin, "Perspectives", {"Name", "Description"}, {"Perspective", "Perspective Description"}),

//Perspective columns

    PColJoin = Table.NestedJoin(PColumns,"ColumnID",ColumnsDMV,"ID","Columns",JoinKind.Inner),
    PCol = Table.ExpandTableColumn(PColJoin, "Columns", {"Column Name"}, {"Column Name"}),

//Perspective column to table join

    PColTableJoin = Table.NestedJoin(PCol,"PerspectiveTableID",PerspectiveColumns,"ID","PTable",JoinKind.Inner),
    PTable = Table.ExpandTableColumn(PColTableJoin, "PTable", {"Table Name", "Perspective", "Perspective Description"}, {"Table Name", "Perspective", "Perspective Description"}),
    RemoveColumns = Table.RemoveColumns(PTable,{"ID", "PerspectiveTableID", "ColumnID", "Perspective Description"}),

//Inded ID and Order

    PreIndexSort = Table.Sort(RemoveColumns,{{"Perspective", Order.Ascending}, {"Table Name", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Perspective Column Index ID", 1, 1),
    ColOrder = Table.ReorderColumns(IndexCol,{"Perspective Column Index ID", "Perspective", "Column Name", "Table Name", "ModifiedTime"})
in
    ColOrder