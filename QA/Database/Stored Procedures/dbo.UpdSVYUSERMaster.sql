SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 09/11/2019
-- Description:	UPDATE  Survey User Details
-- =============================================
CREATE PROCEDURE [dbo].[UpdSVYUSERMaster] (
	 @Id BIGINT
	,@Feedback [nvarchar](Max)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[SVYUSER000Master] SET [Feedback] = @Feedback Where Id = @Id

	SELECT Id
		,[Name]
		,[Age]
		,[GenderId]
		,[EntityTypeId]
		,[EntityType]
		,[UserId]
		,[Feedback]
	FROM [dbo].[SVYUSER000Master]
	WHERE Id = @Id
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

