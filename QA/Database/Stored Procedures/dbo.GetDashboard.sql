SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Get a Dashboard By Id
-- Execution:                 EXEC [dbo].[GetDashboard]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE [dbo].[GetDashboard]  
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
      ,rep.[DshMainModuleId]
      ,rep.[DshName]
      ,rep.[DshIsDefault]
      ,rep.[StatusId]
      ,rep.[DateEntered]
      ,rep.[EnteredBy]
      ,rep.[DateChanged]
      ,rep.[ChangedBy] 
 FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) rep  
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
