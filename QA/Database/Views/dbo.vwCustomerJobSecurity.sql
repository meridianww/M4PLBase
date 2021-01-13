SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- DROP VIEW [dbo].[vwCustomerJobSecurity]
CREATE VIEW [dbo].[vwCustomerJobSecurity]
	WITH SCHEMABINDING
AS
SELECT Job.ID
	,Prg.PrgCustId
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
	,Job.JobSellerSitePOC
	,Job.JobServiceActual
	,Job.JobTotalWeight
	,Job.JobProductType
	,Job.JobChannel
	,Job.DateEntered	
	,Job.JobSellerSitePOCEmail
	,Cust.CustTitle
	,Job.JobBOLMaster
	,Job.JobManifestNo
	,Job.JobDeliveryStreetAddress3
	,Job.JobDeliveryDateTimeBaseline
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

CREATE UNIQUE CLUSTERED INDEX [IX_vwCustomerJobSecurity] ON [dbo].[vwCustomerJobSecurity]
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

CREATE NONCLUSTERED INDEX [IX_vwCustomerJobSecurity_StatusId_JobGatewayStatus] ON [dbo].[vwCustomerJobSecurity]
(
	[StatusId] ASC,
	[JobGatewayStatus] ASC,
	[JobType] ASC,
	[JobIsSchedule] ASC
)
INCLUDE([JobDeliveryCity],[JobDeliveryDateTimeActual],
[JobDeliveryDateTimePlanned],[JobDeliveryPostalCode],
[JobDeliverySitePOCPhone2],[JobDeliveryState],
[JobDeliveryStreetAddress],[JobDeliveryStreetAddress2],
[JobMITJobID],[JobOrderedDate],
[JobOriginDateTimeActual],[JobOriginDateTimePlanned],
[JobDeliverySiteName],[JobDeliverySitePOC],
[JobDeliverySitePOCEmail],[JobDeliverySitePOCPhone],
[JobPartsActual],[JobQtyActual],[JobSellerSiteName],
[JobServiceMode],[JobTotalCubes],
[PlantIDCode],[ShipmentType]) 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


