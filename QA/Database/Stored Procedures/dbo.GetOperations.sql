SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get Operation for cache
-- Execution:                 EXEC [dbo].[GetOperations] 'EN',2269
-- Modified on:  
-- Modified Desc:  
-- =============================================                       
CREATE PROCEDURE [dbo].[GetOperations]   
@langCode NVARCHAR(10),
@lookupId INT                
AS                
BEGIN TRY                
  SET NOCOUNT ON;   
	 SELECT  msgType.LangCode
			,refOp.SysOptionName as SysRefName
			,msgType.[SysMsgtypeTitle] as LangName
			,msgType.[SysMsgTypeHeaderIcon] as Icon
		FROM [dbo].[SYSMS010Ref_MessageTypes] msgType (NOLOCK)  
		INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  msgType.SysRefId= refOp.Id
		WHERE msgType.LangCode = @langCode AND refOp.SysLookupId=  @lookupId
		ORDER BY refOp.SysSortOrder ASC
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
