
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Cargo
-- Execution:                 EXEC [dbo].[UpdJobCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdJobCargo]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@jobId bigint  = NULL
	,@cgoLineItem int= NULL
	,@cgoPartNumCode nvarchar(30)= NULL
	,@cgoTitle nvarchar(50)= NULL
	,@cgoSerialNumber nvarchar(255)= NULL
	,@cgoPackagingType INT = NULL
	,@cgoMasterCartonLabel nvarchar(30) = NULL
	,@cgoWeight decimal(18, 2)  = NULL
	,@cgoWeightUnits NVARCHAR(20)= NULL  
	,@cgoLength decimal(18, 2)  = NULL
	,@cgoWidth decimal(18, 2)  = NULL
	,@cgoHeight decimal(18, 2)  = NULL
	,@cgoVolumeUnits NVARCHAR(20)= NULL
	,@cgoCubes decimal(18, 2)  = NULL
	,@cgoQtyExpected decimal(18, 2)= NULL
	,@cgoQtyOnHand decimal(18, 2)= NULL
	,@cgoQtyDamaged decimal(18, 2)= NULL
	,@cgoQtyOnHold decimal(18, 2)= NULL
	,@cgoQtyShortOver decimal(18, 2) = NULL
	,@cgoQtyUnits nvarchar(20)= NULL
	,@cgoReasonCodeOSD nvarchar(20) = NULL 
	,@cgoReasonCodeHold nvarchar(20)  = NULL
	,@cgoSeverityCode int= NULL
	,@cgoLatitude NVARCHAR(50) = NULL
	,@cgoLongitude NVARCHAR(50) = NULL
	,@statusId int = NULL
	,@cgoProcessingFlags nvarchar(20)= NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;
 
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @cgoLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 UPDATE [dbo].[JOBDL010Cargo]
		SET  [JobID]                 = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[CgoLineItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CgoLineItem) END
			,[CgoPartNumCode]        = CASE WHEN (@isFormView = 1) THEN @cgoPartNumCode WHEN ((@isFormView = 0) AND (@cgoPartNumCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPartNumCode, CgoPartNumCode) END
			,[CgoTitle]              = CASE WHEN (@isFormView = 1) THEN @cgoTitle WHEN ((@isFormView = 0) AND (@cgoTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cgoTitle, CgoTitle) END
			,[CgoSerialNumber]       = CASE WHEN (@isFormView = 1) THEN @cgoSerialNumber WHEN ((@isFormView = 0) AND (@cgoSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialNumber, CgoSerialNumber) END
			,[CgoPackagingTypeID]      = CASE WHEN (@isFormView = 1) THEN @cgoPackagingType WHEN ((@isFormView = 0) AND (@cgoPackagingType='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPackagingType,CgoPackagingType) END
			,[CgoMasterCartonLabel]  = CASE WHEN (@isFormView = 1) THEN @cgoMasterCartonLabel WHEN ((@isFormView = 0) AND (@cgoMasterCartonLabel='#M4PL#')) THEN NULL ELSE ISNULL(@cgoMasterCartonLabel, CgoMasterCartonLabel) END
			,[CgoWeight]             = CASE WHEN (@isFormView = 1) THEN @cgoWeight WHEN ((@isFormView = 0) AND (@cgoWeight=-100.00)) THEN NULL ELSE ISNULL(@cgoWeight,CgoWeight) END  
            ,[CgoWeightUnitsId]        = CASE WHEN (@isFormView = 1) THEN @cgoWeightUnits WHEN ((@isFormView = 0) AND (@cgoWeightUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoWeightUnits,CgoWeightUnits) END  
            ,[CgoLength]             = CASE WHEN (@isFormView = 1) THEN @cgoLength WHEN ((@isFormView = 0) AND (@cgoLength=-100.00)) THEN NULL ELSE ISNULL(@cgoLength,CgoLength) END  
            ,[CgoWidth]              = CASE WHEN (@isFormView = 1) THEN @cgoWidth WHEN ((@isFormView = 0) AND (@cgoWidth=-100.00)) THEN NULL ELSE ISNULL(@cgoWidth,CgoWidth) END  
            ,[CgoHeight]             = CASE WHEN (@isFormView = 1) THEN @cgoHeight WHEN ((@isFormView = 0) AND (@cgoHeight=-100.00)) THEN NULL ELSE ISNULL(@cgoHeight,CgoHeight) END  
            ,[CgoVolumeUnitsId]        = CASE WHEN (@isFormView = 1) THEN @cgoVolumeUnits WHEN ((@isFormView = 0) AND (@cgoVolumeUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoVolumeUnits,CgoVolumeUnits) END  
            ,[CgoCubes]              = CASE WHEN (@isFormView = 1) THEN @cgoCubes WHEN ((@isFormView = 0) AND (@cgoCubes=-100.00)) THEN NULL ELSE ISNULL(@cgoCubes,CgoCubes) END  
            ,[CgoQtyExpected]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyExpected WHEN ((@isFormView = 0) AND (@cgoQtyExpected=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyExpected, CgoQtyExpected) END
			,[CgoQtyOnHand]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHand WHEN ((@isFormView = 0) AND (@cgoQtyOnHand=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHand, CgoQtyOnHand) END
			,[CgoQtyDamaged]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyDamaged WHEN ((@isFormView = 0) AND (@cgoQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyDamaged, CgoQtyDamaged) END
			,[CgoQtyOnHold]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHold WHEN ((@isFormView = 0) AND (@cgoQtyOnHold=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHold, CgoQtyOnHold) END
			,[CgoQtyShortOver]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyShortOver WHEN ((@isFormView = 0) AND (@cgoQtyShortOver=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyShortOver, CgoQtyShortOver) END
			,[CgoQtyUnitsId]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyUnits WHEN ((@isFormView = 0) AND (@cgoQtyUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoQtyUnits, CgoQtyUnits) END
	        ,[CgoReasonCodeOSD]      = CASE WHEN (@isFormView = 1) THEN @cgoReasonCodeOSD WHEN ((@isFormView = 0) AND (@cgoReasonCodeOSD='#M4PL#')) THEN NULL ELSE ISNULL(@cgoReasonCodeOSD,CgoReasonCodeOSD) END  
            ,[CgoReasonCodeHold]     = CASE WHEN (@isFormView = 1) THEN @cgoReasonCodeHold WHEN ((@isFormView = 0) AND (@cgoReasonCodeHold='#M4PL#')) THEN NULL ELSE ISNULL(@cgoReasonCodeHold,CgoReasonCodeHold) END  
			,[CgoSeverityCode]       = CASE WHEN (@isFormView = 1) THEN @cgoSeverityCode WHEN ((@isFormView = 0) AND (@cgoSeverityCode=-100)) THEN NULL ELSE ISNULL(@cgoSeverityCode, CgoSeverityCode) END
            ,[CgoLatitude]     = CASE WHEN (@isFormView = 1) THEN @cgoLatitude WHEN ((@isFormView = 0) AND (@cgoLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLatitude,CgoLatitude) END  
            ,[CgoLongitude]     = CASE WHEN (@isFormView = 1) THEN @cgoLongitude WHEN ((@isFormView = 0) AND (@cgoLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLongitude,CgoLongitude) END  
			--,[CgoProcessingFlags]    = CASE WHEN (@isFormView = 1) THEN @cgoProcessingFlags WHEN ((@isFormView = 0) AND (@cgoProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProcessingFlags, CgoProcessingFlags) END
			,[StatusId]			     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[ChangedBy]             = @changedBy
			,[DateChanged]           = @dateChanged
	 WHERE   [Id] = @id;

  -- Below line to update ShortOver(Doing here because in GridView BatchEdit ShortOver was not getting updated)
	UPDATE [dbo].[JOBDL010Cargo] SET [CgoQtyShortOver] = (ISNULL([CgoQtyExpected], 0) - (ISNULL([CgoQtyOnHand], 0) + ISNULL([CgoQtyDamaged], 0) + ISNULL([CgoQtyOnHold], 0))) WHERE [Id] = @id;

	SELECT  job.[Id]
		,job.[JobID]
      ,job.[CgoLineItem]
      ,job.[CgoPartNumCode]
      ,job.[CgoTitle]
      ,job.[CgoSerialNumber]
      ,job.[CgoPackagingTypeID]
      ,job.[CgoWeight]
      ,job.[CgoWeightUnitsId]
      ,job.[CgoLength]
      ,job.[CgoWidth]
      ,job.[CgoHeight]
      ,job.[CgoVolumeUnitsId]
      ,job.[CgoCubes]
      ,job.[CgoNotes]
      ,job.[CgoQtyExpected]
      ,job.[CgoQtyOnHand]
      ,job.[CgoQtyDamaged]
      ,job.[CgoQtyOnHold]
	  ,job.[CgoQtyShortOver]
      ,job.[CgoQtyUnitsId]
      ,job.[CgoReasonCodeOSD]
      ,job.[CgoReasonCodeHold]
      ,job.[CgoSeverityCode]
	  ,job.[CgoLatitude]
      ,job.[CgoLongitude]
      ,job.[StatusId]
     -- ,job.[CgoProcessingFlags]
      ,job.[EnteredBy]
      ,job.[DateEntered]
      ,job.[ChangedBy]
      ,job.[DateChanged]
  FROM   [dbo].[JOBDL010Cargo] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
