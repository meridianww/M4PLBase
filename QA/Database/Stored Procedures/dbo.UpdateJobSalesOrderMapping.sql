SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobSalesOrderMapping] (
	@jobId BIGINT
	,@manualSalesOrderId VARCHAR(50)
	,@electronicSalesOrderId VARCHAR(50)
	,@isManualUpdate BIT
	,@isElectronicUpdate BIT
	,@EnteredBy VARCHAR(50)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @oldManualSalesOrderId VARCHAR(50)
		,@oldElectronicSalesOrderId VARCHAR(50)
		,@oldManualPurchaseOrderId VARCHAR(50)
		,@oldElectronicPurchaseOrderId VARCHAR(50)

	SELECT @oldManualSalesOrderId = SONumber
	FROM dbo.NAV000JobSalesOrderMapping
	WHERE JobId = @jobId
		AND ISNULL(IsElectronicInvoiced, 0) = 0

	SELECT @oldElectronicSalesOrderId = SONumber
	FROM dbo.NAV000JobSalesOrderMapping
	WHERE JobId = @jobId
		AND ISNULL(IsElectronicInvoiced, 0) = 1

	SELECT @oldManualPurchaseOrderId = PONumber
	FROM dbo.NAV000JobPurchaseOrderMapping PO
	INNER JOIN dbo.NAV000JobSalesOrderMapping SO ON SO.JobSalesOrderMappingId = PO.JobSalesOrderMappingId
	WHERE JobId = @jobId
		AND ISNULL(PO.IsElectronicInvoiced, 0) = 0

	SELECT @oldElectronicPurchaseOrderId = PONumber
	FROM dbo.NAV000JobPurchaseOrderMapping PO
	INNER JOIN dbo.NAV000JobSalesOrderMapping SO ON SO.JobSalesOrderMappingId = PO.JobSalesOrderMappingId
	WHERE SO.JobId = @jobId
		AND ISNULL(PO.IsElectronicInvoiced, 0) = 1

	IF (@isManualUpdate = 0)
	BEGIN
		DELETE
		FROM dbo.NAV000JobOrderItemMapping
		WHERE Document_Number IN (
				@oldManualSalesOrderId
				,@oldManualPurchaseOrderId
				)

		DELETE PO
		FROM dbo.NAV000JobPurchaseOrderMapping PO
		INNER JOIN dbo.NAV000JobSalesOrderMapping SO ON SO.JobSalesOrderMappingId = PO.JobSalesOrderMappingId
		WHERE SO.SONumber = @oldManualSalesOrderId

		DELETE
		FROM dbo.NAV000JobSalesOrderMapping
		WHERE SONumber = @oldManualSalesOrderId
	END
	ELSE IF (
			@isManualUpdate = 1
			AND ISNULL(@oldManualSalesOrderId, '') <> ''
			)
	BEGIN
		UPDATE dbo.NAV000JobOrderItemMapping
		SET Document_Number = @manualSalesOrderId
		WHERE Document_Number = @oldManualSalesOrderId

		UPDATE dbo.NAV000JobSalesOrderMapping
		SET SONumber = @manualSalesOrderId
		WHERE SONumber = @oldManualSalesOrderId
	END
	ELSE IF (
			@isManualUpdate = 1
			AND ISNULL(@oldManualSalesOrderId, '') = ''
			AND ISNULL(@manualSalesOrderId, '') <> ''
			)
	BEGIN
		INSERT INTO dbo.NAV000JobSalesOrderMapping (
			JobId
			,SONumber
			,IsElectronicInvoiced
			,EnteredBy
			)
		VALUES (
			@jobId
			,@manualSalesOrderId
			,0
			,@EnteredBy
			);
	END

	IF (@isElectronicUpdate = 0)
	BEGIN
		DELETE
		FROM dbo.NAV000JobOrderItemMapping
		WHERE Document_Number IN (
				@oldElectronicSalesOrderId
				,@oldElectronicPurchaseOrderId
				)

		DELETE PO
		FROM dbo.NAV000JobPurchaseOrderMapping PO
		INNER JOIN dbo.NAV000JobSalesOrderMapping SO ON SO.JobSalesOrderMappingId = PO.JobSalesOrderMappingId
		WHERE SO.SONumber = @oldElectronicSalesOrderId

		DELETE
		FROM dbo.NAV000JobSalesOrderMapping
		WHERE SONumber = @oldElectronicSalesOrderId
	END
	ELSE IF (
			@isElectronicUpdate = 1
			AND ISNULL(@oldElectronicSalesOrderId, '') <> ''
			)
	BEGIN
		UPDATE dbo.NAV000JobOrderItemMapping
		SET Document_Number = @electronicSalesOrderId
		WHERE Document_Number = @oldElectronicSalesOrderId

		UPDATE dbo.NAV000JobSalesOrderMapping
		SET SONumber = @electronicSalesOrderId
		WHERE SONumber = @oldElectronicSalesOrderId
	END
	ELSE IF (
			@isElectronicUpdate = 1
			AND ISNULL(@oldElectronicSalesOrderId, '') = ''
			AND ISNULL(@electronicSalesOrderId, '') <> ''
			)
	BEGIN
		INSERT INTO dbo.NAV000JobSalesOrderMapping (
			JobId
			,SONumber
			,IsElectronicInvoiced
			,EnteredBy
			)
		VALUES (
			@jobId
			,@electronicSalesOrderId
			,1
			,@EnteredBy
			);
	END
END
GO