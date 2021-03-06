SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get a System Account
-- Execution:                 EXEC [dbo].[GetSystemAccount] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[GetSystemAccount]    
	@userId BIGINT,    
	@roleId BIGINT,    
	@orgId BIGINT,   
	@langCode NVARCHAR(10),        
	@id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
  SELECT [Id]    
      ,[SysUserContactID]    
      ,[SysScreenName]    
      ,[SysPassword]    
      ,[SysOrgId]    
      ,[SysOrgRefRoleId]    
      ,[IsSysAdmin]    
      ,[SysAttempts]    
      ,[SysLoggedIn]    
      ,[SysLoggedInCount]    
      ,[SysDateLastAttempt]    
      ,[SysLoggedInStart]    
      ,[SysLoggedInEnd]    
      ,[StatusId]    
      ,[DateEntered]    
      ,[EnteredBy]    
      ,[DateChanged]    
      ,[ChangedBy]   
  FROM [dbo].[SYSTM000OpnSezMe]    
 WHERE [Id]=@id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
