SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               05/25/2018          
-- Description:               Get all referenced modules  by id    
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]    
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)        
-- Modified Desc:      
-- =============================================     
CREATE PROCEDURE [dbo].[GetDeleteInfoRecords] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@parentEntity NVARCHAR(100)
	,@contains NVARCHAR(MAX)
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF(ISNULL(@parentEntity,'') = 'Contact')
	BEGIN
	   EXEC [dbo].[GetDeleteInfoRecordsContact] @userId,@roleId,@orgId,@entity,'Contact',@contains   
	END
	ELSE
	BEGIN
   
	DECLARE @tableName NVARCHAR(100)

	SELECT @tableName = TblTableName
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	DECLARE @ReferenceTable TABLE (
		PrimaryId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED
		,ReferenceEntity NVARCHAR(50)
		,ParentEntity NVARCHAR(50)
		,ReferenceTableName NVARCHAR(100)
		,ReferenceColumnName NVARCHAR(100)
		);

	INSERT INTO @ReferenceTable (
		referenceEntity
		,parentEntity
		,referenceTableName
		,ReferenceColumnName
		)
	SELECT (
			SELECT TOP 1 SysRefName
			FROM [dbo].[SYSTM000Ref_Table]
			WHERE TblTableName = sys.sysobjects.name
			) AS [Entity]
		,@tableName
		,sys.sysobjects.name AS TableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = sys.foreign_keys.name
			) AS ColumnName
	FROM sys.foreign_keys
	INNER JOIN sys.sysobjects ON sys.foreign_keys.parent_object_id = sys.sysobjects.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name    
	WHERE refTable.SysRefName = @parentEntity
		AND sys.sysobjects.name = @tableName;

	DECLARE @query NVARCHAR(MAX)

	SELECT @query = COALESCE(@query + ' OR ', '') + ReferenceColumnName + ' in (' + CAST(@contains AS NVARCHAR(max)) + ')'
	FROM @ReferenceTable
	ORDER BY ReferenceEntity

	IF (@entity = 'Program')
	BEGIN
		SET @query = 'SELECT 
			 [Id]      
			,[PrgOrgID]      
			,[PrgCustID]      
			,[PrgItemNumber]      
			,[PrgProgramCode]      
			,[PrgProjectCode]      
			,[PrgPhaseCode]      
			,[PrgProgramTitle]      
			,[PrgAccountCode] 
			,[DelEarliest] 
			,[DelLatest] 
			,CASE WHEN [DelEarliest] IS NULL AND [DelLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [DelDay] END AS DelDay
			,[PckEarliest] 
			,[PckLatest]
			,CASE WHEN [PckEarliest] IS NULL AND [PckLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [PckDay] END AS PckDay
			,[StatusId]      
			,[PrgDateStart]      
			,[PrgDateEnd]      
			,[PrgDeliveryTimeDefault]      
			,[PrgPickUpTimeDefault]      
			,[PrgHierarchyID].ToString() As PrgHierarchyID       
			,[PrgHierarchyLevel]      
			,[DateEntered]      
			,[EnteredBy]      
			,[DateChanged]      
			,[ChangedBy]  FROM  ' + @tableName + '    WHERE StatusId in(1,2) AND (' + @query + ')';
	END
	ELSE
	BEGIN
		SET @query = 'SELECT * FROM  ' + @tableName + '    WHERE StatusId < (CASE WHEN '+''''+
		 @entity + ''''+ ' = ''JobGateway'' THEN  196 ELSE 3 END) AND (' + @query + ')';
	END
	
	EXEC sp_executesql @query
  END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH

GO
