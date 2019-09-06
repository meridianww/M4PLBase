UPDATE SYSTM000ColumnsAlias SET ColIsVisible = 0 Where  ColColumnName IN ('EnteredBy',
'DateEntered',
'ChangedBy',
'DateChanged') AND ColTableName IN ('JobBillableSheet',
'JobCostSheet',
'PrgBillableLocation',
'PrgCostLocation')