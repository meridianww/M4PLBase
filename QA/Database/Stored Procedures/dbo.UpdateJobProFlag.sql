SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/23/2019
-- Description:	Update Job PRO Flag Information
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobProFlag] (
	@Proflag NVARCHAR(1)
	,@EntityName NVARCHAR(150)
	,@JobIdList uttIDList READONLY
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (@EntityName = 'SalesOrder')
	BEGIN
		UPDATE Job
		SET Job.ProFlags19 = CASE 
				WHEN ISNULL(Job.ProFlags19, '') = 'H'
					AND @Proflag = 'I'
					THEN 'O'
				WHEN ISNULL(Job.ProFlags19, '') = 'I'
					AND @Proflag = 'H'
					THEN 'O'
				ELSE @Proflag
				END
			,Job.ChangedBy = @changedBy
			,Job.DateChanged = @dateChanged
			From dbo.JOBDL000Master Job
			INNER JOIN @JobIdList uttTemp on uttTemp.Id = Job.Id
	END
	ELSE IF (@EntityName = 'PurchaseOrder')
	BEGIN
		UPDATE Job
		SET Job.ProFlags20 = CASE 
				WHEN ISNULL(Job.ProFlags20, '') = 'H'
					AND @Proflag = 'I'
					THEN 'O'
				WHEN ISNULL(Job.ProFlags20, '') = 'I'
					AND @Proflag = 'H'
					THEN 'O'
				ELSE @Proflag
				END
			,Job.ChangedBy = @changedBy
			,Job.DateChanged = @dateChanged
		From dbo.JOBDL000Master Job
		INNER JOIN @JobIdList uttTemp on uttTemp.Id = Job.Id
	END
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
