SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/30/2020
-- Description:	Get Delivery Update Processing Data
-- =============================================
CREATE PROCEDURE [dbo].[GetDeliveryUpdateProcessingData] 
AS
BEGIN
	SET NOCOUNT ON;

	Select DPL.Id, JobId, job.JobCustomerSalesOrder OrderNumber
	From [dbo].[JobDL070DeliveryUpdateProcessingLog] DPL
	INNER JOIN dbo.JobDL000Master job ON job.Id = DPL.JobId
	WHERE ISNULL(IsProcessed, 0)  = 0
END
GO

