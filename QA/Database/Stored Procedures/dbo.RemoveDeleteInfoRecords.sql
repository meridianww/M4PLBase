SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               07/04/2018          
-- Description:               update records to archieve on delete info
-- Execution:                 EXEC [dbo].[RemoveDeleteInfoRecords]    
-- Modified on:      
-- Modified Desc:      
-- =============================================     
CREATE PROCEDURE [dbo].[RemoveDeleteInfoRecords] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@parentEntity NVARCHAR(100)
	,@contains NVARCHAR(MAX)
	,@parentFieldName NVARCHAR(100) = NULL
	,@itemNumberField NVARCHAR(100) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (ISNULL(@parentEntity, '') = 'Contact')
	BEGIN
		EXEC [RemoveDeleteInfoRecordsContact] @userId
			,@roleId
			,@orgId
			,@entity
			,@parentEntity
			,@contains
			,@parentFieldName
			,@itemNumberField
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
		DECLARE @whereQuery NVARCHAR(MAX)

		SELECT @query = COALESCE(@query + ' OR ', '') + ReferenceColumnName + ' in (' + CAST(@contains AS NVARCHAR(max)) + ')'
		FROM @ReferenceTable
		ORDER BY ReferenceEntity

		SET @whereQuery = @query;
		SET @query = 'UPDATE  ' + @tableName + '  Set StatusId = (CASE WHEN '+''''+
		 @entity + ''''+ ' = ''JobGateway'' THEN  196 ELSE 3 END)  WHERE ' + @query

		EXEC sp_executesql @query;

		IF (ISNULL(@entity, '') = 'Account' AND ISNULL(@parentEntity, '') = 'OrgRefRole')
		BEGIN
		    Select CAST(Item AS BIGINT) SysOrgRefRoleId INTO #SysOrgRefRoleId  From [dbo].[fnSplitString](@contains, ',')		    

			UPDATE dbo.CONTC010Bridge SET StatusId = 3, ContactMSTRID= NULL WHERE [ConTableName] = 'SystemAccount' 
			AND ContactMSTRID IN (Select SysUserContactID From [dbo].[SYSTM000OpnSezMe] 
			WHERE SysOrgRefRoleId IN (Select SysOrgRefRoleId From #SysOrgRefRoleId) )

			UPDATE [dbo].[SYSTM000OpnSezMe]
			SET SysUserContactID = NULL
			WHERE SysOrgRefRoleId IN (Select SysOrgRefRoleId From #SysOrgRefRoleId)
		END
			IF (ISNULL(@entity, '') = 'SecurityByRole' AND ISNULL(@parentEntity, '') = 'OrgRefRole')
			BEGIN
				SELECT CAST(Item AS BIGINT) SysOrgRefRoleId INTO #SysOrgRefRoleIds  From [dbo].[fnSplitString](@contains, ',')		    
				UPDATE CON SET StatusId = 3, ConCodeId = NULL FROM dbo.CONTC010Bridge CON 
				INNER JOIN #SysOrgRefRoleIds temp ON temp.SysOrgRefRoleId = CON.ConCodeId
			END

		IF LEN(ISNULL(@itemNumberField, '')) > 0
		BEGIN
			CREATE TABLE #T1 (
				PrimaryId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED
				,ParentId BIGINT
				);

			SET @whereQuery = ' INSERT INTO  #T1 (ParentId) select DISTINCT ' + @parentFieldName + ' from  ' + @tableName + ' WHERE ' + @whereQuery

			SELECT @whereQuery

			EXEC sp_executesql @whereQuery

			DECLARE @leastIdRowNo INT = 1
			DECLARE @InsideWhere NVARCHAR(MAX)

			WHILE EXISTS (
					SELECT *
					FROM #T1
					WHERE PrimaryId = @leastIdRowNo
					)
			BEGIN
				DECLARE @parId BIGINT;

				SELECT @parId = ParentId
				FROM #T1
				WHERE PrimaryId = @leastIdRowNo

				SET @InsideWhere = ' AND ' + @parentFieldName + ' = ' + CAST(@parId AS VARCHAR);

				EXEC UpdateItemNumberAfterDelete @entity
					,@contains
					,@itemNumberField
					,@InsideWhere

				SET @leastIdRowNo = @leastIdRowNo + 1;
			END

			DROP TABLE #T1
		END
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
