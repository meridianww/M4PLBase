SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 7/25/2018
-- Description:	The stored procedure updates the JOBDL010Cargo table Status field for Job ID matches
-- =============================================
CREATE PROCEDURE [dbo].[ediUpdateCargoStatus]
	-- Add the parameters for the stored procedure here
	@JobId bigint,
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[JOBDL010Cargo]
	SET [StatusId] = @StatusId
    WHERE [JobID] = @JobId
END
GO
