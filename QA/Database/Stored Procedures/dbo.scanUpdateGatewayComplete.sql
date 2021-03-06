SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Updates the Gateway records that are completed on the Scanner by Job ID and Gateway Sort Number
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateGatewayComplete]
	-- Add the parameters for the stored procedure here
	@JobId bigint,
	@GatewayItemNumber int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE JOBDL020Gateways 
	SET GwyCompleted = 1,
	GwyGatewayACD = GETDATE()
	WHERE JobID = @JobId AND GwyGatewaySortOrder = @GatewayItemNumber
END
GO
