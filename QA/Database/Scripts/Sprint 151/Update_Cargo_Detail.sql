UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly = 0 WHERE ColColumnName NOT IN ('CgoQtyUnits','CgoQtyUnitsId','CgoQtyCounted') AND ColTableName ='JObCargo' AND ColColumnName LIKE '%Qty%'
