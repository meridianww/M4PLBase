SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/14/2020
-- Description:	Get Cargo List For Job
-- =============================================
CREATE PROCEDURE [dbo].[GetCargoListForJob] 
(
@jobId BIGINT
)
AS
BEGIN                
 SET NOCOUNT ON;   
  SELECT job.Id
      ,job.[JobID]
      ,job.[CgoLineItem]
      ,job.[CgoPartNumCode]
      ,job.[CgoTitle]
      ,job.[CgoSerialNumber]
      ,job.[CgoPackagingType]
	  ,job.[CgoPackagingTypeId]
      ,job.[CgoMasterCartonLabel]
      ,job.[CgoWeight]
      ,job.[CgoWeightUnits]
      ,job.[CgoLength]
      ,job.[CgoWidth]
      ,job.[CgoHeight]
      ,job.[CgoVolumeUnits]
      ,job.[CgoCubes]
      ,job.[CgoNotes]
      ,job.[CgoQtyExpected]
      ,job.[CgoQtyOnHand]
      ,job.[CgoQtyDamaged]
      ,job.[CgoQtyOnHold]
	  ,job.[CgoQtyShortOver]
      ,job.[CgoQtyUnits]
	  ,job.[CgoQtyUnitsId]
      ,job.[CgoReasonCodeOSD]
      ,job.[CgoReasonCodeHold]
      ,job.[CgoSeverityCode]
      ,job.[CgoLatitude]
      ,job.[CgoLongitude]
      ,job.[StatusId]
      ,job.[EnteredBy]
      ,job.[DateEntered]
      ,job.[ChangedBy]
      ,job.[DateChanged]
	  ,job.[CgoComment]
	  ,job.[CgoWeightUnitsId]
	  ,job.[CgoVolumeUnitsId]
  FROM   [dbo].[JOBDL010Cargo] job
 WHERE   [JobId] = @jobId
END 
GO
