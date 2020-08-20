SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/28/2020
-- Description:	Insert Job Delivery Update Log
-- =============================================
CREATE PROCEDURE [dbo].[InsertFarEyeJobDeliveryUpdateLog] (
	 @JobId [bigint]
	,@DeliveryUpdateRequest [nvarchar](max)
	,@DeliveryUpdateResponse [nvarchar](max)
	,@IsProcessed [bit]
	,@ProcessingDate [datetime2](7)
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[JobDL085FarEyeDeliveryUpdate] (
		 JobId
		,DeliveryUpdateRequest
		,DeliveryUpdateResponse
		,IsProcessed
		,ProcessingDate
		)
	VALUES (
		@JobId
		,@DeliveryUpdateRequest
		,@DeliveryUpdateResponse
		,@IsProcessed
		,@ProcessingDate
		)
END

GO
