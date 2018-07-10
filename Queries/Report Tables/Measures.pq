let
    Source = MeasuresDMV,
    RemoveCols = Table.RemoveColumns(Source,{"ID", "TableID", "DataType", "StructureModifiedTime", "KPIID", "ErrorMessage", "DetailRowsDefinitionID","State", "IsSimpleMeasure"}),
    PreIndexSort = Table.Sort(RemoveCols,{{"Table Name", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Measure Index ID", 1, 1),

    ExpressionLengthBucket = Table.AddColumn(IndexCol, "DAX Length Category", each 
        if Text.Length([DAX Expression]) <= 20 then "20 or less chararcters"
        else if  Text.Length([DAX Expression]) <= 40 then "21 to 40 characters" 
        else if  Text.Length([DAX Expression]) <= 60 then "41 to 60 characters"
        else if  Text.Length([DAX Expression]) <= 80 then "61 to 80 characters"
     else "Over 80 characters", type text),    

    ReorderCols = Table.ReorderColumns(ExpressionLengthBucket,
        {"Measure Index ID", "Table Name", "Display Folder", "Measure Name", "Measure Description", "DAX Expression", 
        "DAX Length Category","Format", "Table Description", "IsHidden", "ModifiedTime"}),

    IteratorColumn = 
        Table.AddColumn(ReorderCols, "Contains Iterator", each
            if 
                Text.Contains([DAX Expression], "FILTER") or 
                Text.Contains([DAX Expression], "Filter") or 
                Text.Contains([DAX Expression], "X") or 
                Text.Contains([DAX Expression], "x") then "TRUE" 
            else "FALSE", type text),

    VariableColumn = 
        Table.AddColumn(IteratorColumn, "Contains Variable", each
            if
                Text.Contains([DAX Expression], "VAR") or         
                Text.Contains([DAX Expression], "var") or
                Text.Contains([DAX Expression], "Var") then "TRUE"
            else "FALSE", type text)

in
    VariableColumn