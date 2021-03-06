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

	DECLARE @BitTypeQuestionId INT
		,@RangeTypeQuestionId INT

	SELECT @BitTypeQuestionId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'QuestionType'
		AND SysOptionName = 'Yes/No'

	SELECT @RangeTypeQuestionId = ID
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'QuestionType'
		AND SysOptionName = 'Range'

	UPDATE dbo.SVYUSER000Master
	SET SurveyId = @SurveyId
	WHERE Id = @SurveyUserId

	INSERT INTO [dbo].[SVYANS000Master] (
		[SurveyUserId]
		,[QuestionId]
		,[SelectedAnswer]
		)
	SELECT @SurveyUserId
		,[QuestionId]
		,CASE 
			WHEN ISNULL([SelectedAnswer], '') = ''
				AND Q.QuesTypeId = @RangeTypeQuestionId
				THEN CAST(Q.QueType_RangeDefault AS VARCHAR(50))
			WHEN ISNULL([SelectedAnswer], '') = ''
				AND Q.QuesTypeId = @BitTypeQuestionId
				THEN CASE 
						WHEN ISNULL(QueType_YNDefault, 0) = 0
							THEN 'No'
						ELSE 'Yes'
						END
			ELSE [SelectedAnswer]
			END
	FROM @uttSVYANS000Master ANS
	INNER JOIN dbo.MVOC010Ref_Questions Q ON ANS.QuestionId = Q.Id

	SELECT CAST(1 AS BIT)
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
