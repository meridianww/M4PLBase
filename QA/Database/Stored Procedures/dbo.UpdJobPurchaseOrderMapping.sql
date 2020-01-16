SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Sales Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobPurchaseOrderMapping] (
	 @SONumber [nvarchar](100)
	,@PONumber [nvarchar](100)
	,@IsElectronicInvoiced [bit]
	,@EnteredBy [nvarchar](50) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @JobSalesOrderMappingId BIGINT

	SELECT @JobSalesOrderMappingId = JobSalesOrderMappingId
	FROM dbo.NAV000JobSalesOrderMapping
	WHERE SONumber = @SONumber

	IF EXISTS (
			SELECT 1
			FROM dbo.NAV000JobPurchaseOrderMapping
			WHERE JobSalesOrderMappingId = @JobSalesOrderMappingId
				AND IsElectronicInvoiced = @IsElectronicInvoiced
			)
	BEGIN
		UPDATE dbo.NAV000JobPurchaseOrderMapping
		SET PONumber = @PONumber
		WHERE JobSalesOrderMappingId = @JobSalesOrderMappingId
			AND IsElectronicInvoiced = @IsElectronicInvoiced
	END
	ELSE
	BEGIN
		INSERT INTO dbo.NAV000JobPurchaseOrderMapping (
			JobSalesOrderMappingId
			,PONumber
			,IsElectronicInvoiced
			,EnteredBy
			)
		VALUES (
			@JobSalesOrderMappingId
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

