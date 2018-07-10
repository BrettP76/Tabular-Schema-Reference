let
    ColumnsDMV = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_COLUMNS"]),
    ColumnTypes = Table.TransformColumnTypes(ColumnsDMV,{{"ID", Int64.Type}, {"TableID", Int64.Type}, {"SortByColumnID", Int64.Type}}),
    ColumnRename = Table.RenameColumns(ColumnTypes,{{"ExplicitName", "Column Name"}, {"SourceColumn", "Source Column Name"}, 
    {"DisplayFolder", "Display Folder"}, {"Description", "Column Description"}, {"DataCategory", "Data Category"}}),
    SelfJoin = Table.NestedJoin(ColumnRename,{"SortByColumnID"},ColumnRename,{"ID"},"ColumnRename",JoinKind.LeftOuter),
    SortByColumn = Table.ExpandTableColumn(SelfJoin, "ColumnRename", {"Column Name"}, {"Sort By Column Name"}),
    JoinToTables = Table.NestedJoin(SortByColumn,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TableColumns = Table.ExpandTableColumn(JoinToTables, "Tables", {"Table Name", "Table Description"}, {"Table Name", "Table Description"}),

    ColumnDataType = Table.AddColumn(TableColumns, "Data Type", each
        if [ExplicitDataType] = 2 then "Text"
        else if [ExplicitDataType] = 8 then "Decimal Number"
        else if [ExplicitDataType] = 10 then "Fixed Decimal Number"
        else if [ExplicitDataType] = 6 then "Whole Number"
        else if [ExplicitDataType] = 9 then "Date"
        else "Other",
        type text),

    ColumnType = Table.AddColumn(ColumnDataType, "Column Type", each
            if [Type] = 1 then "Standard Column"
            else if [Type] = 2 then "DAX Calculated Column"
            else "System Column", type text),

    RemoveSystemColumns = Table.SelectRows(ColumnType, each ([Column Type] <> "System Column")),

    EncodingHintColumn = Table.AddColumn(RemoveSystemColumns, "Encoding Hint", each 
            if [EncodingHint] = 0 then "None"
            else if [EncodingHint] = 1 then "Hash Encoding"
            else if [EncodingHint] = 2 then "Value Encoding"
            else "Unknown", type text),

    SummarizeByColumn = Table.AddColumn(EncodingHintColumn, "Summarize By", each 
            if [SummarizeBy] = 1 then "Default"
            else if [SummarizeBy] = 2 then "Do Not Summarize"
            else if [SummarizeBy] = 3 then "Sum"
            else "Other Summarization", type text) 

in
    SummarizeByColumn