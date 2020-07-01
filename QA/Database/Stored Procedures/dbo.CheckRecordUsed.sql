SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CheckRecordUsed] (
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
		,Query VARCHAR(MAX)
		)

	INSERT INTO @UsedCheckTable (
		TableName
		,ColumnName
		,RowNumber
		)
	SELECT sys.sysobjects.name AS TableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = sys.foreign_keys.name
			) AS ColumnName
		,ROW_NUMBER() OVER (
			ORDER BY sys.sysobjects.name
			) row_num
	FROM sys.foreign_keys
	INNER JOIN sys.sysobjects ON sys.foreign_keys.parent_object_id = sys.sysobjects.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	WHERE refTable.SysRefName = @TableName

	UPDATE uct
	SET uct.query = 'SELECT @noOfRecordsFound = COUNT(*) FROM  ' + uct.TableName + ' table1 JOIN [dbo].[fnSplitString](''' + @Id + ''', '','') allIds ON table1.' + uct.ColumnName + ' = allIds.Item '
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
	END

	IF (@noOfRecordsFound > 0)
	BEGIN
		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 0
	END
END
