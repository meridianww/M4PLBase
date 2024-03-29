SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrder
-- Execution:                 EXEC [dbo].[UpdScnOrder]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnOrder]
(@userId BIGINT
,@roleId BIGINT  
,@entity NVARCHAR(100)
,@id bigint
,@jobID BIGINT = NULL
,@programID BIGINT = NULL
,@routeID INT = NULL
,@driverID BIGINT = NULL
,@jobDeviceID NVARCHAR(30) = NULL
,@jobStop INT = NULL
,@jobOrderID NVARCHAR(30) = NULL
,@jobManifestID NVARCHAR(30) = NULL
,@jobCarrierID NVARCHAR(30) = NULL
,@jobReturnReasonID INT = NULL
,@jobStatusCD NVARCHAR(30) = NULL
,@jobOriginSiteCode NVARCHAR(30) = NULL
,@jobOriginSiteName NVARCHAR(50) = NULL
,@jobDeliverySitePOC NVARCHAR(75) = NULL
,@jobDeliverySitePOC2 NVARCHAR(75) = NULL
,@jobDeliveryStreetAddress NVARCHAR(100) = NULL
,@jobDeliveryStreetAddress2 NVARCHAR(100) = NULL
,@jobDeliveryCity NVARCHAR(50) = NULL
,@jobDeliveryStateProvince NVARCHAR(50) = NULL
,@jobDeliveryPostalCode NVARCHAR(50) = NULL
,@jobDeliveryCountry NVARCHAR(50) = NULL
,@jobDeliverySitePOCPhone NVARCHAR(50) = NULL
,@jobDeliverySitePOCPhone2 NVARCHAR(50) = NULL
,@jobDeliveryPhoneHm  NVARCHAR(50) = NULL
,@jobDeliverySitePOCEmail NVARCHAR(50) = NULL
,@jobDeliverySitePOCEmail2 NVARCHAR(50) = NULL
,@jobOriginStreetAddress NVARCHAR(100) = NULL
,@jobOriginCity NVARCHAR(50) = NULL
,@jobOriginStateProvince NVARCHAR(50) = NULL
,@jobOriginPostalCode NVARCHAR(50) = NULL
,@jobOriginCountry NVARCHAR(50) = NULL
,@jobLongitude NVARCHAR(30) = NULL
,@jobLatitude NVARCHAR(30) = NULL
,@jobSignLongitude NVARCHAR(30) = NULL
,@jobSignLatitude NVARCHAR(30) = NULL
,@jobSignText NVARCHAR(50) = NULL
,@jobScheduledDate DATETIME2(7) = NULL
,@jobScheduledTime DATETIME2(7) = NULL
,@jobEstimatedDate DATETIME2(7) = NULL
,@jobEstimatedTime DATETIME2(7) = NULL
,@jobActualDate DATETIME2(7) = NULL
,@jobActualTime DATETIME2(7) = NULL
,@colorCD INT = NULL
,@jobFor NVARCHAR(50) = NULL
,@jobFrom NVARCHAR(50) = NULL
,@windowStartTime DATETIME2(7) = NULL
,@windowEndTime DATETIME2(7) = NULL
,@jobFlag01 NVARCHAR(1) = NULL
,@jobFlag02 NVARCHAR(1) = NULL
,@jobFlag03 NVARCHAR(1) = NULL
,@jobFlag04 NVARCHAR(1) = NULL
,@jobFlag05 NVARCHAR(1) = NULL
,@jobFlag06 NVARCHAR(1) = NULL
,@jobFlag07 NVARCHAR(1) = NULL
,@jobFlag08 NVARCHAR(1) = NULL
,@jobFlag09 NVARCHAR(1) = NULL
,@jobFlag10 NVARCHAR(1) = NULL
,@jobFlag11 NVARCHAR(1) = NULL
,@jobFlag12 NVARCHAR(1) = NULL
,@jobFlag13 NVARCHAR(1) = NULL
,@jobFlag14 NVARCHAR(1) = NULL
,@jobFlag15 NVARCHAR(1) = NULL
,@jobFlag16 NVARCHAR(1) = NULL
,@jobFlag17 NVARCHAR(1) = NULL
,@jobFlag18 NVARCHAR(1) = NULL
,@jobFlag19 NVARCHAR(1) = NULL
,@jobFlag20 NVARCHAR(1) = NULL
,@jobFlag21 INT = NULL
,@jobFlag22 BIGINT = NULL
,@jobFlag23 INT = NULL
,@changedBy NVARCHAR(50) = NULL
,@dateChanged DATETIME2(7) = NULL
,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN000Order]
      SET   [JobID]						= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
		   ,[ProgramID]					= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
		   ,[RouteID]					= CASE WHEN (@isFormView = 1) THEN @routeID WHEN ((@isFormView = 0) AND (@routeID=-100)) THEN NULL ELSE ISNULL(@routeID, [RouteID]) END
		   ,[DriverID]					= CASE WHEN (@isFormView = 1) THEN @driverID WHEN ((@isFormView = 0) AND (@driverID=-100)) THEN NULL ELSE ISNULL(@driverID, [DriverID]) END
           ,[JobDeviceID]				= CASE WHEN (@isFormView = 1) THEN @jobDeviceID WHEN ((@isFormView = 0) AND (@jobDeviceID='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeviceID, [JobDeviceID]) END
		   ,[JobStop]					= CASE WHEN (@isFormView = 1) THEN @jobStop WHEN ((@isFormView = 0) AND (@jobStop=-100)) THEN NULL ELSE ISNULL(@jobStop, [JobStop]) END
           ,[JobOrderID]				= CASE WHEN (@isFormView = 1) THEN @jobOrderID WHEN ((@isFormView = 0) AND (@jobOrderID='#M4PL#')) THEN NULL ELSE ISNULL(@jobOrderID, [JobOrderID]) END
           ,[JobManifestID]				= CASE WHEN (@isFormView = 1) THEN @jobManifestID WHEN ((@isFormView = 0) AND (@jobManifestID='#M4PL#')) THEN NULL ELSE ISNULL(@jobManifestID, [JobManifestID]) END
           ,[JobCarrierID]				= CASE WHEN (@isFormView = 1) THEN @jobCarrierID WHEN ((@isFormView = 0) AND (@jobCarrierID='#M4PL#')) THEN NULL ELSE ISNULL(@jobCarrierID, [JobCarrierID]) END
		   ,[JobReturnReasonID]			= CASE WHEN (@isFormView = 1) THEN @jobReturnReasonID WHEN ((@isFormView = 0) AND (@jobReturnReasonID=-100)) THEN NULL ELSE ISNULL(@jobReturnReasonID, [JobReturnReasonID]) END
           ,[JobStatusCD]				= CASE WHEN (@isFormView = 1) THEN @jobStatusCD WHEN ((@isFormView = 0) AND (@jobStatusCD='#M4PL#')) THEN NULL ELSE ISNULL(@jobStatusCD, [JobStatusCD]) END
           ,[JobOriginSiteCode]			= CASE WHEN (@isFormView = 1) THEN @jobOriginSiteCode WHEN ((@isFormView = 0) AND (@jobOriginSiteCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteCode, [JobOriginSiteCode]) END
           ,[JobOriginSiteName]			= CASE WHEN (@isFormView = 1) THEN @jobOriginSiteName WHEN ((@isFormView = 0) AND (@jobOriginSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteName, [JobOriginSiteName]) END
           ,[JobDeliverySitePOC]		= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC, [JobDeliverySitePOC]) END
           ,[JobDeliverySitePOC2]		= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC2, [JobDeliverySitePOC2]) END
           ,[JobDeliveryStreetAddress]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress, [JobDeliveryStreetAddress]) END
           ,[JobDeliveryStreetAddress2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress2 WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress2, [JobDeliveryStreetAddress2]) END
           ,[JobDeliveryCity]			= CASE WHEN (@isFormView = 1) THEN @jobDeliveryCity WHEN ((@isFormView = 0) AND (@jobDeliveryCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCity, [JobDeliveryCity]) END
           ,[JobDeliveryStateProvince]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStateProvince WHEN ((@isFormView = 0) AND (@jobDeliveryStateProvince='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStateProvince, [JobDeliveryStateProvince]) END
           ,[JobDeliveryPostalCode]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryPostalCode WHEN ((@isFormView = 0) AND (@jobDeliveryPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPostalCode, [JobDeliveryPostalCode]) END
           ,[JobDeliveryCountry]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryCountry WHEN ((@isFormView = 0) AND (@jobDeliveryCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCountry, [JobDeliveryCountry]) END
           ,[JobDeliverySitePOCPhone]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone, [JobDeliverySitePOCPhone]) END
           ,[JobDeliverySitePOCPhone2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone2, [JobDeliverySitePOCPhone2]) END
           ,[JobDeliveryPhoneHm]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryPhoneHm WHEN ((@isFormView = 0) AND (@jobDeliveryPhoneHm='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPhoneHm, [JobDeliveryPhoneHm]) END
           ,[JobDeliverySitePOCEmail]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail, [JobDeliverySitePOCEmail]) END
           ,[JobDeliverySitePOCEmail2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail2, [JobDeliverySitePOCEmail2]) END
           ,[JobOriginStreetAddress]	= CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress, [JobOriginStreetAddress]) END
           ,[JobOriginCity]				= CASE WHEN (@isFormView = 1) THEN @jobOriginCity WHEN ((@isFormView = 0) AND (@jobOriginCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCity, [JobOriginCity]) END
           ,[JobOriginStateProvince]	= CASE WHEN (@isFormView = 1) THEN @jobOriginStateProvince WHEN ((@isFormView = 0) AND (@jobOriginStateProvince='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStateProvince, [JobOriginStateProvince]) END
           ,[JobOriginPostalCode]		= CASE WHEN (@isFormView = 1) THEN @jobOriginPostalCode WHEN ((@isFormView = 0) AND (@jobOriginPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginPostalCode, [JobOriginPostalCode]) END
           ,[JobOriginCountry]			= CASE WHEN (@isFormView = 1) THEN @jobOriginCountry WHEN ((@isFormView = 0) AND (@jobOriginCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCountry, [JobOriginCountry]) END
           ,[JobLongitude]				= CASE WHEN (@isFormView = 1) THEN @jobLongitude WHEN ((@isFormView = 0) AND (@jobLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLongitude, [JobLongitude]) END
           ,[JobLatitude]				= CASE WHEN (@isFormView = 1) THEN @jobLatitude WHEN ((@isFormView = 0) AND (@jobLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLatitude, [JobLatitude]) END
           ,[JobSignLongitude]			= CASE WHEN (@isFormView = 1) THEN @jobSignLongitude WHEN ((@isFormView = 0) AND (@jobSignLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLongitude, [JobSignLongitude]) END
           ,[JobSignLatitude]			= CASE WHEN (@isFormView = 1) THEN @jobSignLatitude WHEN ((@isFormView = 0) AND (@jobSignLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLatitude, [JobSignLatitude]) END
           ,[JobSignText]				= CASE WHEN (@isFormView = 1) THEN @jobSignText WHEN ((@isFormView = 0) AND (@jobSignText='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignText, [JobSignText]) END
		   ,[JobScheduledDate]			= CASE WHEN (@isFormView = 1) THEN @jobScheduledDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobScheduledDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobScheduledDate, [JobScheduledDate]) END    
		   ,[JobScheduledTime]			= CASE WHEN (@isFormView = 1) THEN @jobScheduledTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobScheduledTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobScheduledTime, [JobScheduledTime]) END    
		   ,[JobEstimatedDate]			= CASE WHEN (@isFormView = 1) THEN @jobEstimatedDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobEstimatedDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobEstimatedDate, [JobEstimatedDate]) END    
		   ,[JobEstimatedTime]			= CASE WHEN (@isFormView = 1) THEN @jobEstimatedTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobEstimatedTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobEstimatedTime, [JobEstimatedTime]) END    
		   ,[JobActualDate]				= CASE WHEN (@isFormView = 1) THEN @jobActualDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobActualDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobActualDate, [JobActualDate]) END    
		   ,[JobActualTime]				= CASE WHEN (@isFormView = 1) THEN @jobActualTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobActualTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobActualTime, [JobActualTime]) END    
		   ,[ColorCD]					= CASE WHEN (@isFormView = 1) THEN @colorCD WHEN ((@isFormView = 0) AND (@colorCD=-100)) THEN NULL ELSE ISNULL(@colorCD, [ColorCD]) END
           ,[JobFor]					= CASE WHEN (@isFormView = 1) THEN @jobFor WHEN ((@isFormView = 0) AND (@jobFor='#M4PL#')) THEN NULL ELSE ISNULL(@jobFor, [JobFor]) END
           ,[JobFrom]					= CASE WHEN (@isFormView = 1) THEN @jobFrom WHEN ((@isFormView = 0) AND (@jobFrom='#M4PL#')) THEN NULL ELSE ISNULL(@jobFrom, [JobFrom]) END
		   ,[WindowStartTime]			= CASE WHEN (@isFormView = 1) THEN @windowStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowStartTime, [WindowStartTime]) END    
		   ,[WindowEndTime]				= CASE WHEN (@isFormView = 1) THEN @windowEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowEndTime, [WindowEndTime]) END    
           ,[JobFlag01]					= CASE WHEN (@isFormView = 1) THEN @jobFlag01 WHEN ((@isFormView = 0) AND (@jobFlag01='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag01, [JobFlag01]) END
           ,[JobFlag02]					= CASE WHEN (@isFormView = 1) THEN @jobFlag02 WHEN ((@isFormView = 0) AND (@jobFlag02='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag02, [JobFlag02]) END
           ,[JobFlag03]					= CASE WHEN (@isFormView = 1) THEN @jobFlag03 WHEN ((@isFormView = 0) AND (@jobFlag03='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag03, [JobFlag03]) END
           ,[JobFlag04]					= CASE WHEN (@isFormView = 1) THEN @jobFlag04 WHEN ((@isFormView = 0) AND (@jobFlag04='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag04, [JobFlag04]) END
           ,[JobFlag05]					= CASE WHEN (@isFormView = 1) THEN @jobFlag05 WHEN ((@isFormView = 0) AND (@jobFlag05='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag05, [JobFlag05]) END
           ,[JobFlag06]					= CASE WHEN (@isFormView = 1) THEN @jobFlag06 WHEN ((@isFormView = 0) AND (@jobFlag06='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag06, [JobFlag06]) END
           ,[JobFlag07]					= CASE WHEN (@isFormView = 1) THEN @jobFlag07 WHEN ((@isFormView = 0) AND (@jobFlag07='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag07, [JobFlag07]) END
           ,[JobFlag08]					= CASE WHEN (@isFormView = 1) THEN @jobFlag08 WHEN ((@isFormView = 0) AND (@jobFlag08='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag08, [JobFlag08]) END
           ,[JobFlag09]					= CASE WHEN (@isFormView = 1) THEN @jobFlag09 WHEN ((@isFormView = 0) AND (@jobFlag09='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag09, [JobFlag09]) END
           ,[JobFlag10]					= CASE WHEN (@isFormView = 1) THEN @jobFlag10 WHEN ((@isFormView = 0) AND (@jobFlag10='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag10, [JobFlag10]) END
           ,[JobFlag11]					= CASE WHEN (@isFormView = 1) THEN @jobFlag11 WHEN ((@isFormView = 0) AND (@jobFlag11='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag11, [JobFlag11]) END
           ,[JobFlag12]					= CASE WHEN (@isFormView = 1) THEN @jobFlag12 WHEN ((@isFormView = 0) AND (@jobFlag12='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag12, [JobFlag12]) END
           ,[JobFlag13]					= CASE WHEN (@isFormView = 1) THEN @jobFlag13 WHEN ((@isFormView = 0) AND (@jobFlag13='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag13, [JobFlag13]) END
           ,[JobFlag14]					= CASE WHEN (@isFormView = 1) THEN @jobFlag14 WHEN ((@isFormView = 0) AND (@jobFlag14='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag14, [JobFlag14]) END
           ,[JobFlag15]					= CASE WHEN (@isFormView = 1) THEN @jobFlag15 WHEN ((@isFormView = 0) AND (@jobFlag15='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag15, [JobFlag15]) END
           ,[JobFlag16]					= CASE WHEN (@isFormView = 1) THEN @jobFlag16 WHEN ((@isFormView = 0) AND (@jobFlag16='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag16, [JobFlag16]) END
           ,[JobFlag17]					= CASE WHEN (@isFormView = 1) THEN @jobFlag17 WHEN ((@isFormView = 0) AND (@jobFlag17='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag17, [JobFlag17]) END
           ,[JobFlag18]					= CASE WHEN (@isFormView = 1) THEN @jobFlag18 WHEN ((@isFormView = 0) AND (@jobFlag18='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag18, [JobFlag18]) END
           ,[JobFlag19]					= CASE WHEN (@isFormView = 1) THEN @jobFlag19 WHEN ((@isFormView = 0) AND (@jobFlag19='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag19, [JobFlag19]) END
           ,[JobFlag20]					= CASE WHEN (@isFormView = 1) THEN @jobFlag20 WHEN ((@isFormView = 0) AND (@jobFlag20='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag20, [JobFlag20]) END
		   ,[JobFlag21]					= CASE WHEN (@isFormView = 1) THEN @jobFlag21 WHEN ((@isFormView = 0) AND (@jobFlag21=-100)) THEN NULL ELSE ISNULL(@jobFlag21, [JobFlag21]) END
		   ,[JobFlag22]					= CASE WHEN (@isFormView = 1) THEN @jobFlag22 WHEN ((@isFormView = 0) AND (@jobFlag22=-100)) THEN NULL ELSE ISNULL(@jobFlag22, [JobFlag22]) END
		   ,[JobFlag23]					= CASE WHEN (@isFormView = 1) THEN @jobFlag23 WHEN ((@isFormView = 0) AND (@jobFlag23=-100)) THEN NULL ELSE ISNULL(@jobFlag23, [JobFlag23]) END
	WHERE	[JobID] = @id

	EXEC [dbo].[GetScnOrder] @userId, @roleId, 0, @id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
