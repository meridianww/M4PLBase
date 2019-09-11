SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 9/11/2019
-- Description:	Get Survey Questions By JobId
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyQuestionsByJobId] (@JobId BIGINT)
AS
BEGIN TRY 
	SET NOCOUNT ON;

	DECLARE @ActiveVOCId BIGINT
		,@ProgramId BIGINT

	SELECT @ProgramId = Id
	FROM JOBDL000Master WITH (NOLOCK)
	WHERE Id = @JobId

	SELECT TOP 1 @ActiveVOCId = Id
	FROM [dbo].[MVOC000Program] WITH (NOLOCK)
	WHERE VocProgramID = @ProgramId
		AND StatusId = 1
		AND (
			(
				VocDateClose IS NOT NULL
				AND VocDateClose >= GETUTCDATE()
				)
			OR (VocDateClose IS NULL)
			)
	ORDER BY DateEntered DESC

	SELECT QUE.MVOCId SurveyId
	    ,MP.VocSurveyTitle SurveyTitle
		,@JobId JobId
	FROM [dbo].[MVOC010Ref_Questions] QUE
	INNER JOIN [dbo].[MVOC000Program] MP ON MP.Id = QUE.MVOCId
	INNER JOIN SYSTM000Ref_Options SO ON SO.Id = QUE.QuesTypeId
		AND SysLookupCode = 'QuestionType'
	WHERE QUE.MVOCID = @ActiveVOCId
		AND QUE.StatusId = 1

	SELECT 
	    QUE.Id QuestionId
		,QUE.QueQuestionNumber QuestionNumber
		,QUE.QueTitle Title
		,QUE.QuesTypeId QuestionTypeId
		,SO.SysOptionName QuestionTypeIdName
		,CASE 
			WHEN ISNULL(QUE.QueType_RangeLo, 0) = 0
				THEN 1
			ELSE QUE.QueType_RangeLo
			END StartRange
		,CASE 
			WHEN ISNULL(QUE.QueType_RangeHi, 0) = 0
				THEN 10
			ELSE QUE.QueType_RangeHi
			END EndRange
		,'Yes' AgreeText
		,1 AgreeTextId
		,'No' DisAgreeText
		,0 DisAgreeTextId
	FROM [dbo].[MVOC010Ref_Questions] QUE
	INNER JOIN [dbo].[MVOC000Program] MP ON MP.Id = QUE.MVOCId
	INNER JOIN SYSTM000Ref_Options SO ON SO.Id = QUE.QuesTypeId
		AND SysLookupCode = 'QuestionType'
	WHERE QUE.MVOCID = @ActiveVOCId
		AND QUE.StatusId = 1
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO



