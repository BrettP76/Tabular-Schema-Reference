let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_ROLE_MEMBERSHIPS"]),
    RenameColumns = Table.RenameColumns(Source,{{"MemberName", "Role Member"}, {"IdentityProvider", "Identity Provider"}}),
    JoinToRoles = Table.NestedJoin(RenameColumns,{"RoleID"},RolesDMV,{"ID"},"Roles",JoinKind.Inner),
    RolesColumns = Table.ExpandTableColumn(JoinToRoles, "Roles", {"Role", "Role Description"}, {"Role", "Role Description"}),
    RemoveColumns = Table.RemoveColumns(RolesColumns,{"ID", "RoleID","MemberID","MemberType"}),
    PreIndexSort = Table.Sort(RemoveColumns,{{"Role", Order.Ascending}}),
    IndexCol = Table.AddIndexColumn(PreIndexSort, "Role Membership Index ID", 1, 1),
    ColReorder = Table.ReorderColumns(IndexCol,{"Role Membership Index ID", "Role", "Role Member", "Role Description", "Identity Provider", "ModifiedTime"})
in
    ColReorder