SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get Master object data from Column Alias
-- Execution:                 EXEC [dbo].[GetMasterTableObject]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetMasterTableObject]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	 SELECT cal.ColColumnName
		  ,cal.ColAliasName
		  ,cal.ColCaption
		  ,cal.ColDescription
	 FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) cal
	 INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = cal.ColTableName
	 WHERE cal.[LangCode]= @langCode AND cal.ColTableName = @tableName 
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
