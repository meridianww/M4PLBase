SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Sales Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobPurchaseOrderMapping] 
(
	 @PONumber [nvarchar](100)
	,@IsElectronicInvoiced [bit]
	,@JobId BIGINT
	,@EnteredBy [nvarchar](50) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF EXISTS (
			SELECT 1
			FROM dbo.NAV000JobPurchaseOrderMapping
			WHERE JobId = @JobId
				AND IsElectronicInvoiced = @IsElectronicInvoiced
			)
	BEGIN
		UPDATE dbo.NAV000JobPurchaseOrderMapping
		SET PONumber = @PONumber
		WHERE JobId = @JobId
			AND IsElectronicInvoiced = @IsElectronicInvoiced
	END
	ELSE
	BEGIN
		INSERT INTO dbo.NAV000JobPurchaseOrderMapping (
			 JobId
			,PONumber
			,IsElectronicInvoiced
			,EnteredBy
			)
		VALUES (
			 @JobId
			,@PONumber
			,@IsElectronicInvoiced
			,@EnteredBy
			)
	END

	SELECT JobPurchaseOrderMappingId
	FROM dbo.NAV000JobPurchaseOrderMapping
	WHERE PONumber = @PONumber
		AND IsElectronicInvoiced = @IsElectronicInvoiced
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
