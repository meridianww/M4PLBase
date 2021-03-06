SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Get Job Order Item Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[GetJobOrderItemMapping] 
(
 @JobIdList uttIDList READONLY
,@EntityName Varchar(100)
,@isElectronicInvoice BIT
)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF(@EntityName = 'SalesOrder')
	BEGIN
	SELECT NAV.JobOrderItemMappingId,NAV.JobId
		,NAV.EntityName
		,NAV.LineNumber
		,NAV.M4PLItemId
		,Document_Number
		,SO.IsElectronicInvoiced
	FROM dbo.NAV000JobOrderItemMapping NAV
	INNER JOIN NAV000JobSalesOrderMapping SO ON SO.SONumber = NAV.Document_Number AND SO.IsElectronicInvoiced = @isElectronicInvoice
	INNER JOIN @JobIdList uttList ON uttList.Id = NAV.JobId
	END
	IF(@EntityName = 'PurchaseOrder')
	BEGIN
	SELECT NAV.JobOrderItemMappingId,NAV.JobId
		,NAV.EntityName
		,NAV.LineNumber
		,NAV.M4PLItemId
		,Document_Number
		,PO.IsElectronicInvoiced
	FROM dbo.NAV000JobOrderItemMapping NAV
	INNER JOIN NAV000JobPurchaseOrderMapping PO ON PO.PONumber = NAV.Document_Number AND PO.IsElectronicInvoiced = @isElectronicInvoice
	INNER JOIN @JobIdList uttList ON uttList.Id = NAV.JobId
	END
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
