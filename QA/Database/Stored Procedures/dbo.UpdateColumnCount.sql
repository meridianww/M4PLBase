SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               03/03/2018      
-- Description:               Update Column Count
-- Execution:                 EXEC [dbo].[UpdateColumnCount]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[UpdateColumnCount]
@tableName NVARCHAR(100), 
@columnName NVARCHAR(100), 
@rowId BIGINT,
@countToChange INT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(500);
 SET @sqlCommand = 'Update '+ @tableName + ' SET '+ @columnName + '= CASE WHEN ((ISNULL('+@columnName+', 0)+' + CAST(@countToChange AS NVARCHAR(100)) 
					+ ') > 0) THEN (ISNULL('+@columnName+', 0)+' + CAST(@countToChange AS NVARCHAR(100)) + ') ELSE NULL END WHERE Id='
					+ CAST(@rowId AS NVARCHAR(100))
 EXEC sp_executesql @sqlCommand
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
