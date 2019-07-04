SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Requirement List
-- Execution:                 EXEC [dbo].[GetScrRequirementList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetScrRequirementList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[RequirementID] AS Id
		,scr.[ProgramID]
		,scr.[RequirementLineItem]
		,scr.[RequirementCode]
		,scr.[RequirementTitle]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR012RequirementList] scr
  WHERE scr.[RequirementID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
