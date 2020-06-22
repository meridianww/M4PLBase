IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnSettingsByUser WHERE ColUserId = -1 and [ColTableName] = 'Job')
BEGIN
INSERT dbo.SYSTM000ColumnSettingsByUser (
	[ColUserId]
	,[ColTableName]
	,[ColSortOrder]
	,[ColNotVisible]
	,[ColIsFreezed]
	,[ColIsDefault]
	,[ColGroupBy]
	,[ColGridLayout]
	,[DateEntered]
	,[EnteredBy]
	,[DateChanged]
	,[ChangedBy]
	,[ColMask]
	)
VALUES (
	- 1
	,N'Job'
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliverySitePOCEmail,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,JobQtyActual,JobPartsActual,JobServiceActual,JobCubesUnitTypeId,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,N'JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliverySitePOCEmail,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,JobQtyActual,JobPartsActual,JobServiceActual,JobCubesUnitTypeId,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,NULL
	,GETUTCDATE()
	,N'nfujimoto'
	,GETUTCDATE()
	,N'nfujimoto'
	,NULL
	)
END

IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnSettingsByUser WHERE ColUserId = -1 and [ColTableName] = 'JobCard')
BEGIN
INSERT dbo.SYSTM000ColumnSettingsByUser (
	[ColUserId]
	,[ColTableName]
	,[ColSortOrder]
	,[ColNotVisible]
	,[ColIsFreezed]
	,[ColIsDefault]
	,[ColGroupBy]
	,[ColGridLayout]
	,[DateEntered]
	,[EnteredBy]
	,[DateChanged]
	,[ChangedBy]
	,[ColMask]
	)
VALUES (
	- 1
	,N'JobCard'
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliverySitePOCEmail,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,JobQtyActual,JobPartsActual,JobServiceActual,JobCubesUnitTypeId,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,N'JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliverySitePOCEmail,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,JobQtyActual,JobPartsActual,JobServiceActual,JobCubesUnitTypeId,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobOriginSiteName,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,NULL
	,GETUTCDATE()
	,N'nfujimoto'
	,GETUTCDATE()
	,N'nfujimoto'
	,NULL
	)
END


IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000ColumnSettingsByUser WHERE ColUserId = -1 and [ColTableName] = 'JobAdvanceReport')
BEGIN
INSERT dbo.SYSTM000ColumnSettingsByUser (
	[ColUserId]
	,[ColTableName]
	,[ColSortOrder]
	,[ColNotVisible]
	,[ColIsFreezed]
	,[ColIsDefault]
	,[ColGroupBy]
	,[ColGridLayout]
	,[DateEntered]
	,[EnteredBy]
	,[DateChanged]
	,[ChangedBy]
	,[ColMask]
	)
VALUES (
	- 1
	,N'JobAdvanceReport'
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,TotalQuantity,TotalParts,JobServiceActual,JobTotalCubes,JobTotalWeight,CgoPartCode,CargoTitle,PackagingCode,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobDeliveryDateTimeActual,JobOriginDateTimeActual,PlantIDCode,JobSiteCode,JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,N'JobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,N'Id,JobCustomerSalesOrder,JobGatewayStatus,JobDeliveryDateTimePlanned,JobOriginDateTimePlanned,JobDeliverySiteName,JobDeliverySitePOC,JobDeliverySitePOCPhone,JobDeliverySitePOCPhone2,JobDeliveryStreetAddress,JobDeliveryStreetAddress2,JobDeliveryCity,JobDeliveryState,JobDeliveryPostalCode,TotalQuantity,TotalParts,JobServiceActual,JobTotalCubes,JobTotalWeight,CgoPartCode,CargoTitle,PackagingCode,JobServiceMode,JobCarrierContract,JobOrderedDate,JobBOL,JobMileage,JobCustomerPurchaseOrder,StatusId,JobDeliveryDateTimeActual,JobOriginDateTimeActual,PlantIDCode,JobSiteCodeJobSiteCode,PlantIDCode,JobTotalWeight,JobTotalCubes,JobDeliveryDateTimeActual,JobOriginDateTimeActual'
	,NULL
	,NULL
	,GETUTCDATE()
	,N'nfujimoto'
	,GETUTCDATE()
	,N'nfujimoto'
	,NULL
	)
END