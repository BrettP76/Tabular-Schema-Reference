let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_ROLES"]),
    RenameColumns = Table.RenameColumns(Source,{{"Name", "Role"}, {"Description", "Role Description"}}),
    ModelPermissionColumn = 
        Table.AddColumn(RenameColumns, "Model Permission", each
            if [ModelPermission] = 2 then "Read Only"
            else if [ModelPermission] = 3 then "Read and Process"
            else if [ModelPermission] = 1 then "No Access"
            else if [ModelPermission] = 4 then "Process Only"
            else if [ModelPermission] = 5 then "Database Admin"
            else "Undefined",
         type text)

in
    ModelPermissionColumn