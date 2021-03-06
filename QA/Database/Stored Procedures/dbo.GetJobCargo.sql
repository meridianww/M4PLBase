SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Cargo 
-- Execution:                 EXEC [dbo].[GetJobCargo]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[GetJobCargo]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
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
      --,job.[CgoProcessingFlags]
      ,job.[EnteredBy]
      ,job.[DateEntered]
      ,job.[ChangedBy]
      ,job.[DateChanged]
	  ,job.[CgoComment]
	  ,job.[CgoWeightUnitsId]
	  ,job.[CgoVolumeUnitsId]
	  ,job.[CgoQtyOver]
	  ,job.[CgoQtyOrdered]
	  ,job.[CgoDateLastScan]
	  ,JobMaster.JobGatewayStatus
	  ,Prg.PrgCustId CustomerId
  FROM   [dbo].[JOBDL010Cargo] job
  INNER JOIN dbo.JOBDL000Master JobMaster
  INNER JOIN dbo.PRGRM000Master Prg ON Prg.Id = JobMaster.ProgramId
  ON job.JobID=JobMaster.id 
  and job.Id=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
