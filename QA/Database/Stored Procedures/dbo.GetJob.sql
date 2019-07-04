SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job   
-- Execution:                 EXEC [dbo].[GetJob]     
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================        
CREATE PROCEDURE [dbo].[GetJob]
    @userId BIGINT,      
    @roleId BIGINT,      
    @orgId BIGINT,      
    @id BIGINT,  
 @parentId BIGINT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;      
   
 IF @id = 0   
 BEGIN  
      DECLARE @pickupTime TIME,@deliveryTime TIME  ,@programCode NVARCHAR(50)

   SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)  
      ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME) 
	 ,@programCode =  CASE WHEN PrgHierarchyLevel = 1 THEN     [PrgProgramCode]
		                  WHEN PrgHierarchyLevel = 2 THEN     [PrgProjectCode]
		                  WHEN PrgHierarchyLevel = 3 THEN     PrgPhaseCode
		                  ELSE [PrgProgramTitle] END 
	   
   FROM PRGRM000MASTER 
   
   WHERE Id = @parentId;  
  
   SELECT @parentId AS ProgramID  
         ,@programCode AS ProgramIDName
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline  
  
 END  
 ELSE  
 BEGIN  
  SELECT job.[Id]      
  ,job.[JobMITJobID]      
  ,job.[ProgramID] 
  ,CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS ProgramIDName
  
       
  ,job.[JobSiteCode]      
  ,job.[JobConsigneeCode]      
  ,job.[JobCustomerSalesOrder]      
  ,job.[JobBOL]      
  ,job.[JobBOLMaster]      
  ,job.[JobBOLChild]      
  ,job.[JobCustomerPurchaseOrder]      
  ,job.[JobCarrierContract]     
  ,job.[JobManifestNo]   
  ,job.[JobGatewayStatus]      
  ,job.[StatusId]      
  ,job.[JobStatusedDate]      
  ,job.[JobCompleted]      
  ,job.[JobType]    
  ,job.[ShipmentType]  
  ,job.[JobDeliveryAnalystContactID]     
  ,job.[JobDeliveryResponsibleContactID]      
  ,job.[JobDeliverySitePOC]      
  ,job.[JobDeliverySitePOCPhone]      
  ,job.[JobDeliverySitePOCEmail]      
  ,job.[JobDeliverySiteName]      
  ,job.[JobDeliveryStreetAddress]      
  ,job.[JobDeliveryStreetAddress2]      
  ,job.[JobDeliveryCity]      
  ,job.[JobDeliveryState]      
  ,job.[JobDeliveryPostalCode]      
  ,job.[JobDeliveryCountry]      
  ,job.[JobDeliveryTimeZone]   
  ,job.[JobDeliveryDateTimePlanned]
  ,job.[JobDeliveryDateTimeActual]
  ,job.[JobDeliveryDateTimeBaseline] 
  ,job.[JobDeliveryRecipientPhone]      
  ,job.[JobDeliveryRecipientEmail]      
  ,job.[JobLatitude]      
  ,job.[JobLongitude]      
  ,job.[JobOriginResponsibleContactID]      
  ,job.[JobOriginSitePOC]      
  ,job.[JobOriginSitePOCPhone]      
  ,job.[JobOriginSitePOCEmail]      
  ,job.[JobOriginSiteName]      
  ,job.[JobOriginStreetAddress]      
  ,job.[JobOriginStreetAddress2]      
  ,job.[JobOriginCity]      
  ,job.[JobOriginState]      
  ,job.[JobOriginPostalCode]      
  ,job.[JobOriginCountry]      
  ,job.[JobOriginTimeZone]      
  ,job.[JobOriginDateTimePlanned] 
  ,job.[JobOriginDateTimeActual] 
  ,job.[JobOriginDateTimeBaseline] 
  ,job.[JobProcessingFlags]      
  ,job.[JobDeliverySitePOC2]           
  ,job.[JobDeliverySitePOCPhone2]      
  ,job.[JobDeliverySitePOCEmail2]      
  ,job.[JobOriginSitePOC2]             
  ,job.[JobOriginSitePOCPhone2]        
  ,job.[JobOriginSitePOCEmail2]        
  ,job.JobSellerCode      
  ,job.JobSellerSitePOC      
  ,job.JobSellerSitePOCPhone      
  ,job.JobSellerSitePOCEmail      
  ,job.JobSellerSitePOC2      
  ,job.JobSellerSitePOCPhone2      
  ,job.JobSellerSitePOCEmail2      
  ,job.JobSellerSiteName      
  ,job.JobSellerStreetAddress      
  ,job.JobSellerStreetAddress2      
  ,job.JobSellerCity      
  ,job.JobSellerState      
  ,job.JobSellerPostalCode      
  ,job.JobSellerCountry      
  ,job.[JobUser01]        
  ,job.[JobUser02]        
  ,job.[JobUser03]        
  ,job.[JobUser04]        
  ,job.[JobUser05]        
  ,job.[JobStatusFlags]      
  ,job.[JobScannerFlags] 
       
  ,job.[PlantIDCode]      
  ,job.[CarrierID]      
  ,job.[JobDriverId]      
  ,job.[WindowDelStartTime]      
  ,job.[WindowDelEndTime]      
  ,job.[WindowPckStartTime]       
  ,job.[WindowPckEndTime]      
  ,job.[JobRouteId]      
  ,job.[JobStop]       
  ,job.[JobSignText]      
  ,job.[JobSignLatitude]     
  ,job.[JobSignLongitude] 
       
  ,job.[EnteredBy]      
  ,job.[DateEntered]      
  ,job.[ChangedBy]      
  ,job.[DateChanged]      
  FROM [dbo].[JOBDL000Master] job   
  INNER JOIN  PRGRM000MASTER prg On job.ProgramID = prg.Id
     
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
