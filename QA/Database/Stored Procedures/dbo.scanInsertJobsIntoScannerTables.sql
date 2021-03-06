SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Inserts a new SCN000Order record for the scanner to download
-- =============================================
CREATE PROCEDURE [dbo].[scanInsertJobsIntoScannerTables]
	-- Add the parameters for the stored procedure here
	@JobId bigint
	,@ProgramId bigint
    ,@JobRouteId int
    ,@JobDriverId int
    ,@JobStop int
    ,@JobCustomerSalesOrder nvarchar(30)
    ,@JobBOL nvarchar(30)
	,@JobManifestNo nvarchar(30)
	,@JobBOLMaster nvarchar(30)
	,@JobBOLChild nvarchar(30)
    ,@JobSiteCode nvarchar(30)
    ,@JobOriginSiteCode nvarchar(30)
    ,@JobOriginSiteName nvarchar(50)
    ,@JobDeliverySitePOC nvarchar(75)
    ,@JobDeliverySitePOC2 nvarchar(75)
    ,@JobDeliveryStreetAddress nvarchar(100)
    ,@JobDeliveryStreetAddress2 nvarchar(100)
    ,@JobDeliveryCity nvarchar(50)
    ,@JobDeliveryState nvarchar(50)
    ,@JobDeliveryPostalCode nvarchar(50)
    ,@JobDeliveryCountry nvarchar(50)
    ,@JobDeliverySitePOCPhone nvarchar(50)
    ,@JobDeliverySitePOCPhone2 nvarchar(50)
    ,@JobDeliveryRecipientPhone nvarchar(50)
    ,@JobDeliverySitePOCEmail nvarchar(50)
    ,@JobDeliverySitePOCEmail2 nvarchar(50)
    ,@JobLongitude nvarchar(30)
    ,@JobLatitude nvarchar(30)
    ,@JobDeliveryDateTimeBaseline datetime2(7)
    ,@JobDeliveryDateTimePlanned datetime2(7)
    ,@JobFor nvarchar(50)
    ,@JobFrom nvarchar(50)
    ,@ProFlag11 nvarchar(1)
    ,@ProFlag12 nvarchar(1)
	,@ProFlag14 nvarchar(1)
	,@ShortDateFormat int
	,@ShortTimeFormat int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 INSERT INTO [dbo].[SCN000Order]
           ([JobID]
		   ,[ProgramID]
           ,[RouteID]
           ,[DriverID]
           ,[JobStop]
           ,[JobOrderID]
           ,[JobManifestID]
           ,[JobCarrierID]
           ,[JobOriginSiteCode]
           ,[JobOriginSiteName]
           ,[JobDeliverySitePOC]
           ,[JobDeliverySitePOC2]
           ,[JobDeliveryStreetAddress]
           ,[JobDeliveryStreetAddress2]
           ,[JobDeliveryCity]
           ,[JobDeliveryStateProvince]
           ,[JobDeliveryPostalCode]
           ,[JobDeliveryCountry]
           ,[JobDeliverySitePOCPhone]
           ,[JobDeliverySitePOCPhone2]
           ,[JobDeliveryPhoneHm]
           ,[JobDeliverySitePOCEmail]
           ,[JobDeliverySitePOCEmail2]
           ,[JobLongitude]
           ,[JobLatitude]
           ,[JobScheduledDate]
           ,[JobScheduledTime]
           ,[JobEstimatedDate]
           ,[JobEstimatedTime]
           ,[JobFor]
           ,[JobFrom]
           ,[WindowStartTime]
           ,[WindowEndTime]
           ,[JobFlag11]
           ,[JobFlag12]
		   ,[JobFlag14])
     VALUES
           (@JobId 
		   ,@ProgramId
           ,@JobRouteId
           ,@JobDriverId
           ,@JobStop
           ,@JobCustomerSalesOrder
           ,IsNull(@JobBOL,ISNULL(@JobManifestNo,@JobBOLMaster))
           ,@JobSiteCode
           ,@JobOriginSiteCode
           ,@JobOriginSiteName
           ,@JobDeliverySitePOC
           ,@JobDeliverySitePOC2
           ,@JobDeliveryStreetAddress
           ,@JobDeliveryStreetAddress2
           ,@JobDeliveryCity
           ,@JobDeliveryState
           ,@JobDeliveryPostalCode
           ,@JobDeliveryCountry
           ,@JobDeliverySitePOCPhone
           ,@JobDeliverySitePOCPhone2
           ,@JobDeliveryRecipientPhone
           ,@JobDeliverySitePOCEmail
           ,@JobDeliverySitePOCEmail2
           ,@JobLongitude
           ,@JobLatitude
           ,CONVERT(varchar,@JobDeliveryDateTimeBaseline,@ShortDateFormat)
           ,CONVERT(varchar,@JobDeliveryDateTimeBaseline,@ShortTimeFormat)
           ,CONVERT(varchar,@JobDeliveryDateTimePlanned,@ShortDateFormat) 
           ,CONVERT(varchar,@JobDeliveryDateTimePlanned,@ShortTimeFormat)
           ,@JobFor
           ,@JobFrom
           ,CONVERT(varchar,@JobDeliveryDateTimePlanned,@ShortDateFormat)
           ,CONVERT(varchar,@JobDeliveryDateTimePlanned,@ShortTimeFormat)
           ,@ProFlag11
           ,@ProFlag12
		   ,@ProFlag14); Select SCOPE_IDENTITY();

END
GO
