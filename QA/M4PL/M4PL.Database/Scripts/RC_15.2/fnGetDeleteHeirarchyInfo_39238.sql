USE [M4PL_Dev]
GO

/****** Object:  UserDefinedFunction [dbo].[fnGetDeleteHeirarchyInfo]    Script Date: 12/4/2018 7:58:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================      
-- Author       : Nikhil       
-- Create date  : 12/3/2018    
-- Description  : To get depended child table name with FK ColumnName
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetDeleteHeirarchyInfo]
(
	@entity NVARCHAR(100),
	@joins  NVARCHAR(MAX),
	@where NVARCHAR(MAX)

)
RETURNS @relationshipOrder TABLE (
   Id INT NOT NULL identity(1,1),
   ParentTableName NVARCHAR(100),
   ParentKeyName NVARCHAR(100),
   ChildTableName NVARCHAR(100),
   ColumnName NVARCHAR(100),
   ChildLevel INT,
   Command NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @tableName NVARCHAR(100), @primaryKeyName NVARCHAR(100);
	SELECT @tableName = TblTableName, @primaryKeyName = TblPrimaryKeyName FROM  SYSTM000Ref_Table WHERE SysRefName = @entity;

	;WITH Heirarchy AS
	(
		SELECT 	
			OBJECT_NAME (f.referenced_object_id) as ParentTableName,
			COL_NAME(fc.referenced_object_id, fc.referenced_column_id) ParentKeyName,
			OBJECT_NAME(f.parent_object_id) as ChildTableName,
			COL_NAME(fc.parent_object_id, fc.parent_column_id) ColumnName,
			1 AS ChildLevel
		FROM sys.foreign_keys AS f
		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
		INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.TblTableName = OBJECT_NAME(f.parent_object_id)

		WHERE OBJECT_NAME (f.referenced_object_id) = @tableName-- Pointer table
		UNION ALL
		SELECT  
			OBJECT_NAME (f.referenced_object_id) as ParentTableName,
			COL_NAME(fc.referenced_object_id, fc.referenced_column_id) ParentKeyName,
			OBJECT_NAME(f.parent_object_id) as ChildTableName,
			COL_NAME(fc.parent_object_id, fc.parent_column_id) ColumnName,
			ChildLevel + 1
			FROM sys.foreign_keys AS f
		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
		INNER JOIN Heirarchy TH ON TH.ChildTableName = OBJECT_NAME (f.referenced_object_id)
	)

	INSERT INTO @relationshipOrder
	SELECT ParentTableName, ParentKeyName, ChildTableName, ColumnName, ChildLevel, '' FROM Heirarchy 

	;WITH CTE AS (
		select Id,  ParentTableName, ParentKeyName, ChildTableName, ColumnName, ChildLevel, 
		cast(concat(' INNER JOIN ', @tableName , ' ', @entity,' ON ', @entity, '.' , @primaryKeyName, ' = ', ChildTableName, '.', ColumnName , ' ',  @joins, ' WHERE 1=1 ' , @where) AS NVARCHAR(MAX)) AS Command
		FROM @relationshipOrder
		WHERE ChildLevel  =1
		UNION all
		SELECT child.Id, child.ParentTableName, child.ParentKeyName, child.ChildTableName, child.ColumnName, child.ChildLevel, 
		CAST(CONCAT(' INNER JOIN ', parent.ChildTableName, ' ON ', child.ChildTableName, '.', child.ColumnName, ' = ', parent.ChildTableName, '.', parent.ParentKeyName,  parent.Command ) as NVARCHAR(MAX)) as Command
		from @relationshipOrder AS child
		JOIN CTE AS parent ON child.ParentTableName = parent.ChildTableName
	)

	UPDATE rltn  
	SET rltn.Command = ('DELETE child FROM ' + rltn.ChildTableName + ' child ' + REPLACE(cte.Command, rltn.ChildTableName, 'child')) 
	FROM @relationshipOrder as rltn
	JOIN CTE on rltn.Id = cte.Id;
RETURN 
END

GO

