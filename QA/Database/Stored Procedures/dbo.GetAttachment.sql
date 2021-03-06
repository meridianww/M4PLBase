SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/11/2018      
-- Description:               Get a Attachment
-- Execution:                 EXEC [dbo].[GetAttachment]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetAttachment]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT att.[Id]
        ,att.[AttTableName]
        ,att.[AttPrimaryRecordID]
        ,att.[AttItemNumber]
        ,att.[AttTitle]
        ,att.[AttTypeId]
        ,att.[AttFileName]
        ,att.[AttData]
        ,att.[DateEntered]
        ,att.[EnteredBy]
        ,att.[DateChanged]
        ,att.[ChangedBy]
        ,att.[AttDownloadDate]
        ,att.[AttDownloadedDate]
        ,att.[AttDownloadedBy]
        
  FROM [dbo].[SYSTM020Ref_Attachments] att
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
