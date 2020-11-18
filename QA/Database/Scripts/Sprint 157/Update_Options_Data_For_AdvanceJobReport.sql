Declare @LookupId INT
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Lookup Where LkupCode = 'JobReportType')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Lookup (LkupCode, LkupTableName)
VALUES ('JobReportType', 'Global')
END

Select @LookupId = Id From dbo.SYSTM000Ref_Lookup Where LkupCode = 'JobReportType'
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Job Advance Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Job Advance Report', 1, 1,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Manifest Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Manifest Report', 2, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Summary')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Summary', 3, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Locations')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Locations', 4, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Jobs')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Jobs', 5, 0,1)
END

UPDATE SYSTM000ColumnsAlias SET ColisVisible=1,IsGridColumn=1 Where ColTableName='JobAdvanceReport' AND ColColumnName IN ('CustTitle','JobSiteCode')

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Report' AND ColColumnName= 'ReportType')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'Report', NULL, 'ReportType', 'Report Type', 'Report Type', @LookupId, 'JobReportType', NULL, 24, 0, 1, 1, 1, NULL, NULL, 0, NULL, 0, 'Report Type')
END

---------------------------------------- Insert Columns For Column Alias Table Job Advance Report Entity-------------------------------------------------------

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'StartDate' AND ColAliasName = 'Start Date')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'StartDate', 'Start Date', 'Start Date', NULL, NULL, '', 40, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Start Date')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Labels' AND ColAliasName = 'Labels')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Labels', 'Labels', 'Labels', NULL, NULL, '', 40, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Labels')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Inbound' AND ColAliasName = 'Inbound')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Inbound', 'Inbound', 'Inbound', NULL, NULL, '', 41, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Inbound')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'IB' AND ColAliasName = '%IB')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'IB', '%IB', '%IB', NULL, NULL, '', 42, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, '%IB')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Outbound' AND ColAliasName = 'Outbound')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Outbound', 'Outbound', 'Outbound', NULL, NULL, '', 43, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Outbound')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'OB' AND ColAliasName = '%OB')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'OB', '%OB', '%OB', NULL, NULL, '', 44, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, '%OB')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Delivered' AND ColAliasName = 'Delivered')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Delivered', 'Delivered', 'Delivered', NULL, NULL, '', 45, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Delivered')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'DE' AND ColAliasName = '%DE')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'DE', '%DE', '%DE', NULL, NULL, '', 46, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, '%DE')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Cabinets' AND ColAliasName = 'Cabinets')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Cabinets', 'Cabinets', 'Cabinets', NULL, NULL, '', 47, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Cabinets')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'Parts' AND ColAliasName = 'Parts')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'Parts', 'Parts', 'Parts', NULL, NULL, '', 48, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Parts')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobGatewayStatus' AND ColAliasName = 'Status')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobGatewayStatus', 'Status', 'Status', NULL, NULL, '', 49, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Status')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'EndDate' AND ColAliasName = 'End Date')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'EndDate', 'End Date', 'End Date', NULL, NULL, '', 50, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'End Date')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobDeliverySiteName' AND ColAliasName = 'Shipper')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobDeliverySiteName', 'Shipper', 'Shipper', NULL, NULL, '', 51, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Shipper')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobDeliveryDateTimeActual' AND ColAliasName = 'Delivered Date')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobDeliveryDateTimeActual', 'Delivered Date', 'Delivered Date', NULL, NULL, '', 52, 1, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 1, 'Delivered Date')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobOriginDateTimeActual' AND ColAliasName = 'Arrived Date')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobOriginDateTimeActual', 'Arrived Date', 'Arrived Date', NULL, NULL, '', 53, 1, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 1, 'Arrived Date')
END

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'GwyGatewayACD' AND ColAliasName = 'Outbound Date')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'GwyGatewayACD', 'Outbound Date', 'Outbound Date', NULL, NULL, '', 54, 1, 1, 1, 1, 'MM/dd/yyyy hh:mm tt', 0, 0, NULL, 1, 'Outbound Date')
END

--------------------------------------- End Column Alias Insert------------------------------------------------------------------------------------------------

------------------------------ Insert Report Column Relation Data--------------------------------------------------------------------------------------------------
DECLARE @Report1 INT,@Report2 INT,@Report3 INT,@Report4 INT,@Report5 INT

SELECT @Report1 = ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'JobReportType' AND SysOptionName = 'Job Advance Report'
SELECT @Report2 = ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'JobReportType' AND SysOptionName = 'Manifest Report'
SELECT @Report3 = ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Summary'
SELECT @Report4 = ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Locations'
SELECT @Report5 = ID FROM SYSTM000Ref_Options WHERE SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Jobs'

TRUNCATE TABLE dbo.Job080ReportColumnRelation
INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'CustTitle' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Customer'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobManifestNo' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Manifest No'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobBOL' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'BOL'


--INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
--Select @Report1, Id From dbo.SYSTM000ColumnsAlias
--WHERE ColColumnName = 'PackagingCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Packaging Type'


--INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
--Select @Report1, Id From dbo.SYSTM000ColumnsAlias
--WHERE ColColumnName = 'CgoPartCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Part Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobTotalWeight' AND ColTableName = 'JobAdvanceReport'


--INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
--Select @Report1, Id From dbo.SYSTM000ColumnsAlias
--WHERE ColColumnName = 'CargoTitle' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Cargo Title'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Id' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job ID'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCustomerSalesOrder' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Contract #'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCustomerPurchaseOrder' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Customer Purchase Order'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobGatewayStatus' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job Gateway Scheduled'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'StatusId' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Status'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOC' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCPhone' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC Phone'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySiteName' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site Name'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryStreetAddress' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Address'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryStreetAddress2' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Address2'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryCity' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery City'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryState' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery State'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryPostalCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Postal Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryDateTimePlanned' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Date Planned'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Date Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOriginDateTimePlanned' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Arrival Date Planned'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOriginDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Arrival Date Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSellerSitePOCEmail' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'POC Email'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSellerSiteName' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Site Name'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCPhone2' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC 2 Phone'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'PlantIDCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Plant Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobTotalCubes' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Total Cubes'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobServiceMode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Service Mode '


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOrderedDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Ordered Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCarrierContract' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Brand'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSiteCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Site Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCEmail' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Email'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobServiceActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Service Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobMileage' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job Mileage'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report1, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobBOLMaster' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'BOL Parent'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'StartDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Start Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Labels' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Labels'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Inbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Inbound'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'IB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%IB'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Outbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Outbound'



INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'OB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%OB'



INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Delivered' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivered'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'DE' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%DE'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Cabinets' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Cabinets'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Parts' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Parts'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'CustTitle' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Customer'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Id' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job ID'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Id' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job ID'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'CustTitle' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Customer'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCustomerSalesOrder' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Contract #'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCustomerPurchaseOrder' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Customer Purchase Order'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobGatewayStatus' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job Gateway Scheduled'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'StatusId' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Status'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOC' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCPhone' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC Phone'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySiteName' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site Name'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryStreetAddress' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Address'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryStreetAddress2' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Address2'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryCity' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery City'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryState' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery State'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryPostalCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Postal Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryDateTimePlanned' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Date Planned'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Date Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOriginDateTimePlanned' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Arrival Date Planned'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOriginDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Arrival Date Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSellerSitePOCEmail' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'POC Email'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSellerSiteName' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Site Name'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCPhone2' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Site POC 2 Phone'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobManifestNo' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Manifest No'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'PlantIDCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Plant Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobBOL' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'BOL'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobTotalCubes' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Total Cubes'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobServiceMode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Service Mode '


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOrderedDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Ordered Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCarrierContract' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Brand'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSiteCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Site Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'PackagingCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Packaging Type'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'CgoPartCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Part Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobTotalWeight' AND ColTableName = 'JobAdvanceReport'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'CargoTitle' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Cargo Title'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySitePOCEmail' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivery Email'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobServiceActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Service Actual'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE  ColColumnName = 'JobMileage' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job Mileage'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report2, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobBOLMaster' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'BOL Parent'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report3, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'EndDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'End Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'StartDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Start Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Labels' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Labels'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Inbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Inbound'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'IB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%IB'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Outbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Outbound'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'OB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%OB'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Delivered' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivered'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'DE' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%DE'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Cabinets' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Cabinets'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Parts' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Parts'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobSiteCode' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Site Code'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Id' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job ID'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report4, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'EndDate' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'End Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Labels' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Labels'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Inbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Inbound'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'IB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%IB'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Outbound' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Outbound'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'OB' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%OB'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Delivered' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivered'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'DE' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = '%DE'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Cabinets' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Cabinets'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Parts' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Parts'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobGatewayStatus' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Status'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliverySiteName' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Shipper'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobDeliveryDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Delivered Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobOriginDateTimeActual' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Arrived Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'GwyGatewayACD' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Outbound Date'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'JobCustomerSalesOrder' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Contract #'


INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @Report5, Id From dbo.SYSTM000ColumnsAlias
WHERE ColColumnName = 'Id' AND ColTableName = 'JobAdvanceReport' AND ColAliasName = 'Job ID'

----------------------------------- End Report Column Relation Insert-------------------------------------------------------
