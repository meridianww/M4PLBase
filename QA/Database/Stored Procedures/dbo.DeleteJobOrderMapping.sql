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
@documentNumber Varchar(50)
)
AS
BEGIN
SET NOCOUNT ON;
Declare @JobId BIGINT,@JobSalesOrderMappingId BIGINT 
IF(@EntityName = 'SalesOrder')
BEGIN
Select @JobId = JobId, @JobSalesOrderMappingId = JobSalesOrderMappingId From NAV000JobSalesOrderMapping Where SONumber = @documentNumber
Delete From NAV000JobOrderItemMapping Where JobId = @JobId
Delete From NAV000JobPurchaseOrderMapping Where JobSalesOrderMappingId = @JobSalesOrderMappingId
DELETE FROM NAV000JobSalesOrderMapping Where JobSalesOrderMappingId = @JobSalesOrderMappingId
END
ELSE IF(@EntityName = 'PurchaseOrder')
BEGIN
Delete From NAV000JobOrderItemMapping Where EntityName = 'PurchaseOrderItem' AND Document_Number = @documentNumber
DELETE FROM NAV000JobPurchaseOrderMapping Where PONumber = @documentNumber
END
END

GO
