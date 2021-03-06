SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobDestination  
-- Execution:                 EXEC [dbo].[GetJobDestination]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE [dbo].[GetJobDestination] --  1,'SYSAMIN',1,0,55
    @userId BIGINT,  
    @roleId BIGINT,  
    @orgId BIGINT,  
    @id BIGINT,
	@parentId BIGINT  ,
	@PacificTime DATETIME2(7)
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  IF @id = 0 
 BEGIN
      DECLARE @pickupTime TIME,@deliveryTime TIME
	  DECLARE @pckEarliest DECIMAL(18,2)
	  DECLARE @pckLatest DECIMAL(18,2)
	  DECLARE @pckDay BIT
	  DECLARE @delEarliest DECIMAL(18,2)
	  DECLARE @delLatest DECIMAL(18,2)
	  DECLARE @delDay BIT
	  DECLARE @prgPickUpTimeDefault DATETIME2(7)
     DECLARE @prgDeliveryTimeDefault DATETIME2(7)
	 DECLARE @startDateTime DATETIME2(7)
	 DECLARE @endDateTime DATETIME2(7)
		 SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			   ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME)
			   ,@pckEarliest = PckEarliest
			   ,@pckLatest  = PckLatest
			   ,@pckDay  = PckDay
			   ,@delEarliest  = DelEarliest
			   ,@delLatest = DelLatest
			   ,@delDay = DelDay
			   ,@prgPickUpTimeDefault = PrgPickUpTimeDefault 
               ,@prgDeliveryTimeDefault =PrgDeliveryTimeDefault 
			   ,@startDateTime=PrgDateStart
			   ,@endDateTime=PrgDateEnd

		 FROM PRGRM000MASTER WHERE Id = @parentId;

		 SELECT @parentId AS ProgramID
		        ,CAST(CAST(@PacificTime as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned
				,CAST(CAST(@PacificTime as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual
				--modified for datetime issue
				--,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(ISNULL(@endDateTime,@PacificTime) AS DATE) AS DATETIME)+ CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(@PacificTime as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned
				,CAST(CAST(@PacificTime as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual
				--,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline
				,CAST(CAST(ISNULL(@startDateTime,@PacificTime) AS DATE) AS DATETIME)+ CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline
			   ,@pckEarliest AS PckEarliest
			   ,@pckLatest  As PckLatest
			   ,@pckDay  AS PckDay
			   ,@delEarliest  AS DelEarliest
			   ,@delLatest AS DelLatest
			   ,@delDay AS DelDay

			   ,@prgPickUpTimeDefault  AS ProgramPickupDefault
               ,@prgDeliveryTimeDefault AS ProgramDeliveryDefault



 END
 ELSE
 BEGIN
 
 
     
  SELECT job.[Id]  
  ,job.[StatusId]  
  ,job.[JobDeliverySitePOC]  
  ,job.[JobDeliverySitePOCPhone]  
  ,job.[JobDeliverySitePOCEmail]  
  ,job.[JobDeliverySiteName]  
  ,job.[JobDeliveryStreetAddress]  
  ,job.[JobDeliveryStreetAddress2] 
  ,job.[JobDeliveryStreetAddress3] 
  ,job.[JobDeliveryStreetAddress4]  
  ,job.[JobDeliveryCity]  
  ,job.[JobDeliveryState]  
  ,job.[JobDeliveryPostalCode]  
  ,job.[JobDeliveryCountry]  
  ,job.[JobDeliveryTimeZone]  
  ,job.[JobDeliveryDateTimePlanned]  
  
  ,job.[JobDeliveryDateTimeActual]  
   
  ,job.[JobDeliveryDateTimeBaseline]  


	,job.[JobOriginSitePOC2]  
	,job.[JobOriginSitePOCPhone2]  
	,job.[JobOriginSitePOCEmail2]  
	,job.[JobDeliverySitePOC2]  
	,job.[JobDeliverySitePOCPhone2]  
	,job.[JobDeliverySitePOCEmail2]   
	,job.[JobPreferredMethod]  

  ,job.[JobOriginSitePOC]  
  ,job.[JobOriginSitePOCPhone]  
  ,job.[JobOriginSitePOCEmail]  
  ,job.[JobOriginSiteName]  
  ,job.[JobOriginStreetAddress]  
  ,job.[JobOriginStreetAddress2]
  ,job.[JobOriginStreetAddress3]
  ,job.[JobOriginStreetAddress4]  
  ,job.[JobOriginCity]  
  ,job.[JobOriginState]  
  ,job.[JobOriginPostalCode]  
  ,job.[JobOriginCountry]  
  ,job.[JobOriginTimeZone]  
  ,job.[JobOriginDateTimePlanned]  
  
  ,job.[JobOriginDateTimeActual]  
    
  ,job.[JobOriginDateTimeBaseline]  
  ,job.[JobCompleted]  
  ,job.[EnteredBy]    
  ,job.[DateEntered]    
  ,job.[ChangedBy]    
  ,job.[DateChanged]    

  ,job.WindowDelStartTime
  ,job.WindowDelEndTime
  ,job.WindowPckStartTime
  ,job.WindowPckEndTime

  ,job.JobSignText
  ,job.JobSignLatitude
  ,job.JobSIgnLongitude
  ,job.IsJobVocSurvey
               , pgm.PckEarliest
			   , pgm.PckLatest
			   , pgm.PckDay
			   , pgm.DelEarliest
			   , pgm.DelLatest
			   , pgm.DelDay
			   ,pgm.PrgPickUpTimeDefault AS ProgramPickupDefault
               ,pgm.PrgDeliveryTimeDefault AS ProgramDeliveryDefault



  FROM [dbo].[JOBDL000Master] job 
  INNER JOIN PRGRM000Master pgm ON job.ProgramID = pgm.Id 
 WHERE job.[Id] = @id  
 END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH

GO
