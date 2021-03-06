SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get Table Name bu Lkup Id
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================   

CREATE FUNCTION [dbo].[fnGetTblNameByLkupId]
(
	@lookupId INT
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @tableName NVARCHAR(100)
	SELECT @tableName = tbl.[TblTableName] FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl
	INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON tbl.[SysRefName] =lkup.LkupTableName
	WHERE lkup.[Id] = @lookupId
	RETURN @tableName
END
GO
