SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               04/14/2018      
-- Description:               Insert ColumnAliases By Table Name  
-- Execution:                 EXEC [dbo].[InsColumnAliasesByTableName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[InsColumnAliasesByTableName]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
   IF NOT EXISTS(SELECT TOP 1 1 FROM SYSTM000ColumnsAlias WHERE [ColTableName]= @tableName AND [LangCode] =@langCode)
   BEGIN
	 DECLARE @currentId BIGINT;
	 INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColColumnName]
           ,[ColAliasName]
           ,[ColCaption]
           ,[ColDescription]
           ,[ColSortOrder]
		   ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault])
	  SELECT @langCode as LangCode
		  , tbl.SysRefName as ColTableName
		  ,c.name as ColColumnName
		  ,[dbo].[fnGetPascalName](c.name) as ColAliasName
		  ,[dbo].[fnGetPascalName](c.name+'Caption') as ColCaption
		  ,[dbo].[fnGetPascalName](c.name+'Desc') as ColDescription
		  ,CAST( ROW_NUMBER() OVER (ORDER BY c.object_id) AS int) as ColSortOrder
		  ,(CASE  WHEN ( c.name = 'Id' OR c.name = 'DateEntered' OR  c.name = 'EnteredBy' OR   c.name = 'DateChanged' OR  c.name = 'ChangedBy' OR c.name = 'SysRefId' OR c.name = 'SysRefName') THEN 1 ELSE 0 END ) as ColIsReadOnly
		  ,(CASE  WHEN (c.name = 'DateEntered' OR  c.name = 'EnteredBy' OR   c.name = 'DateChanged' OR  c.name = 'ChangedBy' OR t.name ='varbinary' OR t.name='image' OR t.name='LookupName') THEN 0 ELSE 1 END ) as ColIsVisible
		  ,1 as ColIsDefault
	 FROM sys.columns c
	INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = @tableName
	 INNER JOIN  sys.types t ON c.user_type_id = t.user_type_id
	 WHERE  c.object_id = OBJECT_ID(tbl.TblTableName)

	 SET @currentId = SCOPE_IDENTITY();
	 EXEC GetColumnAliasesByTableName @langCode, @tableName;
	END
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
