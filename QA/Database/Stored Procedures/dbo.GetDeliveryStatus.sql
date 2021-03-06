SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               06/16/2018      
-- Description:               Get a DeliveryStatus
-- Execution:                 EXEC [dbo].[GetDeliveryStatus]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetDeliveryStatus] 
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 SELECT  delStatus.[Id]
	    ,delStatus.[OrganizationId]
        ,delStatus.[DeliveryStatusCode]
        ,delStatus.[DeliveryStatusTitle]
        ,delStatus.[SeverityId]
		,delStatus.[ItemNumber]
        ,delStatus.[StatusId]
        ,delStatus.[DateEntered]
        ,delStatus.[EnteredBy]
        ,delStatus.[DateChanged]
        ,delStatus.[ChangedBy]
   FROM [dbo].[SYSTM000Delivery_Status] delStatus
  WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
