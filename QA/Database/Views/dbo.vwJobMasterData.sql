SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- DROP VIEW [dbo].[vwJobMasterData]
CREATE VIEW [dbo].[vwJobMasterData]
	WITH SCHEMABINDING
AS
SELECT Job.ID
	,Cust.Id CustomerId 
	,Cust.CustCode CustomerCode
	,Cust.CustTitle CustomerTitle
	,Job.ProgramId
	,job.JobSiteCode
	,Job.StatusId
	,Job.JobCarrierContract
	,Job.JobCustomerPurchaseOrder
	,Job.JobCustomerSalesOrder
	,Job.JobDeliveryCity
	,Job.JobDeliveryDateTimeActual
	,Job.JobDeliveryDateTimePlanned
	,Job.JobDeliveryPostalCode
	,Job.JobDeliverySitePOCPhone2
	,Job.JobDeliveryState
	,Job.JobDeliveryStreetAddress
	,Job.JobDeliveryStreetAddress2
	,Job.JobGatewayStatus
	,Job.JobMITJobID
	,Job.JobOrderedDate
	,Job.JobOriginSiteName
	,Job.JobOriginDateTimeActual
	,Job.JobOriginDateTimePlanned
	,Job.JobDeliverySiteName
	,Job.JobDeliverySitePOC
	,Job.JobDeliverySitePOCEmail
	,Job.JobDeliverySitePOCPhone
	,Job.JobPartsActual
	,Job.JobQtyActual
	,Job.JobSellerSiteName
	,Job.JobServiceMode
	,Job.JobTotalCubes
	,Job.PlantIDCode
	,Job.ShipmentType
	,Job.JobType
	,Job.JobIsSchedule
	,Job.IsCancelled
	,Job.JobCompleted
	,Job.JobBOL
	,Job.JobMileage
	,Job.JobProductType
	,Job.JobChannel
	,Job.DateEntered	
	,Job.JobBOLMaster
	,Job.JobManifestNo
	,Job.JobDeliveryStreetAddress3
	,Job.JobDeliveryStreetAddress4
	,Job.JobDeliveryDateTimeBaseline
	,Job.JobSellerSitePOC
	,Job.JobSellerSitePOCEmail
	,Job.JobSellerSitePOCPhone
	,Job.JobSellerStreetAddress
	,Job.JobSellerStreetAddress2
	,Job.JobSellerStreetAddress3
	,Job.JobSellerStreetAddress4
	,Job.JobSellerCity
	,Job.JobSellerState
	,Job.JobSellerPostalCode
	,Job.JobCubesUnitTypeId 
	,Job.JobTotalWeight
	,Job.JobWeightUnitTypeId 
	,Job.JobServiceOrder
	,Job.JobServiceActual
	,Job.JobDriverAlert
	,Job.JobQtyOrdered
	,Job.JobQtyUnitTypeId
	,Job.JobPartsOrdered
	,Job.JobShipmentDate
	,Job.JobDeliveryResponsibleContactID
	,Job.JobDeliveryAnalystContactID
	,Job.JobDriverId
	,Job.JobSalesInvoiceNumber
FROM dbo.JOBDL000Master Job 
INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = Job.ProgramID AND Prg.StatusId=1
INNER JOIN dbo.CUST000Master Cust On Cust.Id = Prg.PrgCustID
Where ISNULL(job.JobSiteCode, '') <> ''
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE UNIQUE CLUSTERED INDEX [IX_vwJobMasterData] ON [dbo].[vwJobMasterData]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE NONCLUSTERED INDEX [IX_vwJobMasterData_StatusId_JobGatewayStatus] ON [dbo].[vwJobMasterData] (
	[StatusId] ASC
	,[JobGatewayStatus] ASC
	,[JobType] ASC
	,[JobIsSchedule] ASC
	) INCLUDE (
	ProgramId
	,JobSiteCode
	,JobCarrierContract
	,JobCustomerPurchaseOrder
	,JobCustomerSalesOrder
	,JobDeliveryCity
	,JobDeliveryDateTimeActual
	,JobDeliveryDateTimePlanned
	,JobDeliveryPostalCode
	,JobDeliverySitePOCPhone2
	,JobDeliveryState
	,JobDeliveryStreetAddress
	,JobDeliveryStreetAddress2
	,JobMITJobID
	,JobOrderedDate
	,JobOriginSiteName
	,JobOriginDateTimeActual
	,JobOriginDateTimePlanned
	,JobDeliverySiteName
	,JobDeliverySitePOC
	,JobDeliverySitePOCEmail
	,JobDeliverySitePOCPhone
	,JobPartsActual
	,JobQtyActual
	,JobSellerSiteName
	,JobServiceMode
	,JobTotalCubes
	,PlantIDCode
	,ShipmentType
	,IsCancelled
	,JobCompleted
	,JobBOL
	,JobMileage
	,JobProductType
	,JobChannel
	,DateEntered
	,JobBOLMaster
	,JobManifestNo
	,JobDeliveryStreetAddress3
	,JobDeliveryStreetAddress4
	,JobDeliveryDateTimeBaseline
	,JobSellerSitePOC
	,JobSellerSitePOCEmail
	,JobSellerSitePOCPhone
	,JobSellerStreetAddress
	,JobSellerStreetAddress2
	,JobSellerStreetAddress3
	,JobSellerStreetAddress4
	,JobSellerCity
	,JobSellerState
	,JobSellerPostalCode
	,JobCubesUnitTypeId
	,JobTotalWeight
	,JobWeightUnitTypeId
	,JobServiceOrder
	,JobServiceActual
	,JobDriverAlert
	,JobQtyOrdered
	,JobQtyUnitTypeId
	,JobPartsOrdered
	,JobShipmentDate
	,JobDeliveryResponsibleContactID
	,JobDeliveryAnalystContactID
	,JobDriverId
	,JobSalesInvoiceNumber
	)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
GO






