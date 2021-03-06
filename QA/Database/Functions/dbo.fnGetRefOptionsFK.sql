SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author       : Akhil   
-- Create date  : 28 August 2017
-- Description  : To get Ref FK column list
-- Modified Date:  
-- Modified By  :  
-- Modified Desc:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetRefOptionsFK]
(    
      @tableName NVARCHAR(100)
)
RETURNS @Output TABLE (
      ColumnName NVARCHAR(100)
)
AS
BEGIN
    INSERT INTO @Output
    SELECT   
		COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName
	FROM 
		sys.foreign_keys AS f
	INNER JOIN 
		sys.foreign_key_columns AS fc 
			ON f.OBJECT_ID = fc.constraint_object_id
	INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.TblTableName = OBJECT_NAME(f.parent_object_id)
	WHERE 
		OBJECT_NAME (f.referenced_object_id) = 'SYSTM000Ref_Options'-- Pointer table
		AND tbl.SysRefName = @tableName
RETURN

 END
GO
