SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Janardana Behara           
-- Create date:               01/02/2018        
-- Description:               Get Last Item Number   
-- Execution:                 EXEC [dbo].[GetLastItemNumber]  
-- Modified on:    
-- Modified Desc:    
-- =============================================         
CREATE PROCEDURE [dbo].[GetLastItemNumber]        
 @entity NVARCHAR(100),      
 @fieldName NVARCHAR(100),      
 @where NVARCHAR(500)=''    
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @tableName NVARCHAR(MAX);

	SELECT @tableName = TblTableName
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	DECLARE @sqlCommand NVARCHAR(MAX);

	SET @sqlCommand = 'SELECT ISNULL(Max(' + @entity + '.' + @fieldName + '),0) FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' WHERE 1=1';

	IF @entity <> 'JobGateway'
	BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ISNULL(StatusId,1) In(1,2) ' + ISNULL(@where, '');

		IF @tableName = 'CONTC010Bridge'
		BEGIN
			SET @sqlCommand = @sqlCommand + ' AND  ' + @entity + '.ConTableName = ''' + @entity + ''' ';
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = @sqlCommand + ISNULL(@where, '');
	END
	PRINT(@sqlCommand)
	EXEC (@sqlCommand)
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
