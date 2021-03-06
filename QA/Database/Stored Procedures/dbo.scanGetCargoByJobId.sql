SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure returns the Job Cargo records for the Job ID
-- =============================================
CREATE PROCEDURE [dbo].[scanGetCargoByJobId]
	-- Add the parameters for the stored procedure here
	@JobId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id]
      ,[JobID]
      ,[CgoLineItem]
      ,[CgoPartNumCode]
      ,[CgoTitle]
      ,[CgoSerialNumber]
      ,[CgoPackagingType]
      ,[CgoWeight]
      ,[CgoWeightUnits]
      ,[CgoLength]
      ,[CgoWidth]
      ,[CgoHeight]
      ,[CgoVolumeUnits]
      ,[CgoCubes]
      ,[CgoNotes]
      ,[CgoQtyExpected]
      ,[CgoQtyOnHand]
      ,[CgoQtyDamaged]
      ,[CgoQtyOnHold]
      ,[CgoQtyUnits]
      ,[CgoReasonCodeOSD]
      ,[CgoReasonCodeHold]
      ,[CgoSeverityCode]
      ,[StatusId]
      ,[ProFlags01]
      ,[ProFlags02]
      ,[ProFlags03]
      ,[ProFlags04]
      ,[ProFlags05]
      ,[ProFlags06]
      ,[ProFlags07]
      ,[ProFlags08]
      ,[ProFlags09]
      ,[ProFlags10]
      ,[ProFlags11]
      ,[ProFlags12]
      ,[ProFlags13]
      ,[ProFlags14]
      ,[ProFlags15]
      ,[ProFlags16]
      ,[ProFlags17]
      ,[ProFlags18]
      ,[ProFlags19]
      ,[ProFlags20]
      ,[EnteredBy]
      ,[DateEntered]
      ,[ChangedBy]
      ,[DateChanged]
      ,[CgoQtyOrdered]
      ,[CgoQtyCounted]
      ,[CgoQtyShortOver]
      ,[CgoQtyOver]
      ,[CgoLongitude]
      ,[CgoLatitude]
  FROM [dbo].[JOBDL010Cargo]
  WHERE JobID = @JobId
END
GO
