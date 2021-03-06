SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/20/2018
-- Description:	The stored procedure returns the Prorgram Default Pickup and Delivery Start Times and Thresholds
-- =============================================
CREATE PROCEDURE [dbo].[ediGetProgramDefaultTimesByProgramId]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PrgPickUpTimeDefault, PckEarliest, PckLatest, PckDay, PrgDeliveryTimeDefault, DelEarliest, DelLatest, DelDay FROM PRGRM000Master WHERE Id = @ProgramId AND StatusId = @StatusId
END
GO
