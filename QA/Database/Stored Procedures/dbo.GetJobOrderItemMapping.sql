SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Get Job Order Item Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[GetJobOrderItemMapping] (@JobId [bigint])
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT JobId
		,EntityName
		,LineNumber
	FROM dbo.NAV000JobOrderItemMapping
	WHERE JobId = @JobId
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

