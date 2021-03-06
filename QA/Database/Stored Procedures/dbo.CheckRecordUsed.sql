SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckRecordUsed] (
	@Id NVARCHAR(500)
	,@TableName NVARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @noOfRecordsFound INT
	DECLARE @UsedCheckTable AS TABLE (
		TableName VARCHAR(100)
		,ColumnName VARCHAR(100)
		,RowNumber INT
		,IsStatusColumnExists BIT
		,Query VARCHAR(MAX)
		)

	INSERT INTO @UsedCheckTable (
		TableName
		,ColumnName
		,IsStatusColumnExists
		,RowNumber
		)
	SELECT sys.sysobjects.name AS TableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = sys.foreign_keys.name
			) AS ColumnName
		,(
			SELECT CAST(CASE 
						WHEN COUNT(Column_Name) > 0
							THEN 1
						ELSE 0
						END AS BIT)
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = sys.sysobjects.name
				AND COLUMN_NAME = 'StatusId'
			) AS IsStatusColumnExists
		,ROW_NUMBER() OVER (
			ORDER BY sys.sysobjects.name
			) row_num
	FROM sys.foreign_keys
	INNER JOIN sys.sysobjects ON sys.foreign_keys.parent_object_id = sys.sysobjects.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	WHERE refTable.SysRefName = @TableName

	UPDATE uct
	SET uct.query = 'SELECT @noOfRecordsFound = COUNT(*) FROM  ' + uct.TableName + ' table1 JOIN [dbo].[fnSplitString](''' + @Id + ''', '','') allIds ON table1.' + uct.ColumnName + ' = allIds.Item ' + CASE 
			WHEN uct.TableName = 'JOBDL020Gateways'
				THEN ' WHERE ISNULL(table1.StatusId, 1) < 196 '
			ELSE CASE 
					WHEN uct.IsStatusColumnExists = 1
						THEN ' WHERE ISNULL(table1.StatusId, 1) < 3 '
					ELSE ''
					END
			END
	FROM @usedCheckTable uct

	DECLARE @Counter INT
		,@RowCount INT

	SET @Counter = 1;
	SET @RowCount = (
			SELECT COUNT(1)
			FROM @usedCheckTable
			)

	DECLARE @Query NVARCHAR(MAX)

	WHILE (
			@Counter IS NOT NULL
			AND @Counter <= @RowCount
			)
	BEGIN
		SET @Query = (
				SELECT Query
				FROM @UsedCheckTable
				WHERE RowNumber = @Counter
				)

		EXEC sp_executesql @query
			,N' @noOfRecordsFound int output'
			,@noOfRecordsFound OUTPUT

		IF (@noOfRecordsFound > 0)
		BEGIN
			BREAK
		END

		SET @Counter = @Counter + 1

		PRINT @Counter
	END

	DECLARE  @exist BIT 
	IF (@noOfRecordsFound > 0)
	BEGIN
	SET @exist = 1
		SELECT @exist
	END
	ELSE
	BEGIN
	SET @exist = 0
		SELECT @exist
	END
END
GO
