SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScrGatewayList
-- Execution:                 EXEC [dbo].[UpdScrGatewayList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScrGatewayList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@gatewayStatusID BIGINT = NULL
	,@programID BIGINT = NULL
	,@gatewayCode NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCR016GatewayList]
      SET   [GatewayStatusID]	= CASE WHEN (@isFormView = 1) THEN @gatewayStatusID WHEN ((@isFormView = 0) AND (@gatewayStatusID=-100)) THEN NULL ELSE ISNULL(@gatewayStatusID, [GatewayStatusID]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID  , [ProgramID]) END
           ,[GatewayCode]		= CASE WHEN (@isFormView = 1) THEN @gatewayCode WHEN ((@isFormView = 0) AND (@gatewayCode='#M4PL#')) THEN NULL ELSE ISNULL(@gatewayCode, [GatewayCode]) END
	WHERE	[GatewayStatusID]   = @id

	EXEC [dbo].[GetScrGatewayList] @userId, @roleId, 0 ,@gatewayStatusID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
