SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get Table Name by Lkup Name    
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetTblNameByLkupName]
(
	@lookupName NVARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @tableName NVARCHAR(100)
	SELECT @tableName = tbl.[TblTableName] FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl
	INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON tbl.[SysRefName] =lkup.LkupTableName
	WHERE lkup.[LkupCode] = @lookupName
	RETURN @tableName
END
GO
