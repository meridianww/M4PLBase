SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/30/2020
-- Description:	Update Delivery Update Processing Log
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDeliveryUpdateProcessingLog] (
	 @Id [BIGINT]
	,@IsProcessed [bit] NULL
	,@ProcessingDate [datetime2](7) NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JobDL070DeliveryUpdateProcessingLog]
	SET IsProcessed = @IsProcessed
		,ProcessingDate = @ProcessingDate
	WHERE Id = @Id
END
GO

