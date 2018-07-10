let
    Source = AnalysisServices.Database(Server, Database, [Query="select * from $SYSTEM.TMSCHEMA_KPIS"]),
    #"Renamed Columns" = Table.RenameColumns(Source,{{"TargetDescription", "KPI Target Description"}, {"TargetExpression", "KPI Target DAX Expression"}, {"TargetFormatString", "KPI Target Format"}, {"StatusGraphic", "KPI Status Graphic"}, {"StatusExpression", "KPI Status Expression"}, {"Description", "KPI Description"}, {"StatusDescription", "KPI Status Description"}})

in
   #"Renamed Columns"