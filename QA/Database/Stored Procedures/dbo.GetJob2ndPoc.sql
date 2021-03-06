SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a Job2ndPoc 
-- Execution:                 EXEC [dbo].[GetJob2ndPoc]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[GetJob2ndPoc]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT, 
	@parentId  BIGINT
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  IF @id = 0 
 BEGIN
      DECLARE @pickupTime TIME,@deliveryTime TIME
		 SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			   ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME)
		 FROM PRGRM000MASTER WHERE Id = @parentId;

		 SELECT @parentId AS ProgramID
		        ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline

 END
 ELSE
 BEGIN
  
  SELECT     job.Id  
            ,job.[StatusId]  
   ,job.[JobDeliverySitePOC2]         
   ,job.[JobDeliverySitePOCPhone2]    
   ,job.[JobDeliverySitePOCEmail2]      
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
   ,job.[DateEntered]  
   ,job.[EnteredBy]  
 FROM [dbo].[JOBDL000Master] job  
 WHERE [Id] = @id  

 END



END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
