SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Merges the Job Scanner Process Flags between the JOBDL000Master (Source) and SCN000Order (Target)
-- =============================================
CREATE PROCEDURE [dbo].[scanMergeJobAndScannerProcessingFlags]
	-- Add the parameters for the stored procedure here
	@ShortDateFormat int,
	@ShortTimeFormat int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    -- Synchronize the SCN000Order (TARGET) table with refreshed JOBDL000Master (SOURCE) table data for Scanner Processing Flags
MERGE SCN000Order As TARGET
USING JOBDL000Master As SOURCE ON (SOURCE.Id = TARGET.JobId)
-- When records matched, update the Scanner Processing Flags if there is a change to the Gateway Step (Processing Step) or Scanner Data State
WHEN MATCHED AND SOURCE.ProFlags12 = 'S' AND TARGET.JobFlag12 <> 'D' AND SOURCE.ProFlags14 Is NULL AND TARGET.JobFlag14 Is NULL THEN
UPDATE SET 
	TARGET.[JobID] = SOURCE.ID,
	TARGET.[RouteID] = SOURCE.JobRouteId,
	TARGET.[DriverID] = JobDriverId,
	TARGET.[JobStop] = SOURCE.JobStop,
	TARGET.[JobOrderID] = SOURCE.JobCustomerSalesOrder,
	TARGET.[JobManifestID] = SOURCE.JobManifestNo,
	TARGET.[JobCarrierID] = SOURCE.JobSiteCode,
	TARGET.[JobOriginSiteCode] = SOURCE.JobOriginSiteCode,
	TARGET.[JobOriginSiteName] = SOURCE.JobOriginSiteName,
	TARGET.[JobDeliverySitePOC] = SOURCE.JobDeliverySitePOC,
	TARGET.[JobDeliverySitePOC2] = SOURCE.JobDeliverySitePOC2,
	TARGET.[JobDeliveryStreetAddress] = SOURCE.JobDeliveryStreetAddress,
	TARGET.[JobDeliveryStreetAddress2] = SOURCE.JobDeliveryStreetAddress2,
	TARGET.[JobDeliveryCity] = SOURCE.JobDeliveryCity,
	TARGET.[JobDeliveryStateProvince] = SOURCE.JobDeliveryState,
	TARGET.[JobDeliveryPostalCode] = SOURCE.JobDeliveryPostalCode,
	TARGET.[JobDeliveryCountry] = SOURCE.JobDeliveryCountry,
	TARGET.[JobDeliverySitePOCPhone] = SOURCE.JobDeliverySitePOCPhone,
	TARGET.[JobDeliverySitePOCPhone2] = SOURCE.JobDeliverySitePOCPhone2,
	TARGET.[JobDeliveryPhoneHm] = SOURCE.JobDeliveryRecipientPhone,
	TARGET.[JobDeliverySitePOCEmail] = SOURCE.JobDeliverySitePOCEmail,
	TARGET.[JobDeliverySitePOCEmail2] = SOURCE.JobDeliverySitePOCEmail2,
	TARGET.[JobLongitude] = SOURCE.JobLongitude,
	TARGET.[JobLatitude] = SOURCE.JobLatitude,
	TARGET.[JobScheduledDate] = CONVERT(varchar,SOURCE.JobDeliveryDateTimeBaseline,@ShortDateFormat),
	TARGET.[JobScheduledTime] = CONVERT(varchar,SOURCE.JobDeliveryDateTimeBaseline,@ShortTimeFormat),
	TARGET.[JobEstimatedDate] = CONVERT(varchar,SOURCE.JobDeliveryDateTimePlanned,@ShortDateFormat),
	TARGET.[JobEstimatedTime] = CONVERT(varchar,SOURCE.JobDeliveryDateTimePlanned,@ShortTimeFormat),
	TARGET.[JobFor] = '',
	TARGET.[JobFrom] = '',
	TARGET.[WindowStartTime] = CONVERT(varchar,SOURCE.JobDeliveryDateTimePlanned,@ShortDateFormat),
	TARGET.[WindowEndTime] = CONVERT(varchar,SOURCE.JobDeliveryDateTimePlanned,@ShortTimeFormat),
	TARGET.JobFlag11 = SOURCE.ProFlags11,
	TARGET.JobFlag12 = SOURCE.ProFlags12,
	TARGET.JobFlag14 = SOURCE.ProFlags14;

END
GO
