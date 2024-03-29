SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/01/2018      
-- Description:               Get a report By Id
-- Execution:                 EXEC [dbo].[GetReport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE [dbo].[GetReport]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @langCode NVARCHAR(10),    
 @id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
 SELECT rep.[Id]  
      ,rep.[OrganizationId]  
      ,rep.[RprtMainModuleId]  
      ,rep.[RprtName]  
      ,rep.[RprtIsDefault]  
      ,rep.[StatusId]
      ,rep.[DateEntered]  
      ,rep.[EnteredBy]  
      ,rep.[DateChanged]  
      ,rep.[ChangedBy]   
 FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) rep    
 WHERE rep.[OrganizationId] = @orgId     
 AND rep.Id=@id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
