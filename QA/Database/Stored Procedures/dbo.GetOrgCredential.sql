SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a org credential 
-- Execution:                 EXEC [dbo].[GetOrgCredential]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetOrgCredential]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @entityName NVARCHAR(100), @attachmentCount INT
 SELECT @entityName=SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = 'ORGAN030Credentials';
 SELECT @attachmentCount=COUNT(Id) FROM [dbo].[SYSTM020Ref_Attachments] WHERE AttPrimaryRecordID = @id AND AttTableName = @entityName AND StatusId =1
 SELECT org.[Id]
       ,org.[OrgID]
       ,org.[CreItemNumber]
       ,org.[CreCode]
       ,org.[CreTitle]
       ,org.[CreExpDate]
	   ,org.[StatusId]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
	   ,@attachmentCount AS AttachmentCount
   FROM [dbo].[ORGAN030Credentials] org
   WHERE org.[Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
