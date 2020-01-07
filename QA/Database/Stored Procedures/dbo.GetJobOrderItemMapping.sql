SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Get Job Order Item Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[GetJobOrderItemMapping] (@JobIdList uttIDList READONLY)
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT NAV.JobId
		,NAV.EntityName
		,NAV.LineNumber
		,NAV.M4PLItemId
		,Document_Number
	FROM dbo.NAV000JobOrderItemMapping NAV
	INNER JOIN @JobIdList uttList ON uttList.Id = NAV.JobId
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
