SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get Id Ref and Lang Names for cache
-- Execution:                 EXEC [dbo].[GetIdRefLangNamesFromTable]
-- Modified on:  
-- Modified Desc:  
-- =============================================                        
CREATE PROCEDURE [dbo].[GetIdRefLangNamesFromTable]
@langCode NVARCHAR(10),
@lookupId INT
AS                
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @sqlQuery NVARCHAR(MAX) =  'SELECT refOp.[SysOptionName] as SysRefName
									,refOp.[SysDefault] as IsDefault
									,tbl.*
									FROM ' + [dbo].[fnGetTblNameByLkupId](@lookupId) +' (NOLOCK) tbl
									INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id = tbl.SysRefId
									WHERE refOp.LookupId = '''+ CAST(@lookupId as nvarchar(10)) + ''' AND tbl.LangCode = '''+ @langCode +
								    ''' ORDER BY refOp.[SysSortOrder] ASC'


 EXEC(@sqlQuery)
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
