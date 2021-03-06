SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrderOSD 
-- Execution:                 EXEC [dbo].[InsScnOrderOSD]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnOrderOSD]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cargoOSDID BIGINT = NULL
	,@oSDID BIGINT = NULL
	,@dateTime DATETIME2(7) = NULL
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@cgoSerialNumber NVARCHAR(255) = NULL
	,@oSDReasonID BIGINT = NULL
	,@oSDQty DECIMAL(18, 2) = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@editCD NVARCHAR(50) = NULL
	,@statusID NVARCHAR(30) = NULL
	,@cgoSeverityCode NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN014OrderOSD]
           ([CargoOSDID]
			,[OSDID]
			,[DateTime]
			,[CargoDetailID]
			,[CargoID]
			,[CgoSerialNumber]
			,[OSDReasonID]
			,[OSDQty]
			,[Notes]
			,[EditCD]
			,[StatusID]
			,[CgoSeverityCode])
     VALUES
           (@cargoOSDID
			,@oSDID
			,@dateTime
			,@cargoDetailID
			,@cargoID
			,@cgoSerialNumber
			,@oSDReasonID
			,@oSDQty
			,@notes
			,@editCD
			,@statusID
			,@cgoSeverityCode) 
	EXEC [dbo].[GetScnOrderOSD] @userId, @roleId,0 ,@cargoOSDID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
