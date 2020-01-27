SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJobAdvanceReport]
AS
SELECT Job.Id
	,Job.ProgramID ProgramId
	,Program.PrgCustID CustomerId
	,Customer.CustTitle
	,Job.JobOrderedDate
	,Job.JobBOL
	,Job.JobOriginDateTimePlanned
	,Job.JobDeliveryDateTimePlanned
	,Job.StatusId 
	,JOb.JobGatewayStatus
	,Job.JobCustomerSalesOrder
	,Job.JobManifestNo
	,Job.PlantIDCode
	,Job.JobSellerSiteName
	,Job.JobDeliverySiteName
	,Job.JobDeliveryStreetAddress
	,JOb.JobDeliveryStreetAddress2
	,Job.JobDeliveryCity
	,Job.JobDeliveryState
	,Job.JobDeliveryPostalCode
	,Job.JobDeliverySitePOC
	,JOb.JobDeliverySitePOCPhone
	,Job.JobDeliverySitePOCPhone2
	,Job.JobSellerSitePOCEmail
	,Job.JobServiceMode
	,Job.JobOriginDateTimeActual
	,Job.JobDeliveryDateTimeActual
	,Job.JobCustomerPurchaseOrder
	,Job.JobTotalCubes
	,(Job.JobPartsActual + Job.JobPartsOrdered) TotalParts
	,(Job.JobQtyActual + Job.JobQtyOrdered) TotalQuantity
	,Job.JobCarrierContract Brand
	,Job.JobSiteCode Destination
	,Job.JobProductType ProductType
	,Job.JobChannel Channel
	,Job.DateEntered 
	,GWY.GwyDDPNew
	,GWY.GwyOrderType
	,OPT.SysOptionName JobStatusText
FROM JOBDL000Master Job
INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID
LEFT JOIN dbo.JOBDL020Gateways GWY ON GWY.JobID = Job.Id
LEFT JOIN dbo.SYSTM000Ref_Options OPT ON OPT.Id = GWY.StatusId AND OPT.SysLookupCode = 'GatewayStatus'
GO