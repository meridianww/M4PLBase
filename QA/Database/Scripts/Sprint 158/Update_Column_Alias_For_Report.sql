Declare @SysLookupId INT
Select @SysLookupId = Id From SYSTM000Ref_Lookup Where LkupCode = 'JobReportType'

IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysOptionName = 'Driver Scrub Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@SysLookupId, 'JobReportType', 'Driver Scrub Report', 6, 0, 0, 1, GetDate(), NULL, NULL, NULL)
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysOptionName = 'Pride Metric Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@SysLookupId, 'JobReportType', 'Pride Metric Report', 7, 0, 0, 1, GetDate(), NULL, NULL, NULL)
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ManualScanningVsTotal')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'ManualScanningVsTotal', 'Manual Scanning vs Total', 'Manual Scanning vs Total', NULL, NULL, '', 55, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Manual Scanning vs Total')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'FourHrWindowDeliveryCompliance')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'FourHrWindowDeliveryCompliance', '4 Hr Window Delivery Compliance', '4 Hr Window Delivery Compliance', NULL, NULL, '', 56, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, '4 Hr Window Delivery Compliance')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OverallRating')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'OverallRating', 'VOC rating (x20)', 'VOC rating (x20)', NULL, NULL, '', 57, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'VOC rating (x20)')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ApptScheduledBeforeReceiving')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'ApptScheduledBeforeReceiving', 'Appt Scheduled Before Receiving', 'Appt Scheduled Before Receiving', NULL, NULL, '', 58, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Appt Scheduled Before Receiving')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Before5PMDeliveryWindow')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Before5PMDeliveryWindow', 'Before 5PM Delivery Window', 'Before 5PM Delivery Window', NULL, NULL, '', 59, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Before 5PM Delivery Window')
END

Declare @ColumnId1 INT,@ColumnId2 INT,@ColumnId3 INT,@ColumnId4 INT,@ColumnId5 INT,@ColumnId6 INT,@ReportType INT,@ColumnId7 INT
Select @ColumnId1 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobSiteCode'
Select @ColumnId2 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ManualScanningVsTotal'
Select @ColumnId3 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'FourHrWindowDeliveryCompliance'
Select @ColumnId4 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OverallRating'
Select @ColumnId5 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ApptScheduledBeforeReceiving'
Select @ColumnId6 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Before5PMDeliveryWindow'
Select @ColumnId7 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Id'
Select @ReportType =Id From dbo.SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysOptionName = 'Pride Metric Report'


IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId1)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId1)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId2)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId2)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId3)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId3)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId4)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId4)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId5)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId5)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId6)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId6)
END
IF NOT EXISTS(Select 1 FROM [dbo].[Job080ReportColumnRelation] Where [ReportId] = @ReportType AND [ColumnId] = @ColumnId7)
BEGIN
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Values (@ReportType, @ColumnId7)
END