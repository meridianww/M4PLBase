SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Upd a Dashboard
-- Execution:                 EXEC [dbo].[UpdDashboard]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdDashboard]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@mainModuleId INT = NULL
	,@dashboardName NVARCHAR(100) = NULL
	,@dashboardDesc NVARCHAR(255) = NULL
	,@isDefault BIT = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  UPDATE [dbo].[SYSTM000Ref_Dashboard]
			SET   [OrganizationId]	 =	 ISNULL(@orgId, OrganizationId)
			,[DshMainModuleId]			 =  ISNULL(@mainModuleId, DshMainModuleId)
			,DshName         =	 ISNULL(@dashboardName, DshName)
			,DshDescription  =	 ISNULL(@dashboardDesc, DshDescription)
			,[DshIsDefault]             =	 ISNULL(@isDefault, DshIsDefault)
			,[StatusId]				 =	 ISNULL(@statusId, StatusId)
			,[DateChanged]           =	 @dateChanged
			,[ChangedBy]             =	 @changedBy		  
     WHERE   [Id] =	@id		 
	EXEC [dbo].[GetDashboard] @userId, @roleId,  @orgId,  'EN', @id  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
