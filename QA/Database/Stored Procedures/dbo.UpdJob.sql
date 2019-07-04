SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job     
-- Execution:                 EXEC [dbo].[UpdJob]    
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================       
CREATE PROCEDURE  [dbo].[UpdJob]      
	(@userId BIGINT      
	,@roleId BIGINT  
	,@entity NVARCHAR(100)      
	,@id bigint      
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
	,@jobGatewayStatus NVARCHAR(50) = NULL      
	,@statusId int = NULL      
	,@jobStatusedDate datetime2(7) = NULL      
	,@jobCompleted bit = NULL      
	,@jobType nvarchar(20) = NULL    
	,@shipmentType nvarchar(20) = NULL  
	,@jobDeliveryAnalystContactID BIGINT =NULL
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
	,@changedBy nvarchar(50) = NULL      
	,@dateChanged datetime2(7) = NULL    
	,@isFormView BIT = 0 )       
AS      
BEGIN TRY                      
 SET NOCOUNT ON;         
 UPDATE [dbo].[JOBDL000Master]      
  SET  [JobMITJobID]                    =  CASE WHEN (@isFormView = 1) THEN @jobMITJobID WHEN ((@isFormView = 0) AND (@jobMITJobID=-100)) THEN NULL ELSE ISNULL(@jobMITJobID, JobMITJobID) END      
   ,[ProgramID]                         =  CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID)   END    
   ,[JobSiteCode]                       =  CASE WHEN (@isFormView = 1) THEN @jobSiteCode WHEN ((@isFormView = 0) AND (@jobSiteCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSiteCode, JobSiteCode)   END    
   ,[JobConsigneeCode]                  =  CASE WHEN (@isFormView = 1) THEN @jobConsigneeCode WHEN ((@isFormView = 0) AND (@jobConsigneeCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobConsigneeCode, JobConsigneeCode)   END    
   ,[JobCustomerSalesOrder]             =  CASE WHEN (@isFormView = 1) THEN @jobCustomerSalesOrder WHEN ((@isFormView = 0) AND (@jobCustomerSalesOrder='#M4PL#')) THEN NULL ELSE ISNULL(@jobCustomerSalesOrder, JobCustomerSalesOrder) END      
   ,[JobBOL]	                        =  CASE WHEN (@isFormView = 1) THEN @jobBOL WHEN ((@isFormView = 0) AND (@jobBOL='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOL, JobBOL)   END    
   ,[JobBOLMaster]                      =  CASE WHEN (@isFormView = 1) THEN @jobBOLMaster WHEN ((@isFormView = 0) AND (@jobBOLMaster='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOLMaster, JobBOLMaster)   END    
   ,[JobBOLChild]                       =  CASE WHEN (@isFormView = 1) THEN @jobBOLChild WHEN ((@isFormView = 0) AND (@jobBOLChild='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOLChild, JobBOLChild)   END    
   ,[JobCustomerPurchaseOrder]          =  CASE WHEN (@isFormView = 1) THEN @jobCustomerPurchaseOrder WHEN ((@isFormView = 0) AND (@jobCustomerPurchaseOrder='#M4PL#')) THEN NULL ELSE ISNULL(@jobCustomerPurchaseOrder, JobCustomerPurchaseOrder)   END    
   ,[JobCarrierContract]                =  CASE WHEN (@isFormView = 1) THEN @jobCarrierContract WHEN ((@isFormView = 0) AND (@jobCarrierContract='#M4PL#')) THEN NULL ELSE ISNULL(@jobCarrierContract, JobCarrierContract)   END    
   ,[JobManifestNo]                     =  CASE WHEN (@isFormView = 1) THEN @jobManifestNo WHEN ((@isFormView = 0) AND (@jobManifestNo='#M4PL#')) THEN NULL ELSE ISNULL(@jobManifestNo, JobManifestNo)   END   
   
   ,[JobGatewayStatus]                  =  CASE WHEN (@isFormView = 1) THEN @jobGatewayStatus WHEN ((@isFormView = 0) AND (@jobGatewayStatus='#M4PL#')) THEN NULL ELSE ISNULL(@jobGatewayStatus, JobGatewayStatus)   END     
  
   
   ,[StatusId]                          =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)   END    
   ,[JobStatusedDate]                   =  CASE WHEN (@isFormView = 1) THEN @jobStatusedDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobStatusedDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobStatusedDate, JobStatusedDate)   END    
   ,[JobCompleted]                      =  ISNULL(@jobCompleted, JobCompleted)     
   ,[JobType]                           =  CASE WHEN (@isFormView = 1) THEN @jobType WHEN ((@isFormView = 0) AND (@jobType='#M4PL#')) THEN NULL ELSE ISNULL(@jobType, JobType)   END    
   ,[ShipmentType]                      =  CASE WHEN (@isFormView = 1) THEN @shipmentType WHEN ((@isFormView = 0) AND (@shipmentType='#M4PL#')) THEN NULL ELSE ISNULL(@shipmentType, ShipmentType)   END    
     
   ,[JobDeliveryAnalystContactID]       =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryAnalystContactID WHEN ((@isFormView = 0) AND (@jobDeliveryAnalystContactID=-100)) THEN NULL ELSE ISNULL(@jobDeliveryAnalystContactID, JobDeliveryAnalystContactID)   END    
   ,[JobDeliveryResponsibleContactID]   =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryResponsibleContactID WHEN ((@isFormView = 0) AND (@jobDeliveryResponsibleContactID=-100)) THEN NULL ELSE ISNULL(@jobDeliveryResponsibleContactID, JobDeliveryResponsibleContactID)   END    
   ,[JobDeliverySitePOC]                =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC, JobDeliverySitePOC)   END    
   ,[JobDeliverySitePOCPhone]           =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone, JobDeliverySitePOCPhone)   END    
   ,[JobDeliverySitePOCEmail]           =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail, JobDeliverySitePOCEmail)   END    
   ,[JobDeliverySiteName]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySiteName WHEN ((@isFormView = 0) AND (@jobDeliverySiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySiteName, JobDeliverySiteName)   END    
   ,[JobDeliveryStreetAddress]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress, JobDeliveryStreetAddress) END      
   ,[JobDeliveryStreetAddress2]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress2 WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress2, JobDeliveryStreetAddress2)   END   
 
   ,[JobDeliveryCity]                   =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryCity WHEN ((@isFormView = 0) AND (@jobDeliveryCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCity, JobDeliveryCity)   END    
   ,[JobDeliveryState]                  =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryState WHEN ((@isFormView = 0) AND (@jobDeliveryState='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryState, JobDeliveryState) END      
   ,[JobDeliveryPostalCode]             =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryPostalCode WHEN ((@isFormView = 0) AND (@jobDeliveryPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPostalCode, JobDeliveryPostalCode) END      
   ,[JobDeliveryCountry]              =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryCountry WHEN ((@isFormView = 0) AND (@jobDeliveryCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCountry, JobDeliveryCountry)   END    
   ,[JobDeliveryTimeZone]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryTimeZone WHEN ((@isFormView = 0) AND (@jobDeliveryTimeZone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryTimeZone, JobDeliveryTimeZone)   END    
   ,[JobDeliveryDateTimePlanned]        =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryDateTimePlanned WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimePlanned, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobDeliveryDateTimePlanned, JobDeliveryDateTimePlanned)   END    
       
   ,[JobDeliveryDateTimeActual]         =  CASE WHEN (@isFormView = 1) THEN CASE WHEN ISNULL(@jobCompleted, 0) = 1 AND  @jobDeliveryDateTimeActual IS NULL THEN GETUTCDATE() ELSE @jobDeliveryDateTimeActual END     
            WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimeActual, 103)='01/01/1753')) THEN NULL     
            ELSE ISNULL(@jobDeliveryDateTimeActual, JobDeliveryDateTimeActual)       
             END    
       
       
   ,[JobDeliveryDateTimeBaseline]       =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryDateTimeBaseline WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimeBaseline, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobDeliveryDateTimeBaseline, JobDeliveryDateTimeBaseline)   END    
   ,[JobDeliveryRecipientPhone]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryRecipientPhone WHEN ((@isFormView = 0) AND (@jobDeliveryRecipientPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryRecipientPhone, JobDeliveryRecipientPhone)   END   
 
   ,[JobDeliveryRecipientEmail]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryRecipientEmail WHEN ((@isFormView = 0) AND (@jobDeliveryRecipientEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryRecipientEmail, JobDeliveryRecipientEmail)   END   
 
   ,[JobLatitude]                       =  CASE WHEN (@isFormView = 1) THEN @jobLatitude WHEN ((@isFormView = 0) AND (@jobLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLatitude, JobLatitude)   END    
   ,[JobLongitude]                      =  CASE WHEN (@isFormView = 1) THEN @jobLongitude WHEN ((@isFormView = 0) AND (@jobLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLongitude, JobLongitude)   END    
   ,[JobOriginResponsibleContactID]     =  CASE WHEN (@isFormView = 1) THEN @jobOriginResponsibleContactID WHEN ((@isFormView = 0) AND (@jobOriginResponsibleContactID=-100)) THEN NULL ELSE ISNULL(@jobOriginResponsibleContactID, JobOriginResponsibleContactID)   END    
   ,[JobOriginSitePOC]                  =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOC WHEN ((@isFormView = 0) AND (@jobOriginSitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOC, JobOriginSitePOC)   END    
   ,[JobOriginSitePOCPhone]             =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCPhone WHEN ((@isFormView = 0) AND (@jobOriginSitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCPhone, JobOriginSitePOCPhone) END      
   ,[JobOriginSitePOCEmail]             =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCEmail WHEN ((@isFormView = 0) AND (@jobOriginSitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCEmail, JobOriginSitePOCEmail)   END    
   ,[JobOriginSiteName]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginSiteName WHEN ((@isFormView = 0) AND (@jobOriginSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteName, JobOriginSiteName)   END    
   ,[JobOriginStreetAddress]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress, JobOriginStreetAddress) END      
   ,[JobOriginStreetAddress2]           =  CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress2 WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress2, JobOriginStreetAddress2)   END    
   ,[JobOriginCity]                     =  CASE WHEN (@isFormView = 1) THEN @jobOriginCity WHEN ((@isFormView = 0) AND (@jobOriginCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCity, JobOriginCity)   END    
   ,[JobOriginState]     =  CASE WHEN (@isFormView = 1) THEN @jobOriginState WHEN ((@isFormView = 0) AND (@jobOriginState='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginState, JobOriginState) END      
   ,[JobOriginPostalCode]               =  CASE WHEN (@isFormView = 1) THEN @jobOriginPostalCode WHEN ((@isFormView = 0) AND (@jobOriginPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginPostalCode, JobOriginPostalCode) END      
   ,[JobOriginCountry]                =  CASE WHEN (@isFormView = 1) THEN @jobOriginCountry WHEN ((@isFormView = 0) AND (@jobOriginCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCountry, JobOriginCountry)   END    
   ,[JobOriginTimeZone]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginTimeZone WHEN ((@isFormView = 0) AND (@jobOriginTimeZone='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginTimeZone, JobOriginTimeZone)   END    
   ,[JobOriginDateTimePlanned]          =  CASE WHEN (@isFormView = 1) THEN @jobOriginDateTimePlanned WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimePlanned, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobOriginDateTimePlanned, JobOriginDateTimePlanned)   END    
       
   ,[JobOriginDateTimeActual]           =  CASE WHEN (@isFormView = 1) THEN CASE WHEN ISNULL(@jobCompleted, 0) = 1 AND  @jobOriginDateTimeActual IS NULL THEN GETUTCDATE() ELSE @jobOriginDateTimeActual END      
                                                WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimeActual, 103)='01/01/1753')) THEN NULL     
            ELSE ISNULL(@jobOriginDateTimeActual, JobOriginDateTimeActual)   END    
       
       
   ,[JobOriginDateTimeBaseline]         =  CASE WHEN (@isFormView = 1) THEN @jobOriginDateTimeBaseline WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimeBaseline, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobOriginDateTimeBaseline, JobOriginDateTimeBaseline)   END    
   ,[JobProcessingFlags]                =  CASE WHEN (@isFormView = 1) THEN @jobProcessingFlags WHEN ((@isFormView = 0) AND (@jobProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@jobProcessingFlags, JobProcessingFlags)   END    
   ,[JobDeliverySitePOC2]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC2, JobDeliverySitePOC2)   END    
   ,[JobDeliverySitePOCPhone2]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone2, JobDeliverySitePOCPhone2) END      
   ,[JobDeliverySitePOCEmail2]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail2, JobDeliverySitePOCEmail2)   END    
   ,[JobOriginSitePOC2]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOC2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOC2, JobOriginSitePOC2)   END    
   ,[JobOriginSitePOCPhone2]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCPhone2, JobOriginSitePOCPhone2) END      
   ,[JobOriginSitePOCEmail2]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCEmail2, JobOriginSitePOCEmail2)   END    
   ,[JobSellerCode]                     =  CASE WHEN (@isFormView = 1) THEN @jobSellerCode WHEN ((@isFormView = 0) AND (@jobSellerCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCode, JobSellerCode)   END    
   ,[JobSellerSitePOC]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOC WHEN ((@isFormView = 0) AND (@jobSellerSitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOC, JobSellerSitePOC) END      
   ,[JobSellerSitePOCPhone]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCPhone WHEN ((@isFormView = 0) AND (@jobSellerSitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCPhone, JobSellerSitePOCPhone) END      
   ,[JobSellerSitePOCEmail]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCEmail WHEN ((@isFormView = 0) AND (@jobSellerSitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCEmail, JobSellerSitePOCEmail)   END    
   ,[JobSellerSitePOC2]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOC2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOC2,JobSellerSitePOC2)   END    
   ,[JobSellerSitePOCPhone2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCPhone2, JobSellerSitePOCPhone2) END      
   ,[JobSellerSitePOCEmail2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCEmail2, JobSellerSitePOCEmail2)   END    
   ,[JobSellerSiteName]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSiteName WHEN ((@isFormView = 0) AND (@jobSellerSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSiteName, JobSellerSiteName)   END    
   ,[JobSellerStreetAddress]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerStreetAddress WHEN ((@isFormView = 0) AND (@jobSellerStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerStreetAddress, JobSellerStreetAddress) END      
   ,[JobSellerStreetAddress2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerStreetAddress2 WHEN ((@isFormView = 0) AND (@jobSellerStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerStreetAddress2, JobSellerStreetAddress2)   END    
   ,[JobSellerCity]      =  CASE WHEN (@isFormView = 1) THEN @jobSellerCity WHEN ((@isFormView = 0) AND (@jobSellerCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCity, JobSellerCity)   END    
   ,[JobSellerState]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerState WHEN ((@isFormView = 0) AND (@jobSellerState='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerState, JobSellerState) END      
   ,[JobSellerPostalCode]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerPostalCode WHEN ((@isFormView = 0) AND (@jobSellerPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerPostalCode, JobSellerPostalCode) END      
   ,[JobSellerCountry]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerCountry WHEN ((@isFormView = 0) AND (@jobSellerCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCountry, JobSellerCountry)   END    
   ,[JobUser01]       =  CASE WHEN (@isFormView = 1) THEN @jobUser01 WHEN ((@isFormView = 0) AND (@jobUser01='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser01, JobUser01)   END    
   ,[JobUser02]       =  CASE WHEN (@isFormView = 1) THEN @jobUser02 WHEN ((@isFormView = 0) AND (@jobUser02='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser02, JobUser02)   END    
   ,[JobUser03]       =  CASE WHEN (@isFormView = 1) THEN @jobUser03 WHEN ((@isFormView = 0) AND (@jobUser03='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser03, JobUser03)   END    
   ,[JobUser04]       =  CASE WHEN (@isFormView = 1) THEN @jobUser04 WHEN ((@isFormView = 0) AND (@jobUser04='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser04, JobUser04)   END    
   ,[JobUser05]       =  CASE WHEN (@isFormView = 1) THEN @jobUser05 WHEN ((@isFormView = 0) AND (@jobUser05='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser05, JobUser05)   END    
   ,[JobStatusFlags]     =  ISNULL(@jobStatusFlags, JobStatusFlags)      
   ,[JobScannerFlags]     =  ISNULL(@jobScannerFlags, JobScannerFlags)  
   ,[PlantIDCode]     =  CASE WHEN (@isFormView = 1) THEN @plantIDCode WHEN ((@isFormView = 0) AND (@plantIDCode='#M4PL#')) THEN NULL ELSE ISNULL(@plantIDCode, PlantIDCode)   END    
   ,[CarrierID]       =  CASE WHEN (@isFormView = 1) THEN @carrierID WHEN ((@isFormView = 0) AND (@carrierID='#M4PL#')) THEN NULL ELSE ISNULL(@carrierID, CarrierID)   END    
   ,[JobDriverId]          =  CASE WHEN (@isFormView = 1) THEN @jobDriverId WHEN ((@isFormView = 0) AND (@jobDriverId=-100)) THEN NULL ELSE ISNULL(@jobDriverId, JobDriverId)   END 
   ,[WindowDelStartTime]          =  CASE WHEN (@isFormView = 1) THEN @windowDelStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowDelStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowDelStartTime, WindowDelStartTime)   END 
   ,[WindowDelEndTime]          =  CASE WHEN (@isFormView = 1) THEN @windowDelEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowDelEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowDelEndTime, WindowDelEndTime)   END 
   ,[WindowPckStartTime]           =  CASE WHEN (@isFormView = 1) THEN @windowPckStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowPckStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowPckStartTime, WindowPckStartTime)   END 
   ,[WindowPckEndTime]          =  CASE WHEN (@isFormView = 1) THEN @windowPckEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowPckEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowPckEndTime, WindowPckEndTime)   END 
   ,[JobRouteId]          =  CASE WHEN (@isFormView = 1) THEN @jobRouteId WHEN ((@isFormView = 0) AND (@jobRouteId=-100)) THEN NULL ELSE ISNULL(@jobRouteId, JobRouteId)   END 
   ,[JobStop]           =  CASE WHEN (@isFormView = 1) THEN @jobStop WHEN ((@isFormView = 0) AND (@jobStop='#M4PL#')) THEN NULL ELSE ISNULL(@jobStop, JobStop)   END 
   ,[JobSignText]          =  CASE WHEN (@isFormView = 1) THEN @jobSignText WHEN ((@isFormView = 0) AND (@jobSignText='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignText, JobSignText)   END 
   ,[JobSignLatitude]         =  CASE WHEN (@isFormView = 1) THEN @jobSignLatitude WHEN ((@isFormView = 0) AND (@jobSignLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLatitude, JobSignLatitude)   END 
   ,[JobSignLongitude]     =  CASE WHEN (@isFormView = 1) THEN @jobSignLongitude WHEN ((@isFormView = 0) AND (@jobSignLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLongitude, JobSIgnLongitude)   END 
   ,[ChangedBy]                         =  @changedBy      
   ,[DateChanged]                       =  @dateChanged      
  WHERE   [Id] = @id  ;    
    
    
  --Update Job Gateways    
    
  UPDATE [dbo].[JOBDL020Gateways] Set StatusId  = 195,[GwyCompleted] =1 WHERE JobID = @id And StatusId <> 196;    
   
    EXEC [dbo].[GetJob] @userId,@roleId,0,@id,@programId    ;
     
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
