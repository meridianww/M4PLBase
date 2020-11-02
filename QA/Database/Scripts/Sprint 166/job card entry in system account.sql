DECLARE @Count INT
SELECT @Count=MAX(ColSortOrder) + 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount'

IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='NotScheduleInTransit')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'NotScheduleInTransit', 'Not Schedule In Transit', 'Not Schedule In Transit', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Not Schedule In Transit')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='NotScheduleOnHand')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'NotScheduleOnHand', 'Not Schedule On Hand', 'Not Schedule On Hand', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Not Schedule On Hand')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='NotScheduleOnTruck')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'NotScheduleOnTruck', 'Not Schedule On Truck', 'Not Schedule On Truck', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Not Schedule On Truck')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='NotScheduleReturn')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'NotScheduleReturn', 'Not Schedule Return', 'Not Schedule Return', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Not Schedule Return')
	SET @Count += 1
END

IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='SchedulePastDueInTransit')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'SchedulePastDueInTransit', 'Schedule Past Due In Transit', 'Schedule Past Due In Transit', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule Past Due In Transit')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='SchedulePastDueOnHand')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'SchedulePastDueOnHand', 'Schedule Past Due On Hand','Schedule Past Due On Hand', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule Past Due On Hand')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='SchedulePastDueOnTruck')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'SchedulePastDueOnTruck', 'Schedule Past Due On Truck', 'Schedule Past Due On Truck', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule Past Due On Truck')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='SchedulePastDueReturn')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'SchedulePastDueReturn', 'Schedule Past Due Return', 'Schedule Past Due Return', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule Past Due Return'
)
	SET @Count += 1
END

IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='ScheduleForTodayInTransit')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'ScheduleForTodayInTransit', 'Schedule For Today In Transit', 'Schedule For Today In Transit', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule For Today In Transit')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='ScheduleForTodayOnHand')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'ScheduleForTodayOnHand', 'Schedule For Today On Hand','Schedule For Today On Hand', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule For Today On Hand')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='ScheduleForTodayOnTruck')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'ScheduleForTodayOnTruck', 'Schedule For Today On Truck', 'Schedule For Today On Truck', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule For Today On Truck')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='ScheduleForTodayReturn')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'ScheduleForTodayReturn', 'Schedule For Today Return', 'Schedule For Today Return', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Schedule For Today Return'
)
	SET @Count += 1
END

IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='xCBLAddressChanged')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'xCBLAddressChanged', 'xCBL Address Changed','xCBL Address Changed', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'xCBL Address Changed')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='xCBL48HoursChanged')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'xCBL48HoursChanged', 'xCBL 48 Hours Changed', 'xCBL 48 Hours Changed', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'xCBL 48 Hours Changed')
	SET @Count += 1
END
IF NOT EXISTS(SELECT 1 FROM dbo.SYSTM000ColumnsAlias WHERE ColTableName='SystemAccount' AND ColColumnName='NoPODCompletion')
BEGIN
	INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
	VALUES ('EN', 'SystemAccount', NULL, 'NoPODCompletion', 'No POD Completion', 'No POD Completion', NULL, NULL, NULL, @Count, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'No POD Completion')
	SET @Count += 1
END