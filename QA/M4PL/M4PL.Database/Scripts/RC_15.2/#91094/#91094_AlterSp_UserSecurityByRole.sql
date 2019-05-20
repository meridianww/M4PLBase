USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[UpdSecurityByRole]    Script Date: 5/16/2019 1:04:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a security by role 
-- Execution:                 EXEC [dbo].[UpdSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc: 
-- Modified on:               05/10/2019( Nikhil)
-- Modified Desc:             Modified UPDATE statment to remove #M4PL# and -100  to pass them  as orignal values ,Line(43-49)   
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@secLineOrder int  = NULL
	,@mainModuleId int = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@actRoleId BIGINT = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 DECLARE @savedRoleCode NVARCHAR(25)
EXEC [dbo].[ResetItemNumber] @userId, @id, @actRoleId, @entity, @secLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 UPDATE [dbo].[SYSTM000SecurityByRole]
		SET 
			 [SecLineOrder]          = ISNULL(@updatedItemNumber, SecLineOrder) 
			,[SecMainModuleId]       = ISNULL(@mainModuleId, SecMainModuleId) 
			,[SecMenuOptionLevelId]  = ISNULL(@menuOptionLevelId, SecMenuOptionLevelId)
			,[SecMenuAccessLevelId]  = ISNULL(@menuAccessLevelId, SecMenuAccessLevelId)
			,[StatusId]			     = ISNULL(@statusId, StatusId) 
			,[DateChanged]           = ISNULL(@dateChanged,DateChanged)
			,[ChangedBy]             = ISNULL(@changedBy,ChangedBy)
	 WHERE	 [Id] = @id

	EXECUTE  GetSecurityByRole @userId,@roleId,@orgId,@id;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH