SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               01/17/2018      
-- Description:               Get Lookup ids for deleted system reference recordsIds for update the cache
-- Execution:                 EXEC [dbo].[GetDeletedRecordLookUpIds]
-- Modified on:  
-- Modified Desc:  
-- =============================================                         
CREATE PROCEDURE [dbo].[GetDeletedRecordLookUpIds] 
@ids NVARCHAR(MAX)
AS                
BEGIN TRY                
 SET NOCOUNT ON; 

   SELECT DISTINCT ref.SysLookupId as SysRefId FROM dbo.SYSTM000Ref_Options(NOLOCK) ref
   INNER JOIN dbo.fnSplitString(@ids,',') rec ON ref.Id = rec.Item
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
