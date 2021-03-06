SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/3/2018
-- Description:	The stored procedure returns the active Cargo records where the Job ID matches
-- =============================================
CREATE PROCEDURE [dbo].[ediGetCargoRecordsByJobId]
	-- Add the parameters for the stored procedure here
	@JobId bigint,
	@StatusActive int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id]      
      ,[CgoSerialNumber]
      ,[CgoQtyExpected]
      ,[CgoQtyOnHand]
      ,[CgoQtyDamaged]
      ,[CgoQtyOnHold]
      ,[CgoQtyUnits]
      ,[CgoReasonCodeOSD]
      ,[CgoReasonCodeHold]
      ,[CgoSeverityCode]
      ,[StatusId]
  FROM [dbo].[JOBDL010Cargo]
  WHERE [JobID] = @JobId AND [StatusId] = @StatusActive
END
GO
