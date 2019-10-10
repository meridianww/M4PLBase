SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobOrderMapping] @JobId [bigint]
	,@SONumber [nvarchar] (100)
	,@PONumber [nvarchar] (100)
	,@EnteredBy [nvarchar] (50) NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF EXISTS (
			SELECT 1
			FROM dbo.NAV000JobOrderMapping
			WHERE JobId = @JobId
			)
	BEGIN
		UPDATE dbo.NAV000JobOrderMapping
		SET JobId = @JobId
			,SONumber = @SONumber
			,PONumber = @PONumber
			,EnteredBy = @EnteredBy
		WHERE JobId = @JobId
	END
	ELSE
	BEGIN
		INSERT INTO dbo.NAV000JobOrderMapping (
			JobId
			,SONumber
			,PONumber
			,EnteredBy
			)
		VALUES (
			@JobId
			,@SONumber
			,@PONumber
			,@EnteredBy
			)
	END
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

