SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 7/13/2018
-- Description:	The stored procedure retrieves the active M4PL Processors records
-- =============================================
CREATE PROCEDURE [dbo].[proGetActiveProcessors]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT[ID]
      ,[ProCode]
      ,[ProTitle]
      ,[ProDescription]
      ,[ProLocation]
      ,[ProProcess]
      ,[ProEnabled]
      ,[ProFrequency]
      ,[ProIntervalValue]
      ,[ProIntervalUnit]
      ,[ProStartTime]
      ,[ProEndTime]
      ,[ProSunday]
      ,[ProMonday]
      ,[ProTuesday]
      ,[ProWednesday]
      ,[ProThursday]
      ,[ProFriday]
      ,[ProSaturday]
      ,[ProLastRun]
      ,[ProFinished]
      ,[ProFinishStatus]
      ,[EnteredBy]
      ,[DateEntered]
      ,[ChangedBy]
      ,[DateChanged]
  FROM [SYSTM000ProcessorMaster]
  WHERE ProEnabled = 1

END
GO
