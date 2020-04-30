SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/30/2020
-- Description:	Insert Delivery Update Processing Log
CREATE PROCEDURE [dbo].[InsertDeliveryUpdateProcessingLog] @JobId BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (Select 1 From [dbo].[JobDL070DeliveryUpdateProcessingLog] Where JobId = JobId AND ISNULL(IsProcessed, 0) = 0)
	BEGIN
	INSERT INTO [dbo].[JobDL070DeliveryUpdateProcessingLog] (
		JobId
		,IsProcessed
		)
	VALUES (
		@JobId
		,0
		)
		END
END
GO

