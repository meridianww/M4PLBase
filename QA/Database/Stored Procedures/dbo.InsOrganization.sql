SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a organization
-- Execution:                 EXEC [dbo].[InsOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[InsOrganization]		  
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgCode NVARCHAR(25) = NULL
	,@orgTitle NVARCHAR(50) = NULL 
	,@orgGroupId INT  = NULL
	,@orgSortOrder INT  = NULL
	,@statusId INT  = NULL
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@orgContactId BIGINT  = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = null   
	EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @orgSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN000Master]
           ([OrgCode]
           ,[OrgTitle]
           ,[OrgGroupId]
           ,[OrgSortOrder]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[OrgContactId])
     VALUES
		   (@orgCode
           ,@orgTitle
           ,@orgGroupId  
           ,@updatedItemNumber   
           ,@statusId   
           ,@dateEntered  
           ,@enteredBy    
           ,@orgContactId) 		
		   SET @currentId = SCOPE_IDENTITY();

	-- Below to insert Ref Roles rows in Act Roles
	 EXEC [dbo].[CopyRefRoles] @currentId, @enteredBy   

	 -- INSERT Dashboard
	INSERT INTO [dbo].[SYSTM000Ref_Dashboard]
		  ([OrganizationId]
		  ,[DshMainModuleId]
		  ,[DshName]
		  ,[DshTemplate]
		  ,[DshDescription]
		  ,[DshIsDefault]
		  ,[StatusId]
		  ,[DateEntered]
		  ,[EnteredBy]
		  ,[DateChanged]
		  ,[ChangedBy])
		SELECT  @currentId
		  ,[DshMainModuleId]
		  ,[DshName]
		  ,[DshTemplate]
		  ,[DshDescription]
		  ,[DshIsDefault]
		  ,[StatusId]
		  ,[DateEntered]
		  ,[EnteredBy]
		  ,[DateChanged]
		  ,[ChangedBy]
		  FROM [dbo].[SYSTM000Ref_Dashboard] 
		  WHERE OrganizationId = 0 AND DshMainModuleId=0

     -- Get Organization Data
	 EXEC [dbo].[GetOrganization] @userId , @roleId, @currentId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
