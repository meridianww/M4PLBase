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

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'LevelGrouped')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'LevelGrouped', 'LevelGrouped', 'LevelGrouped', NULL, NULL, '', 60, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'LevelGrouped')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Remarks')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Remarks', 'Remarks', 'Remarks', NULL, NULL, '', 61, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Remarks')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OriginalThirdPartyCarrier')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'OriginalThirdPartyCarrier', 'OriginalThirdPartyCarrier', 'OriginalThirdPartyCarrier', NULL, NULL, '', 62, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'OriginalThirdPartyCarrier')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OriginalOrderNumber')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'OriginalOrderNumber', 'Original Order Number', 'Original Order Number', NULL, NULL, '', 63, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Original Order Number')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Description')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Description', 'Description', 'Description', NULL, NULL, '', 64, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Description')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'QtyShipped')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'QtyShipped', 'QtyShipped', 'QtyShipped', NULL, NULL, '', 65, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'QtyShipped')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'CustomerExtendedList')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'CustomerExtendedList', 'CustomerExtendedList', 'CustomerExtendedList', NULL, NULL, '', 66, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'CustomerExtendedList')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'CabOrPart')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'CabOrPart', 'Cab or Part', 'Cab or Part', NULL, NULL, '', 67, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Cab or Part')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'DriverName')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'DriverName', 'Driver Name', 'Driver Name', NULL, NULL, '', 68, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Driver Name')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'InitialedPackingSlip')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'InitialedPackingSlip', 'Initialed Packing Slip', 'Initialed Packing Slip', NULL, NULL, '', 69, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Initialed Packing Slip')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Scanned')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Scanned', 'Scanned', 'Scanned', NULL, NULL, '', 70, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Scanned')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Month')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Month', 'Month', 'Month', NULL, NULL, '', 71, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Month')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ShortageDamage')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'ShortageDamage', 'Shortage or Damage', 'Shortage or Damage', NULL, NULL, '', 72, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Shortage or Damage')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Year')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Year', 'Year', 'Year', NULL, NULL, '', 73, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Year')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ProductSubCategory')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'ProductSubCategory', 'ProductSubCategory', 'ProductSubCategory', NULL, NULL, '', 74, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'ProductSubCategory')
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Customer')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Customer', 'Customer', 'Customer', NULL, NULL, '', 75, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Customer')
END

Declare @ColumnId1 INT,@ColumnId2 INT,@ColumnId3 INT,@ColumnId4 INT,@ColumnId5 INT,@ColumnId6 INT,@ReportType INT,@ColumnId7 INT,@ReportType2 INT
Select @ColumnId1 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobSiteCode'
Select @ColumnId2 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ManualScanningVsTotal'
Select @ColumnId3 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'FourHrWindowDeliveryCompliance'
Select @ColumnId4 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OverallRating'
Select @ColumnId5 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'ApptScheduledBeforeReceiving'
Select @ColumnId6 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Before5PMDeliveryWindow'
Select @ColumnId7 = Id From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Id'
Select @ReportType =Id From dbo.SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysOptionName = 'Pride Metric Report'
Select @ReportType2 =Id From dbo.SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysOptionName = 'Driver Scrub Report'

DELETE FROM [dbo].[Job080ReportColumnRelation] Where ReportId = @ReportType2
INSERT INTO [dbo].[Job080ReportColumnRelation] (ReportId, ColumnId)
Select @ReportType2,Id From dbo.SYSTM000ColumnsAlias Where ColTableName='JobAdvanceReport' AND ColColumnName IN ('Id','LevelGrouped','Remarks','OriginalThirdPartyCarrier','OriginalOrderNumber','Description','QtyShipped','CustomerExtendedList','CabOrPart','DriverName','InitialedPackingSlip','Scanned','Month','ShortageDamage','Year','ProductSubCategory','Customer')


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