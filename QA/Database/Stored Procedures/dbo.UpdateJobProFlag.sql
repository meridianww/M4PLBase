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
	,@JobId BIGINT
	,@changedBy NVARCHAR(150)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (@EntityName = 'SalesOrder')
	BEGIN
		UPDATE dbo.JOBDL000Master
		SET ProFlags19 = CASE 
				WHEN ISNULL(ProFlags19, '') = 'H'
					AND @Proflag = 'I'
					THEN 'O'
				WHEN ISNULL(ProFlags19, '') = 'I'
					AND @Proflag = 'H'
					THEN 'O'
				ELSE @Proflag
				END
			,ChangedBy = @changedBy
			,DateChanged = GETUTCDATE()
		WHERE Id = @JobId
	END
	ELSE IF (@EntityName = 'PurchaseOrder')
	BEGIN
		UPDATE dbo.JOBDL000Master
		SET ProFlags20 = CASE 
				WHEN ISNULL(ProFlags19, '') = 'H'
					AND @Proflag = 'I'
					THEN 'O'
				WHEN ISNULL(ProFlags19, '') = 'I'
					AND @Proflag = 'H'
					THEN 'O'
				ELSE @Proflag
				END
			,ChangedBy = @changedBy
			,DateChanged = GETUTCDATE()
		WHERE Id = @JobId
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

