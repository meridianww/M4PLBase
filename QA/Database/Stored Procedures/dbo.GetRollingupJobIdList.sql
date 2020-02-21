SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/12/2019
-- Description:	Get Rolling Job Id List
-- =============================================
CREATE PROCEDURE [dbo].[GetRollingupJobIdList] (@programId BIGINT)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @GroupByColumnName VARCHAR(50)

	SELECT @GroupByColumnName = ColColumnName
	FROM dbo.SYSTM000ColumnsAlias Alias
	INNER JOIN dbo.PRGRM000Master Program ON Program.PrgRollupBillingJobFieldId = Alias.Id
	WHERE Program.Id = '' + @programId + ''
	EXEC (
			'Select Id JobId, ' + @GroupByColumnName + ' ColumnValue, ISNULL(JobCompleted,0) IsCompleted
From JOBDL000Master
Where ISNULL(' + @GroupByColumnName + ','''') <> '''' AND ProgramId = ' + @programId + ' 
Group By Id, ' + @GroupByColumnName + ',JobCompleted
Order By ' + @GroupByColumnName + ''
			)
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity    
 END CATCH 
GO

