SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/25/2019
-- Description:	Delete Job Order Item Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[DeleteJobOrderItemMapping] 
(@JobId [bigint]
,@EntityName [nvarchar] (150)
,@LineNumber [int]
)
AS
BEGIN TRY
	SET NOCOUNT ON;
	DELETE FROM dbo.NAV000JobOrderItemMapping
	Where JobId = @JobId AND EntityName = @EntityName AND LineNumber = @LineNumber
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
