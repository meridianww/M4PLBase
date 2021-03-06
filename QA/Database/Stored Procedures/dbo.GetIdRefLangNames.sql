SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan        
-- Create date:               05/17/2018      
-- Description:               Get Id Ref and Lang Names for cache
-- Execution:                 EXEC [dbo].[GetIdRefLangNames] 'EN',39
-- Modified on:  
-- Modified Desc:  
-- =============================================                        
CREATE PROCEDURE [dbo].[GetIdRefLangNames] 
@langCode NVARCHAR(10),
@lookupId INT
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	IF(@langCode='EN')
		BEGIN
			SELECT CASE  WHEN (refOp.SysOptionName = 'All' AND  refOp.SysLookupCode = 'Status')  Then 0 ELSE refOp.Id END as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,refOp.[SysOptionName] as LangName
				,refOp.[SysDefault] as IsDefault
			FROM [dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.Id = refOp.SysLookupId
			INNER JOIN dbo.fnGetUserStatuses(0) st	ON refOp.StatusId = st.StatusId
			WHERE lkup.Id= @lookupId  
			ORDER BY refOp.SysSortOrder ASC 
		END
	ELSE
		BEGIN
			SELECT refOp.Id as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,lngRef.[SysOptionName] as LangName
				,refOp.[SysDefault] as IsDefault
			FROM [dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [dbo].[SYSTM010Ref_Options] lngRef  (NOLOCK) ON lngRef.SysRefId =refOp.Id 
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.Id = refOp.SysLookupId
			INNER JOIN dbo.fnGetUserStatuses(0) st	ON refOp.StatusId = st.StatusId
			WHERE lkup.Id= @lookupId AND lngRef.[LangCode] = @langCode
			ORDER BY refOp.SysSortOrder ASC 
		END
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
