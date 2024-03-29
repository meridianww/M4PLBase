SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 01/07/2020
-- Description:	Delete Job Order Mapping Data
-- =============================================
CREATE PROCEDURE [dbo].[DeleteJobOrderMapping]
(
@EntityName Varchar(50),
@jobId BIGINT,
@isElectronicInvoice BIT
)
AS
BEGIN
SET NOCOUNT ON;
Declare @DocumentNumber Varchar(50)
IF(@EntityName = 'SalesOrder')
BEGIN
Select @DocumentNumber = SONumber From NAV000JobSalesOrderMapping  Where JobId = @JobId AND IsElectronicInvoiced = @isElectronicInvoice

Delete From NAV000JobOrderItemMapping Where Document_Number = @DocumentNumber AND EntityName = 'ShippingItem'
DELETE FROM NAV000JobSalesOrderMapping Where SONumber = @DocumentNumber
END
ELSE IF(@EntityName = 'PurchaseOrder')
BEGIN
Select @DocumentNumber = PONumber From NAV000JobPurchaseOrderMapping  Where JobId = @JobId AND IsElectronicInvoiced = @isElectronicInvoice

Delete From NAV000JobOrderItemMapping Where EntityName = 'PurchaseOrderItem' AND Document_Number = @DocumentNumber
DELETE FROM NAV000JobPurchaseOrderMapping Where PONumber = @DocumentNumber
END
END

GO
