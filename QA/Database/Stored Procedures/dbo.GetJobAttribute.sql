SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Attribute 
-- Execution:                 EXEC [dbo].[GetJobAttribute]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[GetJobAttribute]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.[Id]
		,job.[JobID]
		,job.[AjbLineOrder]
		,job.[AjbAttributeCode]
		,job.[AjbAttributeTitle]
		,job.[AjbAttributeQty]
		,job.[AjbUnitTypeId]
		,job.[AjbDefault]
		,job.[DateEntered]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateChanged]
		,job.[ChangedBy]
  FROM   [dbo].[JOBDL030Attributes] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
