SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Return Reason List
-- Execution:                 EXEC [dbo].[GetScrReturnReasonList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetScrReturnReasonList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[ReturnReasonID] AS Id
		,scr.[ProgramID]
		,scr.[ReturnReasonLineItem]
		,scr.[ReturnReasonCode]
		,scr.[ReturnReasonTitle]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR014ReturnReasonList] scr
  WHERE scr.[ReturnReasonID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
