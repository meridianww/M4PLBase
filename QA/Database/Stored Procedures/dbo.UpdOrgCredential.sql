SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org Credential
-- Execution:                 EXEC [dbo].[UpdOrgCredential]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:
-- Modified on:               05/03/2019(Nikhil) 
-- Modified Desc:			  Removed #M4PL# and -100  implementation for Update Query  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdOrgCredential]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@creItemNumber INT = NULL 
	,@creCode NVARCHAR(20) = NULL 
	,@creTitle NVARCHAR(50) = NULL 
	,@statusId INT = NULL
	,@creExpDate DATETIME2(7) = NULL 
	,@dateChanged DATETIME2(7) = NULL 
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @creItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  UPDATE  [dbo].[ORGAN030Credentials]
   SET   OrgId 			  =  ISNULL(@orgId, OrgId) 
        ,CreItemNumber 	  =  ISNULL(@updatedItemNumber, CreItemNumber)  
        ,CreCode 		  = ISNULL(@creCode, CreCode)
        ,CreTitle 		  = ISNULL(@creTitle, CreTitle) 
        ,CreExpDate 	  = CASE WHEN (CONVERT(CHAR(10), @creExpDate, 103)='01/01/1753') THEN NULL ELSE ISNULL(@creExpDate, CreExpDate ) END
        ,StatusId	 	  = ISNULL(@statusId, StatusId ) 
        ,DateChanged	  = @dateChanged  
        ,ChangedBy		  = @changedBy
  WHERE  Id = @id  
 EXEC [dbo].[GetOrgCredential] @userId, @roleId, @orgId, @id

	 END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
