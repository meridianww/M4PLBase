SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/16/2018
-- Description:	The stored procedure updates the existing Scanner Orders with the Job Header information
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateScannerOrderJobInformation]
	-- Add the parameters for the stored procedure here
		@ShortDateFormat int,
	@ShortTimeFormat int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE SCN000Order
SET 
	JobID = job.ID,
	RouteID = job.JobRouteId,
	DriverID = job.JobDriverId,
	JobStop = job.JobStop,
	JobOrderID = job.JobCustomerSalesOrder,
	JobManifestID = job.JobManifestNo,
	JobCarrierID = job.JobSiteCode,
	JobOriginSiteCode = job.JobOriginSiteCode,
	JobOriginSiteName = job.JobOriginSiteName,
	JobDeliverySitePOC = job.JobDeliverySitePOC,
	JobDeliverySitePOC2 = job.JobDeliverySitePOC2,
	JobDeliveryStreetAddress = job.JobDeliveryStreetAddress,
	JobDeliveryStreetAddress2 = job.JobDeliveryStreetAddress2,
	JobDeliveryCity = job.JobDeliveryCity,
	JobDeliveryStateProvince = job.JobDeliveryState,
	JobDeliveryPostalCode = job.JobDeliveryPostalCode,
	JobDeliveryCountry = job.JobDeliveryCountry,
	JobDeliverySitePOCPhone = job.JobDeliverySitePOCPhone,
	JobDeliverySitePOCPhone2 = job.JobDeliverySitePOCPhone2,
	JobDeliveryPhoneHm = job.JobDeliveryRecipientPhone,
	JobDeliverySitePOCEmail = job.JobDeliverySitePOCEmail,
	JobDeliverySitePOCEmail2 = job.JobDeliverySitePOCEmail2,
	JobLongitude = job.JobLongitude,
	JobLatitude = job.JobLatitude,
	JobScheduledDate = CONVERT(varchar,job.JobDeliveryDateTimeBaseline,@ShortDateFormat),
	JobScheduledTime = CONVERT(varchar,job.JobDeliveryDateTimeBaseline,@ShortTimeFormat),
	JobEstimatedDate = CONVERT(varchar,job.JobDeliveryDateTimePlanned,@ShortDateFormat),
	JobEstimatedTime = CONVERT(varchar,job.JobDeliveryDateTimePlanned,@ShortTimeFormat),
	--JobFor = job.JobFor,
	--JobFrom = job.JobFrom,
	WindowStartTime = CONVERT(varchar,job.JobDeliveryDateTimePlanned,@ShortDateFormat),
	WindowEndTime = CONVERT(varchar,job.JobDeliveryDateTimePlanned,@ShortTimeFormat),
	JobFlag11 = job.ProFlags11,
	JobFlag12 = job.ProFlags12,
	JobFlag14 = job.ProFlags14	
FROM (
	SELECT 
	ID,
	JobRouteId,
	JobDriverId,
	JobStop,
	JobCustomerSalesOrder,
	JobManifestNo,
	JobSiteCode,
	JobOriginSiteCode,
	JobOriginSiteName,
	JobDeliverySitePOC,
	JobDeliverySitePOC2,
	JobDeliveryStreetAddress,
	JobDeliveryStreetAddress2,
	JobDeliveryCity,
	JobDeliveryState,
	JobDeliveryPostalCode,
	JobDeliveryCountry,
	JobDeliverySitePOCPhone,
	JobDeliverySitePOCPhone2,
	JobDeliveryRecipientPhone,
	JobDeliverySitePOCEmail,
	JobDeliverySitePOCEmail2,
	JobLongitude,
	JobLatitude,
	JobDeliveryDateTimeBaseline,
	JobDeliveryDateTimePlanned,
	--JobFor,
	--JobFrom,
	ProFlags11,
	ProFlags12,
	ProFlags14
	FROM JOBDL000Master) job
	
WHERE SCN000Order.JobID = job.Id  AND job.ProFlags12 = 'S' AND SCN000Order.JobFlag12 <> 'D' AND job.ProFlags14 Is NULL AND SCN000Order.JobFlag14 Is NULL
END
GO
