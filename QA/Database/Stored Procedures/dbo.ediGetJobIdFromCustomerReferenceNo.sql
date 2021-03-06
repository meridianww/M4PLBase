SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns the Job ID from the JOBDL000Master table matching the Customer Reference Number.
-- =============================================
CREATE PROCEDURE [dbo].[ediGetJobIdFromCustomerReferenceNo]
	-- Add the parameters for the stored procedure here
	@CustomerReferenceNo nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT JOBDL000Master.Id FROM JOBDL000Master Where JobCustomerSalesOrder = @CustomerReferenceNo
END
GO
