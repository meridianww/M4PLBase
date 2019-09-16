SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 9/11/2019
-- Description:	Insert Data For Survey Master
-- =============================================
CREATE PROCEDURE [dbo].[InsSVYANS000Master] @SurveyUserId BIGINT
    ,@SurveyId BIGINT
	,@uttSVYANS000Master dbo.uttSVYANS000Master READONLY
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE dbo.SVYUSER000Master SET SurveyId = @SurveyId Where Id =  @SurveyUserId

	INSERT INTO [dbo].[SVYANS000Master] (
		[SurveyUserId]
		,[QuestionId]
		,[SelectedAnswer]
		)
	SELECT @SurveyUserId
		,[QuestionId]
		,[SelectedAnswer]
	FROM @uttSVYANS000Master
	Where ISNULL(SelectedAnswer,'')<>''

	Select CAST(1 AS Bit)
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

