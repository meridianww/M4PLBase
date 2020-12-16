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
FROM dbo.PRGRM000Master Prg
INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID
	AND ISNULL(job.JobSiteCode, '') <> ''
GO

CREATE UNIQUE CLUSTERED INDEX [IX_vwCustomerJobSecurity_Id] ON [dbo].[vwCustomerJobSecurity] (Id)

CREATE NONCLUSTERED INDEX [IX_vwCustomerJobSecurity_PrgCustId] ON [dbo].[vwCustomerJobSecurity] (PrgCustId)
GO

CREATE NONCLUSTERED INDEX [IX_vwCustomerJobSecurity_ProgramId] ON [dbo].[vwCustomerJobSecurity] (ProgramId)
GO

CREATE NONCLUSTERED INDEX [IX_vwCustomerJobSecurity_JobSiteCode] ON [dbo].[vwCustomerJobSecurity] (JobSiteCode)
GO

CREATE NONCLUSTERED INDEX [IX_vwCustomerJobSecurity_StatusId] ON [dbo].[vwCustomerJobSecurity] (StatusId)
GO

