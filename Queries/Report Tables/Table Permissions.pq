let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_TABLE_PERMISSIONS"]),
    TableJoin = Table.NestedJoin(Source,{"TableID"},TablesDMV,{"ID"},"Tables",JoinKind.Inner),
    TableName = Table.ExpandTableColumn(TableJoin, "Tables", {"Table Name"}, {"Table Name"}),
    RolesJoin = Table.NestedJoin(TableName,{"RoleID"},RolesDMV,{"ID"},"Roles",JoinKind.Inner),
    RolesName = Table.ExpandTableColumn(RolesJoin, "Roles", {"Role"}, {"Role"}),
    TableMetadata = Table.AddColumn(RolesName, "Table Metadata Permission", each
        if [MetadataPermission] = 1 then "None"
        else "Permission", type text),
    RenameColumns = Table.RenameColumns(TableMetadata,{{"FilterExpression", "Table Filter Expression"}}),
    RemoveColumns = Table.RemoveColumns(RenameColumns,{"ID", "RoleID", "TableID", "ErrorMessage","State","MetadataPermission"}),
    PreIndexSort = Table.Sort(RemoveColumns,{{"Role", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Table Permission Index ID", 1, 1),
    ReorderColumns = Table.ReorderColumns(IndexCol,{"Table Permission Index ID", "Role", "Table Name", "Table Metadata Permission", "Table Filter Expression", "ModifiedTime"})
in
    ReorderColumns