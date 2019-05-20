USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgActSubSecurityByRole]    Script Date: 5/16/2019 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a org act subsecurity by role 
-- Execution:                 EXEC [dbo].[UpdOrgActSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified on:               05/16/2019( Nikhil)
-- Modified Desc:             Modified UPDATE statment to remove #M4PL# and -100  to pass them  as orignal values ,Line(37-43)   
-- =============================================   
ALTER PROCEDURE  [dbo].[UpdOrgActSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@secByRoleId bigint = NULL
	,@refTableName nvarchar(100) = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[ORGAN022Act_SubSecurityByRole]
		SET  [OrgSecurityByRoleId]		=  ISNULL(@secByRoleId, [OrgSecurityByRoleId]) 
			,[RefTableName]				=  ISNULL(@refTableName, RefTableName) 
			,[SubsMenuOptionLevelId]	=  ISNULL(@menuOptionLevelId,SubsMenuOptionLevelId) 
			,[SubsMenuAccessLevelId]	=  ISNULL(@menuAccessLevelId, SubsMenuAccessLevelId)
			,[StatusId]					=  ISNULL(@statusId, StatusId) 
			,[DateChanged]				=  ISNULL(@dateChanged,DateChanged)
			,[ChangedBy]				=  ISNULL(@changedBy,ChangedBy)
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		 ,syst.[OrgSecurityByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[ORGAN022Act_SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH