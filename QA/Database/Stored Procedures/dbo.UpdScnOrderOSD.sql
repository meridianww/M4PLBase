SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrderOSD
-- Execution:                 EXEC [dbo].[UpdScnOrderOSD]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnOrderOSD]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
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
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN014OrderOSD]
      SET   [CargoOSDID] = CASE WHEN (@isFormView = 1) THEN @cargoOSDID WHEN ((@isFormView = 0) AND (@cargoOSDID=-100)) THEN NULL ELSE ISNULL(@cargoOSDID, [CargoOSDID]) END
		   ,[OSDID] = CASE WHEN (@isFormView = 1) THEN @oSDID WHEN ((@isFormView = 0) AND (@oSDID=-100)) THEN NULL ELSE ISNULL(@oSDID, [OSDID]) END
		   ,[DateTime] = CASE WHEN (@isFormView = 1) THEN @dateTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @dateTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@dateTime, [DateTime]) END    
		   ,[CargoDetailID] = CASE WHEN (@isFormView = 1) THEN @cargoDetailID WHEN ((@isFormView = 0) AND (@cargoDetailID=-100)) THEN NULL ELSE ISNULL(@cargoDetailID, [CargoDetailID]) END
		   ,[CargoID] = CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[CgoSerialNumber] = CASE WHEN (@isFormView = 1) THEN @cgoSerialNumber WHEN ((@isFormView = 0) AND (@cgoSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialNumber, [CgoSerialNumber]) END
		   ,[OSDReasonID] = CASE WHEN (@isFormView = 1) THEN @oSDReasonID WHEN ((@isFormView = 0) AND (@oSDReasonID=-100)) THEN NULL ELSE ISNULL(@oSDReasonID, [OSDReasonID]) END
		   ,[OSDQty] = CASE WHEN (@isFormView = 1) THEN @oSDQty WHEN ((@isFormView = 0) AND (@oSDQty=-100.00)) THEN NULL ELSE ISNULL(@oSDQty, [OSDQty]) END
		   ,[Notes] = CASE WHEN (@isFormView = 1) THEN @notes WHEN ((@isFormView = 0) AND (@notes='#M4PL#')) THEN NULL ELSE ISNULL(@notes, [Notes]) END
		   ,[EditCD] = CASE WHEN (@isFormView = 1) THEN @editCD WHEN ((@isFormView = 0) AND (@editCD='#M4PL#')) THEN NULL ELSE ISNULL(@editCD, [EditCD]) END
		   ,[StatusID] = CASE WHEN (@isFormView = 1) THEN @statusID WHEN ((@isFormView = 0) AND (@statusID='#M4PL#')) THEN NULL ELSE ISNULL(@statusID, [StatusID]) END
		   ,[CgoSeverityCode] = CASE WHEN (@isFormView = 1) THEN @cgoSeverityCode WHEN ((@isFormView = 0) AND (@cgoSeverityCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSeverityCode, [CgoSeverityCode]) END
	WHERE	[CargoOSDID] = @id

	EXEC [dbo].[GetScnOrderOSD] @userId, @roleId,0 ,@cargoOSDID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
