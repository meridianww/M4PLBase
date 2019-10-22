SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobOrderItemMapping] 
(@JobId [bigint]
,@EntityName [nvarchar] (150)
,@LineNumber [int]
,@EnteredBy [nvarchar] (50) = NULL
)
AS
BEGIN TRY
	SET NOCOUNT ON;
		INSERT INTO dbo.NAV000JobOrderItemMapping (
			JobId
			,EntityName
			,LineNumber
			,EnteredBy
			)
		VALUES (
			@JobId
			,@EntityName
			,@LineNumber
			,@EnteredBy
			)
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
