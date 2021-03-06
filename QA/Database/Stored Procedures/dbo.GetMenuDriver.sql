SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all menu driver  
-- Execution:                 EXEC [dbo].[GetMenuDriver]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetMenuDriver]
	@userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT mnu.[Id]
		,mnu.[LangCode] 
		,mnu.[MnuModuleId]
		,mnu.[MnuTableName]
		,mnu.[MnuBreakDownStructure]
		,mnu.[MnuTitle]
		,mnu.[MnuTabOver]
		,mnu.[MnuMenuItem]
		,mnu.[MnuRibbon]
		,mnu.[MnuRibbonTabName]
		,mnu.[MnuIconVerySmall]
		,mnu.[MnuIconSmall]
		,mnu.[MnuIconMedium]
		,mnu.[MnuIconLarge]
		,mnu.[MnuExecuteProgram]
		,mnu.[MnuClassificationId]
		,mnu.[MnuProgramTypeId]
		,mnu.[MnuOptionLevelId]
		,mnu.[MnuAccessLevelId]
		,mnu.[MnuHelpFile]
		,mnu.[MnuHelpBookMark]
		,mnu.[MnuHelpPageNumber]
		,mnu.[StatusId]
		,mnu.[DateEntered]
		,mnu.[DateChanged]
		,mnu.[EnteredBy]
		,mnu.[ChangedBy]
	FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu
	WHERE mnu.[LangCode] = @langCode 
	AND mnu.Id=@id
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
