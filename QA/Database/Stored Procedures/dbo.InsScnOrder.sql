SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrder 
-- Execution:                 EXEC [dbo].[InsScnOrder]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnOrder]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
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
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN000Order]
           ([JobID]
			,[ProgramID]
			,[RouteID]
			,[DriverID]
			,[JobDeviceID]
			,[JobStop]
			,[JobOrderID]
			,[JobManifestID]
			,[JobCarrierID]
			,[JobReturnReasonID]
			,[JobStatusCD]
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
			,[JobOriginStreetAddress]
			,[JobOriginCity]
			,[JobOriginStateProvince]
			,[JobOriginPostalCode]
			,[JobOriginCountry]
			,[JobLongitude]
			,[JobLatitude]
			,[JobSignLongitude]
			,[JobSignLatitude]
			,[JobSignText]
			,[JobScheduledDate]
			,[JobScheduledTime]
			,[JobEstimatedDate]
			,[JobEstimatedTime]
			,[JobActualDate]
			,[JobActualTime]
			,[ColorCD]
			,[JobFor]
			,[JobFrom]
			,[WindowStartTime]
			,[WindowEndTime]
			,[JobFlag01]
			,[JobFlag02]
			,[JobFlag03]
			,[JobFlag04]
			,[JobFlag05]
			,[JobFlag06]
			,[JobFlag07]
			,[JobFlag08]
			,[JobFlag09]
			,[JobFlag10]
			,[JobFlag11]
			,[JobFlag12]
			,[JobFlag13]
			,[JobFlag14]
			,[JobFlag15]
			,[JobFlag16]
			,[JobFlag17]
			,[JobFlag18]
			,[JobFlag19]
			,[JobFlag20]
			,[JobFlag21]
			,[JobFlag22]
			,[JobFlag23])
     VALUES
           (@jobID
			,@programID
			,@routeID
			,@driverID
			,@jobDeviceID
			,@jobStop
			,@jobOrderID
			,@jobManifestID
			,@jobCarrierID
			,@jobReturnReasonID
			,@jobStatusCD
			,@jobOriginSiteCode
			,@jobOriginSiteName
			,@jobDeliverySitePOC
			,@jobDeliverySitePOC2
			,@jobDeliveryStreetAddress
			,@jobDeliveryStreetAddress2
			,@jobDeliveryCity
			,@jobDeliveryStateProvince
			,@jobDeliveryPostalCode
			,@jobDeliveryCountry
			,@jobDeliverySitePOCPhone
			,@jobDeliverySitePOCPhone2
			,@jobDeliveryPhoneHm 
			,@jobDeliverySitePOCEmail
			,@jobDeliverySitePOCEmail2
			,@jobOriginStreetAddress
			,@jobOriginCity
			,@jobOriginStateProvince
			,@jobOriginPostalCode
			,@jobOriginCountry
			,@jobLongitude
			,@jobLatitude
			,@jobSignLongitude
			,@jobSignLatitude
			,@jobSignText
			,@jobScheduledDate
			,@jobScheduledTime
			,@jobEstimatedDate
			,@jobEstimatedTime
			,@jobActualDate
			,@jobActualTime
			,@colorCD
			,@jobFor
			,@jobFrom
			,@windowStartTime
			,@windowEndTime
			,@jobFlag01
			,@jobFlag02
			,@jobFlag03
			,@jobFlag04
			,@jobFlag05
			,@jobFlag06
			,@jobFlag07
			,@jobFlag08
			,@jobFlag09
			,@jobFlag10
			,@jobFlag11
			,@jobFlag12
			,@jobFlag13
			,@jobFlag14
			,@jobFlag15
			,@jobFlag16
			,@jobFlag17
			,@jobFlag18
			,@jobFlag19
			,@jobFlag20
			,@jobFlag21
			,@jobFlag22
			,@jobFlag23) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnOrder] @userId, @roleId,0 ,@jobID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
