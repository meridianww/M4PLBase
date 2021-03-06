SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobOrderMapping] (
	 @JobIdList uttIDList READONLY
	,@SONumber [nvarchar](100)
	,@PONumber [nvarchar](100)
	,@EnteredBy [nvarchar](50) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	MERGE dbo.NAV000JobOrderMapping AS TARGET
	USING @JobIdList AS SOURCE
		ON (TARGET.JobId = SOURCE.Id)
	WHEN MATCHED
		THEN
			UPDATE
			SET TARGET.SONumber = @SONumber
				,TARGET.PONumber = @PONumber
				,TARGET.EnteredBy = @EnteredBy
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				JobId
				,SONumber
				,PONumber
				,EnteredBy
				)
			VALUES (
				SOURCE.Id
				,@SONumber
				,@PONumber
				,@EnteredBy
				);

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
