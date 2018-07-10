let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_RELATIONSHIPS"]),
    Types = Table.TransformColumnTypes(Source,{{"ID", Int64.Type}}),
    FromTableJoin = Table.NestedJoin(Types,{"FromTableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    FromTable = Table.ExpandTableColumn(FromTableJoin, "Tables", {"Table Name"}, {"From Table Name"}),
    ToTableJoin = Table.NestedJoin(FromTable,{"ToTableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    ToTable = Table.ExpandTableColumn(ToTableJoin, "Tables", {"Table Name"}, {"To Table Name"}),
    FromColumnJoin = Table.NestedJoin(ToTable,{"FromColumnID"},ColumnsDMV,{"ID"},"Columns",JoinKind.Inner),
    FromColumn = Table.ExpandTableColumn(FromColumnJoin, "Columns", {"Column Name"}, {"From Column Name"}),
    ToColumnJoin = Table.NestedJoin(FromColumn,{"ToColumnID"},ColumnsDMV,{"ID"},"Columns",JoinKind.Inner),
    ToColumn = Table.ExpandTableColumn(ToColumnJoin, "Columns", {"Column Name"}, {"To Column Name"}),
    Crossfilter = Table.AddColumn(ToColumn, "Crossfiltering Behavior", each
        if [CrossFilteringBehavior] = 1 then "Single Direction"
        else if [CrossFilteringBehavior] = 2 then "Bidirectional Crossfiltering"
        else "Unknown", 
        type text),

    SecurityFilterBehavior = Table.AddColumn(Crossfilter, "Security Filter Behavior", each 
        if [SecurityFilteringBehavior] = 2 then "Bidirectional Security Filter"
        else if  [SecurityFilteringBehavior] = 1 then "Single Direction Security Filter"
        else "Unknown",
        type text),

    ColumnOrder = Table.ReorderColumns(SecurityFilterBehavior,{"ID", "From Table Name", "To Table Name", "From Column Name", "To Column Name", "Crossfiltering Behavior", "ModelID", "Name", "IsActive", "Type", "CrossFilteringBehavior", "JoinOnDateBehavior", "RelyOnReferentialIntegrity", "FromTableID", "FromColumnID", "FromCardinality", "ToTableID", "ToColumnID", "ToCardinality", "State", "RelationshipStorageID", "RelationshipStorage2ID", "ModifiedTime", "RefreshedTime", "SecurityFilteringBehavior"}),
    RemoveCols = Table.RemoveColumns(ColumnOrder,
        {"ID", "ModelID", "Name", "CrossFilteringBehavior", 
        "FromTableID", "FromColumnID", "FromCardinality", "ToTableID", "ToColumnID", "ToCardinality", "State", 
         "RelationshipStorageID","Type", "RelationshipStorage2ID", "SecurityFilteringBehavior"}),

    PreIndexSort = Table.Sort(RemoveCols,{{"From Table Name", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Relationship Index ID", 1, 1),
    OrderColumns = Table.ReorderColumns(IndexCol,{"Relationship Index ID", "From Table Name", "To Table Name",
 "From Column Name", "To Column Name", "Crossfiltering Behavior", "Security Filter Behavior", "IsActive", "JoinOnDateBehavior", "RelyOnReferentialIntegrity", "ModifiedTime", "RefreshedTime" })
in
    OrderColumns