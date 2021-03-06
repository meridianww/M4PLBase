SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrder
-- Execution:                 EXEC [dbo].[GetScnOrder]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetScnOrder]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[JobID]
		,scn.[ProgramID]
		,scn.[RouteID]
		,scn.[DriverID]
		,scn.[JobDeviceID]
		,scn.[JobStop]
		,scn.[JobOrderID]
		,scn.[JobManifestID]
		,scn.[JobCarrierID]
		,scn.[JobReturnReasonID]
		,scn.[JobStatusCD]
		,scn.[JobOriginSiteCode]
		,scn.[JobOriginSiteName]
		,scn.[JobDeliverySitePOC]
		,scn.[JobDeliverySitePOC2]
		,scn.[JobDeliveryStreetAddress]
		,scn.[JobDeliveryStreetAddress2]
		,scn.[JobDeliveryCity]
		,scn.[JobDeliveryStateProvince]
		,scn.[JobDeliveryPostalCode]
		,scn.[JobDeliveryCountry]
		,scn.[JobDeliverySitePOCPhone]
		,scn.[JobDeliverySitePOCPhone2]
		,scn.[JobDeliveryPhoneHm]
		,scn.[JobDeliverySitePOCEmail]
		,scn.[JobDeliverySitePOCEmail2]
		,scn.[JobOriginStreetAddress]
		,scn.[JobOriginCity]
		,scn.[JobOriginStateProvince]
		,scn.[JobOriginPostalCode]
		,scn.[JobOriginCountry]
		,scn.[JobLongitude]
		,scn.[JobLatitude]
		,scn.[JobSignLongitude]
		,scn.[JobSignLatitude]
		,scn.[JobSignText]
		,scn.[JobSignCapture]
		,scn.[JobScheduledDate]
		,scn.[JobScheduledTime]
		,scn.[JobEstimatedDate]
		,scn.[JobEstimatedTime]
		,scn.[JobActualDate]
		,scn.[JobActualTime]
		,scn.[ColorCD]
		,scn.[JobFor]
		,scn.[JobFrom]
		,scn.[WindowStartTime]
		,scn.[WindowEndTime]
		,scn.[JobFlag01]
		,scn.[JobFlag02]
		,scn.[JobFlag03]
		,scn.[JobFlag04]
		,scn.[JobFlag05]
		,scn.[JobFlag06]
		,scn.[JobFlag07]
		,scn.[JobFlag08]
		,scn.[JobFlag09]
		,scn.[JobFlag10]
		,scn.[JobFlag11]
		,scn.[JobFlag12]
		,scn.[JobFlag13]
		,scn.[JobFlag14]
		,scn.[JobFlag15]
		,scn.[JobFlag16]
		,scn.[JobFlag17]
		,scn.[JobFlag18]
		,scn.[JobFlag19]
		,scn.[JobFlag20]
		,scn.[JobFlag21]
		,scn.[JobFlag22]
		,scn.[JobFlag23]
  FROM [dbo].[SCN000Order] scn
 WHERE scn.[JobID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
