SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/12/2019
-- Description:	Get Rolling Job Id List
-- =============================================
CREATE PROCEDURE [dbo].[GetRollingupJobIdListByJobId] (@jobId BIGINT)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @GroupByColumnName VARCHAR(50)
		,@programId BIGINT
		,@RollUpFieldValue VARCHAR(500)
		,@SQLString NVARCHAR(500)
		,@ParmDefinition NVARCHAR(500);

	SELECT @programId = ProgramId
	FROM JOBDL000Master
	WHERE Id = @jobId

	SELECT @GroupByColumnName = ColColumnName
	FROM dbo.SYSTM000ColumnsAlias Alias
	INNER JOIN dbo.PRGRM000Master Program ON Program.PrgRollupBillingJobFieldId = Alias.Id
	WHERE Program.Id = '' + @programId + ''

	SET @SQLString = N'SELECT @RollUpFieldValue = ' + @GroupByColumnName + '   
   FROM JOBDL000Master  
   WHERE Id = @JobId';
	SET @ParmDefinition = N'@GroupByColumnName VARCHAR(50),@jobId BIGINT, @RollUpFieldValue varchar(500) OUTPUT';

	EXECUTE sp_executesql @SQLString
		,@ParmDefinition
		,@GroupByColumnName = @GroupByColumnName
		,@jobId = @jobId
		,@RollUpFieldValue = @RollUpFieldValue OUTPUT;

	EXEC (
			'Select Id JobId, ' + @GroupByColumnName + ' ColumnValue, ISNULL(JobCompleted,0) IsCompleted
From JOBDL000Master
Where ISNULL(' + @GroupByColumnName + ','''') = ''' + @RollUpFieldValue + ''' AND ProgramId = ' + @programId + '
Group By Id, ' + @GroupByColumnName + ',JobCompleted
Order By ' + @GroupByColumnName + ''
			)
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

