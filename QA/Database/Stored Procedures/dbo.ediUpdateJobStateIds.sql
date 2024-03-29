SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure Updates the State ID values for the specified Job ID record
-- =============================================
CREATE PROCEDURE [dbo].[ediUpdateJobStateIds]
	-- Add the parameters for the stored procedure here
	@DeliveryStateId int,
	@OriginStateId int,
	@SellerStateId int,
	@JobId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE [dbo].[JOBDL000Master] SET JobDeliveryStateId = @DeliveryStateId, JobOriginStateId = @OriginStateId, JobSellerStateId = @SellerStateId WHERE Id = @JobId
END
GO
