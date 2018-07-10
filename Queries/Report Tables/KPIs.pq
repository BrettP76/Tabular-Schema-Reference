let
    Source = KPIsDMV,
    KPIsToMeasuresDMV = Table.NestedJoin(Source,{"MeasureID"},MeasuresDMV,{"ID"},"MeasuresDMV",JoinKind.Inner),
    MeasureDMVCols = Table.ExpandTableColumn(KPIsToMeasuresDMV, "MeasuresDMV", {"Measure Name", "Measure Description", "Table Name"}, {"KPI Base Measure Name", "KPI Base Measure Description", "KPI Base Measure Table Name"}),
    RemoveCols = Table.RemoveColumns(MeasureDMVCols,{"ID", "MeasureID", "TrendGraphic", "TrendDescription", "TrendExpression"}),
    PreIndexSort = Table.Sort(RemoveCols,{{"KPI Base Measure Table Name", Order.Ascending}}),
    AddIndexCol = Table.AddIndexColumn(PreIndexSort, "KPI Index ID", 1, 1),
    ReOrderCols = Table.ReorderColumns(AddIndexCol,{"KPI Index ID", "KPI Base Measure Name", "KPI Target DAX Expression", "KPI Description", "KPI Status Expression", "KPI Status Graphic", "KPI Target Description", "KPI Target Format", "KPI Status Description", "KPI Base Measure Description", "KPI Base Measure Table Name", "ModifiedTime"})
in
    ReOrderCols