SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Updates the Job Cargo Process Flags 
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobCargoProcessStep]
	-- Add the parameters for the stored procedure here
		-- Add the parameters for the stored procedure here
	@JobId bigint,
	@ProcessStep nvarchar,
	@DataState nvarchar,
	@ProcessingState nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE JOBDL010Cargo 
	Set ProFlags11 = @ProcessStep,
	ProFlags12 = @DataState,
	ProFlags14 = @ProcessingState
	WHERE JobId = @JobId
END
GO
