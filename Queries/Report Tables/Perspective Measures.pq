let

//Perspective DMVs

    PMeasures = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVE_MEASURES"]),
    PTables = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVE_TABLES"]),
    P = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_PERSPECTIVES"]),

//Perspective and tables
    
    TableJoin = Table.NestedJoin(PTables,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TableName = Table.ExpandTableColumn(TableJoin, "Tables", {"Table Name"}, {"Table Name"}),
    PerspectiveJoin = Table.NestedJoin(TableName,"PerspectiveID",P,"ID","Perspectives",JoinKind.Inner),
    PerspectiveColumns = Table.ExpandTableColumn(PerspectiveJoin, "Perspectives", {"Name", "Description"}, {"Perspective", "Perspective Description"}),

//Perspective measures

    PMeasuresJoin = Table.NestedJoin(PMeasures,"MeasureID",MeasuresDMV,"ID","Measures",JoinKind.Inner),
    PMeasureColumns = Table.ExpandTableColumn(PMeasuresJoin, "Measures", {"Measure Name"}, {"Measure Name"}),

//Perspective measures to table join

    PMeasureTableJoin = Table.NestedJoin(PMeasureColumns,"PerspectiveTableID",PerspectiveColumns,"ID","PTable",JoinKind.Inner),
    PTableColumns = Table.ExpandTableColumn(PMeasureTableJoin, "PTable", {"Table Name", "Perspective", "Perspective Description"}, {"Table Name", "Perspective", "Perspective Description"}),
 
// Perspective Measure index column

    PreIndexSort = Table.Sort(PTableColumns,{{"Perspective", Order.Ascending}, {"Table Name", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Perspective Measure Index ID", 1, 1),

//Remove and reorder columns

    RemoveCols = Table.RemoveColumns(IndexCol,{"Perspective Description", "ID", "PerspectiveTableID", "MeasureID"}),
    ReorderCols = Table.ReorderColumns(RemoveCols,{"Perspective Measure Index ID", "Perspective", "Measure Name", "Table Name", "ModifiedTime"})

in
    ReorderCols