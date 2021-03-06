SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Ins Dashboard
-- Execution:                 EXEC [dbo].[InsDashboard]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsDashboard]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@mainModuleId INT = NULL
	,@dashboardName NVARCHAR(100) = NULL
	,@dashboardDesc NVARCHAR(255) = NULL
	,@isDefault BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
IF NOT EXISTS(SELECT DshMainModuleId FROM [dbo].[SYSTM000Ref_Dashboard] WHERE [DshMainModuleId] = @mainModuleId)
	BEGIN
		SET @isDefault =1  --first dashboard should be default
	END
   INSERT INTO [dbo].[SYSTM000Ref_Dashboard]
           ([OrganizationId]
           ,[DshMainModuleId]
           ,[DshName]
           ,[DshDescription]
           ,[DshIsDefault]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		    (@orgId
           ,@mainModuleId
           ,@dashboardName
           ,@dashboardDesc
           ,@isDefault
           ,@statusId
           ,@dateEntered
           ,@enteredBy)  
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetDashboard] @userId, @roleId,  @orgId,  'EN',  @currentId 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
