SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/12/2018
-- Description:	The stored procedure returns the Cargo ID where the Job ID matches
-- =============================================
CREATE PROCEDURE [dbo].[ediGetCargoIdByJobId]
	-- Add the parameters for the stored procedure here
	@JobId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Id FROM JOBDL010Cargo Where JobID = @JobId
END
GO
