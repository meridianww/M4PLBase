SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/9/2021
-- Description:	Update On Job Posted Invoice
-- =============================================
CREATE PROCEDURE [dbo].[UpdateOnJobPostedInvoice] (
	 @JobId BIGINT
	,@CostChargeId BIGINT
	,@PriceChargeId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[NAV000JobSalesOrderMapping_Bak] (
		JobSalesOrderMappingId
		,JobId
		,SONumber
		,IsElectronicInvoiced
		,DateEntered
		,EnteredBy
		,IsParentOrder
		)
	SELECT JobSalesOrderMappingId
		,JobId
		,SONumber
		,IsElectronicInvoiced
		,DateEntered
		,EnteredBy
		,IsParentOrder
	FROM dbo.NAV000JobSalesOrderMapping
	WHERE JobId = @JobId

	INSERT INTO [dbo].[NAV000JobPurchaseOrderMapping_Bak] (
		JobPurchaseOrderMappingId
		,JobId
		,PONumber
		,IsElectronicInvoiced
		,DateEntered
		,EnteredBy
		)
	SELECT JobPurchaseOrderMappingId
		,JobId
		,PONumber
		,IsElectronicInvoiced
		,DateEntered
		,EnteredBy
	FROM dbo.NAV000JobPurchaseOrderMapping
	WHERE JobId = @JobId

	INSERT INTO [dbo].[NAV000JobOrderItemMapping_Bak] (
	    [JobOrderItemMappingId]
		,[JobId]
		,[EntityName]
		,[LineNumber]
		,[DateEntered]
		,[EnteredBy]
		,[M4PLItemId]
		,[Document_Number]
		)
	SELECT JobOrderItemMappingId
	    ,JobId
		,EntityName
		,LineNumber
		,DateEntered
		,EnteredBy
		,M4PLItemId
		,Document_Number
	FROM dbo.NAV000JobOrderItemMapping
	WHERE JobId = @JobId

	DELETE
	FROM dbo.NAV000JobOrderItemMapping
	WHERE JobId = @JobId

	DELETE
	FROM dbo.NAV000JobSalesOrderMapping
	WHERE JobId = @JobId

	DELETE
	FROM dbo.NAV000JobPurchaseOrderMapping
	WHERE JobId = @JobId

	UPDATE dbo.JOBDL062CostSheet
	SET CstInvoiced = 1
	WHERE JobId = @JobId AND ID <> @CostChargeId
		AND StatusId = 1

	UPDATE dbo.JOBDL061BillableSheet
	SET PrcInvoiced = 1
	WHERE JobId = @JobId
		AND ID <> @PriceChargeId
		AND StatusId = 1
END
GO

