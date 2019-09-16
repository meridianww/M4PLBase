SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 09/11/2019
-- Description:	Insert Survey User Details
-- =============================================
CREATE PROCEDURE [dbo].[InsSVYUSERMaster] (
	 @Name [nvarchar](500)
	,@Age [int]
	,@GenderId [int]
	,@EntityTypeId [bigint]
	,@EntityType [nvarchar](50)
	,@UserId [bigint]
	,@Feedback [nvarchar](Max)
	,@SurveyId [bigint]
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @SurveyUserId BIGINT

	CREATE TABLE #GenderTable (
		Id INT IDENTITY(1, 1)
		,OptionId INT
		)

	INSERT INTO #GenderTable (OptionId)
	SELECT Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'Gender'

	SELECT @GenderId = OptionId
	FROM #GenderTable
	WHERE Id = @GenderId

	DROP TABLE #GenderTable

	INSERT INTO [dbo].[SVYUSER000Master] (
		 [Name]
		,[Age]
		,[GenderId]
		,[EntityTypeId]
		,[EntityType]
		,[UserId]
		,[Feedback]
		,[SurveyId]
		)
	VALUES (
		@Name
		,@Age
		,@GenderId
		,@EntityTypeId
		,@EntityType
		,@UserId
		,@Feedback
		,@SurveyId
		)

	SET @SurveyUserId = SCOPE_IDENTITY()

	SELECT Id
		,[Name]
		,[Age]
		,[GenderId]
		,[EntityTypeId]
		,[EntityType]
		,[UserId]
		,[Feedback]
	FROM [dbo].[SVYUSER000Master]
	WHERE Id = @SurveyUserId
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

