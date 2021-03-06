SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEntitySettingWhereClause]
@entity NVARCHAR(100),
@id BIGINT,
@joins NVARCHAR(100) ='',
@userId BIGINT,
@entityfield NVARCHAR(100),
@deletedKeys NVARCHAR(250)= NULL,
@where NVARCHAR(MAX) OUTPUT
AS
BEGIN
        IF(ISNULL(@id,0)=0 AND ISNULL(@deletedKeys,'')<>'' )
		BEGIN
		SET @id=LEFT(@deletedKeys, CHARINDEX(',', @deletedKeys+',')-1)
		END
		Declare @sqlCommand  NVARCHAR(MAX), @columnNames NVARCHAR(MAX), @whereClause NVARCHAR(MAX) ,@tableName NVARCHAR(100), @pKFieldName NVARCHAR(100)
		SELECT @tableName = sysRef.TblTableName,
		@pKFieldName = sysRef.TblPrimaryKeyName
		FROM SYSTM000Ref_Table sysRef WHERE SysRefName = @entity
		select @columnNames =  [dbo].[fnGetEntitySettingWhereClause] (@userId,@entity, @entityfield, @joins , @id) 
		IF(ISNULL(@columnNames,'')<>'')
		BEGIN
		SET @sqlCommand = 'SELECT @whereClause = '+  @columnNames +' FROM '+ @tableName + ' ' + @entity
		+ @joins + ' WHERE 1=1 AND ' + @entity + '.' +@pKFieldName  +' = CAST('+ CAST( @id AS  NVARCHAR(MAX) ) +' AS BIGINT)'
		EXEC sp_executesql @sqlCommand, N'@whereClause NVARCHAR(MAX) OUTPUT',@whereClause =  @whereClause OUTPUT
		SET @where =@whereClause;
		END
END
GO
