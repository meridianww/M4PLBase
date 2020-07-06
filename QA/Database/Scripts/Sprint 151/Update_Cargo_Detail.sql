UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly = 0 WHERE ColColumnName NOT IN ('CgoQtyUnits','CgoQtyUnitsId','CgoQtyCounted') AND ColTableName ='JObCargo' AND ColColumnName LIKE '%Qty%'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Loaded'
	,ColGridAliasName = 'Qty Loaded'
	,ColCaption = 'Qty Loaded'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyExpected'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty OnHand'
	,ColGridAliasName = 'Qty OnHand'
	,ColCaption = 'Qty OnHand'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyOnHand'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Damaged'
	,ColGridAliasName = 'Qty Damaged'
	,ColCaption = 'Qty Damaged'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyDamaged'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Delivered'
	,ColGridAliasName = 'Qty Delivered'
	,ColCaption = 'Qty Delivered'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyOnHold'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Ordered'
	,ColGridAliasName = 'Qty Ordered'
	,ColCaption = 'Qty Ordered'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQTYOrdered'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Short'
	,ColGridAliasName = 'Qty Short'
	,ColCaption = 'Qty Short'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyShortOver'

UPDATE SYSTM000ColumnsAlias
SET ColAliasName = 'Qty Over'
	,ColGridAliasName = 'Qty Over'
	,ColCaption = 'Qty Over'
WHERE ColTableName = 'JobCargo'
	AND ColColumnName = 'CgoQtyOver'
