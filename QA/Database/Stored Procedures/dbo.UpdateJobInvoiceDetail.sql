SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================        
-- Author:                    Prashant Aggarwal         
-- Create date:               07/02/2020      
-- Description:               Update the Invoice Details For the Job
-- Execution:                 EXEC [dbo].[UpdateJobInvoiceDetail]  
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobInvoiceDetail] (
	 @JobId BIGINT
	,@JobPurchaseInvoiceNumber NVARCHAR(50)
	,@JobSalesInvoiceNumber NVARCHAR(50)
	,@JobInvoicedDate DateTime2(7)
	,@UpdatedBy NVARCHAR(50)
	,@UpdatedDate DATETIME2(7)
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL000Master]
	SET JobPurchaseInvoiceNumber = CASE WHEN ISNULL(@JobPurchaseInvoiceNumber,'') <> '' THEN @JobPurchaseInvoiceNumber ELSE JobPurchaseInvoiceNumber END
	   ,JobSalesInvoiceNumber = CASE WHEN ISNULL(@JobSalesInvoiceNumber,'') <> '' THEN @JobSalesInvoiceNumber ELSE JobSalesInvoiceNumber END
	   ,JobInvoicedDate = ISNULL(@JobInvoicedDate,JobInvoicedDate)
	   ,DateEntered = @UpdatedDate
	   ,ChangedBy = @UpdatedBy
	WHERE [Id] = @JobId;
END
GO

