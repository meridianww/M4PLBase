SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Updates the Job Scanner Process Flags 
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobScannerProcessStep]
	-- Add the parameters for the stored procedure here
	@JobId bigint,
	@ProcessStep nvarchar,
	@DataState nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE JOBDL000Master 
	Set ProFlags11 = @ProcessStep,
	ProFlags12 = @DataState
	WHERE Id = @JobId
END
GO
