SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/16/2018
-- Description:	The stored procedure Deletes the Scanner Cargo Records for the Job ID
-- =============================================
CREATE PROCEDURE [dbo].[scanDeleteCargoForJobId]
	-- Add the parameters for the stored procedure here
	@JobId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM SCN005Cargo WHERE JobID = @JobId
END
GO
