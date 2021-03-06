SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrderService
-- Execution:                 EXEC [dbo].[UpdScnOrderService]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnOrderService]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@servicesID BIGINT = NULL
	,@servicesCode NVARCHAR(50) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN013OrderServices]
      SET   [ServicesID]	= CASE WHEN (@isFormView = 1) THEN @servicesID WHEN ((@isFormView = 0) AND (@servicesID=-100)) THEN NULL ELSE ISNULL(@servicesID, [ServicesID]) END
		   ,[ServicesCode]	= CASE WHEN (@isFormView = 1) THEN @servicesCode WHEN ((@isFormView = 0) AND (@servicesCode='#M4PL#')) THEN NULL ELSE ISNULL(@servicesCode, [ServicesCode]) END
           ,[JobID]			= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
           ,[Notes]			= CASE WHEN (@isFormView = 1) THEN @notes WHEN ((@isFormView = 0) AND (@notes='#M4PL#')) THEN NULL ELSE ISNULL(@notes, [Notes]) END
           ,[Complete]		= CASE WHEN (@isFormView = 1) THEN @complete WHEN ((@isFormView = 0) AND (@complete='#M4PL#')) THEN NULL ELSE ISNULL(@complete, [Complete]) END
	WHERE	[ServicesID] = @id

	EXEC [dbo].[GetScnOrderService] @userId, @roleId,0 ,@servicesID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
