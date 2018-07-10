let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_DETAIL_ROWS_DEFINITIONS"]),
    RowDefColType = Table.AddColumn(Source,"Detail Row Type", each 
        if [ObjectType] = 8 then "Measure Detail Row Definition"
        else "Default Table Detail Row Definition", type text),
    RenameCols = Table.RenameColumns(RowDefColType,{{"Expression", "Detail Row DAX Expression"}}),
    MeasureJoin = Table.NestedJoin(RenameCols,{"ID"},MeasuresDMV,{"DetailRowsDefinitionID"},"MeasuresDMV",JoinKind.LeftOuter),
    MeasureCols = Table.ExpandTableColumn(MeasureJoin, "MeasuresDMV", {"Measure Name", "Measure Description"}, {"Measure Name", "Measure Description"}),
    TablesJoin = Table.NestedJoin(MeasureCols,{"ID"},TablesDMV,{"DefaultDetailRowsDefinitionID"},"TablesDMV",JoinKind.LeftOuter),
    TablesCols = Table.ExpandTableColumn(TablesJoin, "TablesDMV", {"Table Name"}, {"Table Name"}),
    SelectCols = Table.SelectColumns(TablesCols,{"Detail Row DAX Expression", "Detail Row Type", 
    "Measure Name", "Measure Description", "Table Name"}),
    PreIndexSort = Table.Sort(SelectCols,{{"Detail Row Type", Order.Ascending}, {"Table Name", Order.Ascending}}),
    DetailRowIndex = Table.AddIndexColumn(PreIndexSort, "Detail Row Index ID", 1, 1),
    ReorderCols = Table.ReorderColumns(DetailRowIndex,
        {"Detail Row Index ID", "Detail Row Type", "Detail Row DAX Expression", "Measure Name", 
        "Measure Description", "Table Name"})
  in
    ReorderCols