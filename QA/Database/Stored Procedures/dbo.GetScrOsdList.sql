SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Osd List
-- Execution:                 EXEC [dbo].[GetScrOsdList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetScrOsdList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[OSDID] as Id
		,scr.[ProgramID]
		,scr.[OSDItemNumber]
		,scr.[OSDCode]
		,scr.[OSDTitle]
		,scr.[OSDType]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR011OSDList] scr
  WHERE scr.[OSDID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
