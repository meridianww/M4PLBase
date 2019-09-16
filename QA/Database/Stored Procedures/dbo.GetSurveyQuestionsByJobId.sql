SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 9/11/2019
-- Description:	Get Survey Questions By JobId
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyQuestionsByJobId] 
(@JobId BIGINT)
AS
BEGIN TRY 
	SET NOCOUNT ON;

	DECLARE @ActiveVOCId BIGINT
		,@ProgramId BIGINT
		,@AgreeText Varchar(100)
		,@DisAgreeText Varchar(100)
		,@AgreeTextId INT
		,@DisAgreeTextId INT

	SELECT @ProgramId = ProgramId
	FROM JOBDL000Master WITH (NOLOCK)
	WHERE Id = @JobId

	Select @AgreeTextId = Id, @AgreeText = SysOptionName From SYSTM000Ref_Options WITH (NOLOCK) Where SysLookupCode = 'AgreementType' AND SysOptionName = 'Yes'
	Select @DisAgreeTextId = Id, @DisAgreeText = SysOptionName From SYSTM000Ref_Options WITH (NOLOCK) Where SysLookupCode = 'AgreementType' AND SysOptionName = 'No'

	SELECT TOP 1 @ActiveVOCId = Id
	FROM [dbo].[MVOC000Program] WITH (NOLOCK)
	WHERE VocProgramID = @ProgramId
		AND StatusId = 1
		AND (
			(
				VocDateClose IS NOT NULL
				AND VocDateClose >= GETUTCDATE()
				AND VocDateOpen <= GETUTCDATE() 
				)
			OR (VocDateClose IS NULL)
			)
	ORDER BY DateEntered DESC

	SELECT DISTINCT QUE.MVOCId SurveyId
	    ,MP.VocSurveyTitle SurveyTitle
		,@JobId JobId
		,MP.VocAllStar
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
				THEN 5
			ELSE QUE.QueType_RangeHi
			END EndRange
		,@AgreeText AgreeText
		,@AgreeTextId AgreeTextId
		,@DisAgreeText DisAgreeText
		,@DisAgreeTextId DisAgreeTextId
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



