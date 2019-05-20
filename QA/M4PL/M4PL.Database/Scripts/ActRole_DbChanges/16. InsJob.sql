/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/14/2018              
-- Description:               Ins a Job            
-- Execution:                 EXEC [dbo].[InsJob]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:          
-- =============================================              
              
ALTER PROCEDURE  [dbo].[InsJob]              
	(@userId BIGINT              
	,@roleId BIGINT 
	,@entity NVARCHAR(100)              
	,@jobMITJobId bigint = NULL              
	,@programId bigint = NULL              
	,@jobSiteCode nvarchar(30) = NULL              
	,@jobConsigneeCode nvarchar(30) = NULL              
	,@jobCustomerSalesOrder nvarchar(30) = NULL    
	,@jobBOL nvarchar(30) = NULL           
	,@jobBOLMaster nvarchar(30) = NULL              
	,@jobBOLChild nvarchar(30) = NULL              
	,@jobCustomerPurchaseOrder nvarchar(30) = NULL              
	,@jobCarrierContract nvarchar(30) = NULL        
	,@jobManifestNo  varchar(30) = NULL      
	,@jobGatewayStatus  nvarchar(50) = NULL              
	,@statusId int = NULL              
	,@jobStatusedDate datetime2(7) = NULL              
	,@jobCompleted bit = NULL           
	,@jobType nvarchar(20) = NULL          
	,@shipmentType nvarchar(20) = NULL     
	,@jobDeliveryAnalystContactID bigint =Null         
	,@jobDeliveryResponsibleContactId bigint = NULL              
	,@jobDeliverySitePOC nvarchar(75) = NULL              
	,@jobDeliverySitePOCPhone nvarchar(50) = NULL              
	,@jobDeliverySitePOCEmail nvarchar(50) = NULL              
	,@jobDeliverySiteName nvarchar(50) = NULL              
	,@jobDeliveryStreetAddress nvarchar(100) = NULL              
	,@jobDeliveryStreetAddress2 nvarchar(100) = NULL              
	,@jobDeliveryCity nvarchar(50) = NULL              
	,@jobDeliveryState nvarchar(50) = NULL        
	,@jobDeliveryPostalCode nvarchar(50) = NULL              
	,@jobDeliveryCountry nvarchar(50) = NULL            
	,@jobDeliveryTimeZone nvarchar(15) = NULL              
	,@jobDeliveryDateTimePlanned datetime2(7) = NULL               
	,@jobDeliveryDateTimeActual datetime2(7) = NULL                
	,@jobDeliveryDateTimeBaseline datetime2(7) = NULL            
	,@jobDeliveryRecipientPhone nvarchar(50) = NULL              
	,@jobDeliveryRecipientEmail nvarchar(50) = NULL              
	,@jobLatitude nvarchar(50) = NULL              
	,@jobLongitude nvarchar(50) = NULL              
	,@jobOriginResponsibleContactId bigint = NULL              
	,@jobOriginSitePOC nvarchar(75) = NULL              
	,@jobOriginSitePOCPhone nvarchar(50) = NULL              
	,@jobOriginSitePOCEmail nvarchar(50) = NULL              
	,@jobOriginSiteName nvarchar(50) = NULL              
	,@jobOriginStreetAddress nvarchar(100) = NULL              
	,@jobOriginStreetAddress2 nvarchar(100) = NULL              
	,@jobOriginCity nvarchar(50) = NULL              
	,@jobOriginState nvarchar(50) = NULL              
	,@jobOriginPostalCode nvarchar(50) = NULL              
	,@jobOriginCountry nvarchar(50) = NULL        
	,@jobOriginTimeZone nvarchar(15) = NULL              
	,@jobOriginDateTimePlanned datetime2(7) = NULL            
	,@jobOriginDateTimeActual datetime2(7) = NULL             
	,@jobOriginDateTimeBaseline datetime2(7) = NULL             
	,@jobProcessingFlags nvarchar(20) = NULL               
	,@jobDeliverySitePOC2 nvarchar(75) = NULL              
	,@jobDeliverySitePOCPhone2 nvarchar(50) = NULL              
	,@jobDeliverySitePOCEmail2 nvarchar(50) = NULL              
	,@jobOriginSitePOC2 nvarchar(75) = NULL              
	,@jobOriginSitePOCPhone2 nvarchar(50) = NULL              
	,@jobOriginSitePOCEmail2 nvarchar(50) = NULL              
	,@jobSellerCode NVARCHAR(20) =NULL              
	,@jobSellerSitePOC NVARCHAR(75) =NULL    
	,@jobSellerSitePOCPhone NVARCHAR(50) =NULL              
	,@jobSellerSitePOCEmail NVARCHAR(50) =NULL              
	,@jobSellerSitePOC2 NVARCHAR(75) =NULL              
	,@jobSellerSitePOCPhone2 NVARCHAR(50) =NULL              
	,@jobSellerSitePOCEmail2 NVARCHAR(50) =NULL              
	,@jobSellerSiteName NVARCHAR(50) =NULL              
	,@jobSellerStreetAddress NVARCHAR(100) =NULL              
	,@jobSellerStreetAddress2 NVARCHAR(100) =NULL              
	,@jobSellerCity NVARCHAR(50) =NULL              
	,@jobSellerState nvarchar(50) = NULL          
	,@jobSellerPostalCode NVARCHAR(50) =NULL              
	,@jobSellerCountry nvarchar(50) = NULL            
	,@jobUser01 NVARCHAR(20) =NULL              
	,@jobUser02 NVARCHAR(20) =NULL              
	,@jobUser03 NVARCHAR(20) =NULL              
	,@jobUser04 NVARCHAR(20) =NULL              
	,@jobUser05 NVARCHAR(20) =NULL              
	,@jobStatusFlags NVARCHAR(20) =NULL              
	,@jobScannerFlags NVARCHAR(20) =NULL
	,@plantIDCode NVARCHAR(30) =NULL
	,@carrierID NVARCHAR(30) =NULL
	,@jobDriverId BIGINT =NULL
	,@windowDelStartTime DATETIME2(7) =NULL
	,@windowDelEndTime DATETIME2(7) =NULL
	,@windowPckStartTime DATETIME2(7) =NULL
	,@windowPckEndTime DATETIME2(7) =NULL
	,@jobRouteId INT =NULL
	,@jobStop NVARCHAR(20) =NULL
	,@jobSignText NVARCHAR(75) =NULL
	,@jobSignLatitude NVARCHAR(50) =NULL
	,@jobSignLongitude NVARCHAR(50) =NULL
	,@enteredBy nvarchar(50) = NULL              
	,@dateEntered datetime2(7) = NULL)              
AS              
BEGIN TRY                              
 SET NOCOUNT ON;                 
 DECLARE @currentId BIGINT;      
 --Adding this to handle job gatweay item number issue
 DECLARE @updatedItemNumber INT;
 
 INSERT INTO [dbo].[JOBDL000Master]              
           ([JobMITJobID]              
   ,[ProgramID]              
   ,[JobSiteCode]              
   ,[JobConsigneeCode]              
   ,[JobCustomerSalesOrder]        
   ,[JobBOL]          
   ,[JobBOLMaster]              
   ,[JobBOLChild]              
   ,[JobCustomerPurchaseOrder]              
   ,[JobCarrierContract]          
   ,[JobManifestNo]          
   ,[JobGatewayStatus]              
   ,[StatusId]              
   ,[JobStatusedDate]              
   ,[JobCompleted]            
   ,[JobType]          
   ,[ShipmentType]     
   ,[JobDeliveryAnalystContactID]             
   ,[JobDeliveryResponsibleContactID]              
   ,[JobDeliverySitePOC]              
   ,[JobDeliverySitePOCPhone]              
   ,[JobDeliverySitePOCEmail]              
   ,[JobDeliverySiteName]              
   ,[JobDeliveryStreetAddress]              
   ,[JobDeliveryStreetAddress2]              
   ,[JobDeliveryCity]              
   ,[JobDeliveryState]              
   ,[JobDeliveryPostalCode]              
   ,[JobDeliveryCountry]              
   ,[JobDeliveryTimeZone]              
   ,[JobDeliveryDateTimePlanned]              
               
   ,[JobDeliveryDateTimeActual]              
               
   ,[JobDeliveryDateTimeBaseline]              
               
   ,[JobDeliveryRecipientPhone]              
   ,[JobDeliveryRecipientEmail]              
   ,[JobLatitude]              
   ,[JobLongitude]              
   ,[JobOriginResponsibleContactID]              
   ,[JobOriginSitePOC]              
   ,[JobOriginSitePOCPhone]              
   ,[JobOriginSitePOCEmail]              
   ,[JobOriginSiteName]              
   ,[JobOriginStreetAddress]              
   ,[JobOriginStreetAddress2]              
   ,[JobOriginCity]              
   ,[JobOriginState]              
   ,[JobOriginPostalCode]              
   ,[JobOriginCountry]              
   ,[JobOriginTimeZone]              
   ,[JobOriginDateTimePlanned]              
                
   ,[JobOriginDateTimeActual]              
               
   ,[JobOriginDateTimeBaseline]              
               
   ,[JobProcessingFlags]              
   ,[JobDeliverySitePOC2]                     
   ,[JobDeliverySitePOCPhone2]                
   ,[JobDeliverySitePOCEmail2]                
   ,[JobOriginSitePOC2]                       
   ,[JobOriginSitePOCPhone2]                  
   ,[JobOriginSitePOCEmail2]                  
   ,[JobSellerCode]              
   ,[JobSellerSitePOC]              
   ,[JobSellerSitePOCPhone]              
   ,[JobSellerSitePOCEmail]              
   ,[JobSellerSitePOC2]              
   ,[JobSellerSitePOCPhone2]              
   ,[JobSellerSitePOCEmail2]              
   ,[JobSellerSiteName]              
   ,[JobSellerStreetAddress]          
   ,[JobSellerStreetAddress2]              
   ,[JobSellerCity]              
   ,[JobSellerState]              
   ,[JobSellerPostalCode]              
   ,[JobSellerCountry]              
   ,[JobUser01]                
   ,[JobUser02]                
   ,[JobUser03]                
   ,[JobUser04]                
   ,[JobUser05]                
   ,[JobStatusFlags]               
   ,[JobScannerFlags] 
   ,[PlantIDCode]      
   ,[CarrierID]      
   ,[JobDriverId]      
   ,[WindowDelStartTime]      
   ,[WindowDelEndTime]      
   ,[WindowPckStartTime]       
   ,[WindowPckEndTime]      
   ,[JobRouteId]      
   ,[JobStop]       
   ,[JobSignText]      
   ,[JobSignLatitude]     
   ,[JobSignLongitude]               
   ,[EnteredBy]              
   ,[DateEntered])              
     VALUES              
           (@jobMITJobId              
   ,@programId              
   ,@jobSiteCode              
   ,@jobConsigneeCode              
   ,@jobCustomerSalesOrder  
   ,@jobBOL              
   ,@jobBOLMaster              
   ,@jobBOLChild              
   ,@jobCustomerPurchaseOrder              
   ,@jobCarrierContract         
   ,@jobManifestNo         
   ,@jobgatewayStatus
   ,@statusId              
   ,@jobStatusedDate              
   ,@jobCompleted          
   ,@jobType        
   ,@shipmentType        
   ,@jobDeliveryAnalystContactID    
   ,@jobDeliveryResponsibleContactId              
   ,@jobDeliverySitePOC              
   ,@jobDeliverySitePOCPhone              
   ,@jobDeliverySitePOCEmail              
   ,@jobDeliverySiteName              
   ,@jobDeliveryStreetAddress              
   ,@jobDeliveryStreetAddress2              
   ,@jobDeliveryCity              
   ,@jobDeliveryState              
   ,@jobDeliveryPostalCode              
   ,@jobDeliveryCountry              
   ,@jobDeliveryTimeZone              
   ,@jobDeliveryDateTimePlanned              
               
   ,CASE WHEN ISNULL(@jobCompleted,0) =1 AND @jobDeliveryDateTimeActual IS NULL THEN  GETUTCDATE()  ELSE  @jobDeliveryDateTimeActual END           
              
   ,@jobDeliveryDateTimeBaseline              
               
   ,@jobDeliveryRecipientPhone              
   ,@jobDeliveryRecipientEmail              
   ,@jobLatitude              
   ,@jobLongitude              
   ,@jobOriginResponsibleContactID              
   ,@jobOriginSitePOC              
   ,@jobOriginSitePOCPhone              
   ,@jobOriginSitePOCEmail              
   ,@jobOriginSiteName              
   ,@jobOriginStreetAddress              
   ,@jobOriginStreetAddress2              
   ,@jobOriginCity              
   ,@jobOriginState              
   ,@jobOriginPostalCode              
   ,@jobOriginCountry              
   ,@jobOriginTimeZone              
   ,@jobOriginDateTimePlanned              
            
   ,CASE WHEN ISNULL(@jobCompleted,0) =1 AND @jobOriginDateTimeActual  IS NULL THEN  GETUTCDATE()  ELSE  @jobOriginDateTimeActual  END               
             
   ,@jobOriginDateTimeBaseline              
              
   ,@jobProcessingFlags              
   ,@jobDeliverySitePOC2              
   ,@jobDeliverySitePOCPhone2              
   ,@jobDeliverySitePOCEmail2              
   ,@jobOriginSitePOC2              
   ,@jobOriginSitePOCPhone2              
   ,@jobOriginSitePOCEmail2              
   ,@jobSellerCode              
   ,@jobSellerSitePOC              
   ,@jobSellerSitePOCPhone              
   ,@jobSellerSitePOCEmail              
   ,@jobSellerSitePOC2              
   ,@jobSellerSitePOCPhone2              
   ,@jobSellerSitePOCEmail2              
   ,@jobSellerSiteName              
   ,@jobSellerStreetAddress              
   ,@jobSellerStreetAddress2              
   ,@jobSellerCity              
   ,@jobSellerState              
   ,@jobSellerPostalCode              
   ,@jobSellerCountry              
   ,@jobUser01              
   ,@jobUser02              
   ,@jobUser03              
   ,@jobUser04              
   ,@jobUser05              
   ,@jobStatusFlags              
   ,@jobScannerFlags 
   ,@plantIDCode
   ,@carrierID
   ,@jobDriverId
   ,@windowDelStartTime
   ,@windowDelEndTime
   ,@windowPckStartTime
   ,@windowPckEndTime
   ,@jobRouteId
   ,@jobStop
   ,@jobSignText
   ,@jobSignLatitude
   ,@jobSignLongitude
   ,@enteredBy              
   ,@dateEntered)              
              
   SET @currentId = SCOPE_IDENTITY();              
                 
 EXEC  [dbo].[CopyJobGatewayFromProgram] @currentId,@programId,@dateEntered,@enteredBy, @userId       
     
      
           
              
   -- INSERT DEFAULT  PROGRAM ATTRIBUTES INTO Job ATTRIBUTES              
   INSERT INTO JOBDL030Attributes              
   (JobID,              
   AjbLineOrder,              
   AjbAttributeCode,              
   AjbAttributeTitle,              
   AjbAttributeDescription,              
   AjbAttributeComments,              
   AjbAttributeQty,              
   AjbUnitTypeId,              
   AjbDefault,              
   StatusId,              
  DateEntered,              
   EnteredBy)              
   SELECT @currentId, ROW_NUMBER() OVER(ORDER BY prgm.AttItemNumber) ,prgm.AttCode,prgm.AttTitle,prgm.AttDescription,prgm.AttComments, prgm.AttQuantity,prgm.UnitTypeId,prgm.AttDefault,prgm.StatusId,@dateEntered,@enteredBy               
  FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm               
  INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId              
  WHERE AttDefault = 1 AND  prgm.ProgramID = @programId        
  ORDER BY prgm.AttItemNumber  ;              
         
  
  
  -- INSERT INTO CustomerContacts vendorContact and programContacts WHERE JobGateway Analyst Is Selected In RefRole    
  DECLARE @orgId BIGINT,@custId BIGINT    
  SELECT  @orgId = pgm.PrgOrgID,@custId =  pgm.PrgCustID FROM [JOBDL000Master] job    
  INNER JOIN PRGRM000Master pgm ON job.ProgramID = pgm.Id     
  WHERE job.Id = @currentId;    
         
  EXEC [dbo].[GetJob] @userId,@roleId,0,@currentId,@programId    ;    
              
 --SELECT * FROM [dbo].[JOBDL000Master] WHERE Id = @currentId;                 
END TRY                            
BEGIN CATCH                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO

