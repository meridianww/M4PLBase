SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Cargo
-- Execution:                 EXEC [dbo].[InsJobCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsJobCargo]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@cgoLineItem int
	,@cgoPartNumCode nvarchar(30)
	,@cgoTitle nvarchar(50)
	,@cgoSerialNumber nvarchar(255)
	,@cgoPackagingType INT
	,@cgoMasterCartonLabel nvarchar(30)
	,@cgoWeight decimal(18, 2)  
	,@cgoWeightUnits NVARCHAR(20)= NULL  
	,@cgoLength decimal(18, 2)  
	,@cgoWidth decimal(18, 2)  
	,@cgoHeight decimal(18, 2)  
	,@cgoVolumeUnits NVARCHAR(20)= NULL
	,@cgoCubes decimal(18, 2)  = NULL
	,@cgoQtyExpected INT= NULL
	,@cgoQtyOnHand INT= NULL
	,@cgoQtyDamaged INT= NULL
	,@cgoQtyOnHold INT= NULL
	,@cgoQtyShortOver INT= NULL
	,@cgoQtyOver INT = NULL
	,@cgoQtyOrdered INT = NULL
	,@cgoQtyUnits nvarchar(20)= NULL
	,@cgoReasonCodeOSD nvarchar(20)  
	,@cgoReasonCodeHold nvarchar(20)  
	,@cgoSeverityCode int
	,@cgoLatitude NVARCHAR(50) = NULL
	,@cgoLongitude NVARCHAR(50) = NULL
	,@statusId int = NULL
	,@cgoProcessingFlags nvarchar(20)
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7)
	,@CgoComment VARCHAR(5000)
	,@CgoDateLastScan datetime2(7) = NULL
	)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @cgoLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL010Cargo]
           (  [JobID]
			  ,[CgoLineItem]
			  ,[CgoPartNumCode]
			  ,[CgoTitle]
			  ,[CgoSerialNumber]
			  ,[CgoPackagingTypeId]
			  ,[CgoMasterCartonLabel]
			  ,[CgoWeight]
			  ,[CgoWeightUnitsId]
			  ,[CgoLength]
			  ,[CgoWidth]
			  ,[CgoHeight]
			  ,[CgoVolumeUnitsId]
			  ,[CgoCubes]
			  ,[CgoQtyExpected]
			  ,[CgoQtyOnHand]
			  ,[CgoQtyDamaged]
			  ,[CgoQtyOnHold]
			  ,[CgoQtyShortOver]
			  ,[CgoQtyOver]
	          ,[CgoQtyOrdered]
			  ,[CgoQtyUnitsId]
			  ,[CgoReasonCodeOSD]
			  ,[CgoReasonCodeHold]
			  ,[CgoSeverityCode]
			  ,[CgoLatitude]
			  ,[CgoLongitude]
			  ,[StatusId]
			 -- ,[CgoProcessingFlags]
			,[EnteredBy]
			,[DateEntered]
			,[CgoComment]
			,[CgoDateLastScan]
			)
     VALUES
           (@jobId 
			,@updatedItemNumber 
			,@cgoPartNumCode
			,@cgoTitle 
			,@cgoSerialNumber 
			,@cgoPackagingType 
			,@cgoMasterCartonLabel
			,@cgoWeight 
		    ,@cgoWeightUnits   
		    ,@cgoLength  
		    ,@cgoWidth 
		    ,@cgoHeight  
		    ,@cgoVolumeUnits
            ,@cgoCubes 
		    ,@cgoQtyExpected 
			,@cgoQtyOnHand 
			,@cgoQtyDamaged
			,@cgoQtyOnHold 
			,@cgoQtyShortOver
			,@cgoQtyOver
	        ,@cgoQtyOrdered
			,@cgoQtyUnits 
			,@cgoReasonCodeOSD 
            ,@cgoReasonCodeHold
			,@cgoSeverityCode 
			,@cgoLatitude
			,@cgoLongitude
			,@statusId 
			--,@cgoProcessingFlags 
		   	,@enteredBy
		   	,@dateEntered
			,@CgoComment
			,@CgoDateLastScan
			)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL010Cargo] WHERE Id = @currentId;   
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
