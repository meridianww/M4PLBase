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
@soNumber Varchar(50)
)
AS
BEGIN
SET NOCOUNT ON;
IF(@EntityName = 'SalesOrder')
BEGIN
Delete From NAV000JobOrderItemMapping Where EntityName = 'ShippingItem' AND Document_Number = @soNumber
DELETE FROM NAV000JobSalesOrderMapping Where SONumber = @soNumber
END
END
GO
