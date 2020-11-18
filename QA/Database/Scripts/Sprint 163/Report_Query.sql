CREATE TABLE #Temp (DisplayName Varchar(150), ColumnName Varchar(150), ColumnAliasId BIGINT)
IF NOT EXISTS(Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobOriginSiteName')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobOriginSiteName', 'Origin Site Name', 'Origin Site Name', NULL, NULL, '', 82, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Origin Site Name')
END

IF NOT EXISTS(Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'RateChargeCode')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'RateChargeCode', 'Charge Code', 'Charge Code', NULL, NULL, '', 83, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Charge Code')
END

IF NOT EXISTS(Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'RateTitle')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'RateTitle', 'Title', 'Title', NULL, NULL, '', 84, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Title')
END

IF NOT EXISTS(Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'RateAmount')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'RateAmount', 'Rate', 'Rate', NULL, NULL, '', 82, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Rate')
END
IF NOT EXISTS(Select 1 From  dbo.SYSTM000ColumnsAlias Where ColTableName = 'JobAdvanceReport' AND ColColumnName = 'JobId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobAdvanceReport', NULL, 'JobId', 'Job Id', 'Job Id', NULL, NULL, '', 82, 1, 1, 1, 1, NULL, 0, 0, NULL, 1, 'Job Id')
END

INSERT INTO #Temp (DisplayName, ColumnName) VALUES
('JobId', 'Id'),
('Job Id','JobId'),
('Delivery Date Planned','JobDeliveryDateTimePlanned'),
('Arrival Date Planned','JobOriginDateTimePlanned'),
('Job Gateway Scheduled','JobGatewayStatus'),
('Site Code','JobSiteCode'),
('Contract #','JobCustomerSalesOrder'),
('Plant Code','PlantIDCode'),
('Quantity Actual','JobQtyActual'),
('Parts Actual','JobPartsActual'),
('Cubes Unit','JobTotalCubes'),
('Charge Code', 'RateChargeCode'),
('Title','RateTitle'),
('Rate','RateAmount'),
('Service Mode','JobServiceMode'),
('Customer Purchase Order','JobCustomerPurchaseOrder'),
('Brand','JobCarrierContract'),
('Status','StatusId'),
('Delivery Site POC','JobDeliverySitePOC'),
('Delivery Site Phone','JobDeliverySitePOCPhone'),
('Delivery Site POC 2','JobDeliverySitePOCPhone2'),
('Phone POC Email','JobDeliverySitePOCEmail'),
('Site Name','JobOriginSiteName'),
('Delivery Site Name','JobDeliverySiteName'),
('Delivery Address','JobDeliveryStreetAddress'),
('Delivery Address2','JobDeliveryStreetAddress2'),
('Delivery City','JobDeliveryCity'),
('Delivery State','JobDeliveryState'),
('Delivery Postal Code','JobDeliveryPostalCode'),
('Delivery Date Actual','JobDeliveryDateTimeActual'),
('Origin Date Actual','JobOriginDateTimeActual'),
('Ordered Date','JobOrderedDate')

UPDATE Temp
SET Temp.ColumnAliasId = Alias.Id
From #Temp Temp
INNER JOIN dbo.SYSTM000ColumnsAlias Alias ON Alias.ColColumnName = Temp.ColumnName AND Alias.ColTableName = 'JobAdvanceReport'

Declare @LookupId INT, @PriceChargeId INT, @CostChargeId INT
Select @LookupId = Id From SYSTM000Ref_Lookup Where LkupCode='JobReportType'
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Cost Charge')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@LookupId, 'JobReportType', 'Cost Charge', 9, 0, 0, 1, GetDate(), NULL, NULL, NULL)
END
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Price Charge')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (@LookupId, 'JobReportType', 'Price Charge', 10, 0, 0, 1, GetDate(), NULL, NULL, NULL)
END

Select @CostChargeId = ID From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Cost Charge'
Select @PriceChargeId = ID From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Price Charge'

IF EXISTS(Select 1 From dbo.Job080ReportColumnRelation Where ReportId = @CostChargeId)
BEGIN
Delete From dbo.Job080ReportColumnRelation Where ReportId = @CostChargeId
END

IF EXISTS(Select 1 From dbo.Job080ReportColumnRelation Where ReportId = @PriceChargeId)
BEGIN
Delete From dbo.Job080ReportColumnRelation Where ReportId = @PriceChargeId
END

INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @CostChargeId,ColumnAliasId From #Temp 

INSERT INTO dbo.Job080ReportColumnRelation (ReportId, ColumnId)
Select @PriceChargeId,ColumnAliasId From #Temp 

DROP TABLE #Temp

