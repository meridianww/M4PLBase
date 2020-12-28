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
FROM dbo.PRGRM000Master Prg
INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID AND Prg.StatusId=1
	AND ISNULL(job.JobSiteCode, '') <> ''

GO
