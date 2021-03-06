SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScrInfoList
-- Execution:                 EXEC [dbo].[UpdScrInfoList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScrInfoList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@infoListID BIGINT = NULL
	,@infoListDesc NVARCHAR(MAX) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCR010InfoList]
      SET   [InfoListID]	= CASE WHEN (@isFormView = 1) THEN @infoListID WHEN ((@isFormView = 0) AND (@infoListID=-100)) THEN NULL ELSE ISNULL(@infoListID, [InfoListID]) END
           ,[InfoListDesc]	= CASE WHEN (@isFormView = 1) THEN @infoListDesc WHEN ((@isFormView = 0) AND (@infoListDesc='#M4PL#')) THEN NULL ELSE ISNULL(@infoListDesc, [InfoListDesc]) END
	WHERE	[InfoListID] = @id

	EXEC [dbo].[GetScrInfoList] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
