SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Upd a Report
-- Execution:                 EXEC [dbo].[UpdReport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdReport]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id BIGINT   
	,@orgId BIGINT = NULL  
	,@mainModuleId INT = NULL  
	,@reportName NVARCHAR(100) = NULL  
	,@reportDesc NVARCHAR(255) = NULL  
	,@isDefault BIT = NULL  
	,@statusId INT = NULL 
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  UPDATE [dbo].[SYSTM000Ref_Report]  
   SET [OrganizationId]   =  CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrganizationId)  END
   ,[RprtMainModuleId]    =  CASE WHEN (@isFormView = 1) THEN @mainModuleId WHEN ((@isFormView = 0) AND (@mainModuleId=-100)) THEN NULL ELSE ISNULL(@mainModuleId, RprtMainModuleId)   END 
   ,[RprtName]            =  CASE WHEN (@isFormView = 1) THEN @reportName WHEN ((@isFormView = 0) AND (@reportName='#M4PL#')) THEN NULL ELSE ISNULL(@reportName, RprtName)    END
   ,[RprtDescription]     =  CASE WHEN (@isFormView = 1) THEN @reportDesc WHEN ((@isFormView = 0) AND (@reportDesc='#M4PL#')) THEN NULL ELSE ISNULL(@reportDesc, RprtDescription)  END  
   ,[RprtIsDefault]       =  ISNULL(@isDefault, RprtIsDefault)
   ,[StatusId]			  =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)  END
   ,[DateChanged]         =  @dateChanged  
   ,[ChangedBy]           =  @changedBy      
     WHERE   [Id] = @id     
 EXEC [dbo].[GetReport] @userId, @roleId,  @orgId,  'EN', @id    
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
