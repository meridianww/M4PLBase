SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               06/06/2018      
-- Description:               Upd a DeliveryStatus
-- Execution:                 EXEC [dbo].[UpdDeliveryStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdDeliveryStatus]		  
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT
	,@delStatusCode NVARCHAR(25) = NULL
	,@delStatusTitle NVARCHAR(50) = NULL 
	,@severityId INT = NULL 
	,@itemNumber INT  = NULL
	,@statusId INT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = null

  DECLARE @isSysAdmin BIT
  SELECT @isSysAdmin = IsSysAdmin FROM SYSTM000OpnSezMe WHERE id=@userId;
  IF @isSysAdmin = 1 
  BEGIN
    EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @itemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT   
  END  

   UPDATE   [dbo].[SYSTM000Delivery_Status]
    SET     DeliveryStatusCode 		=  CASE WHEN (@isFormView = 1) THEN @delStatusCode WHEN ((@isFormView = 0) AND (@delStatusCode='#M4PL#')) THEN NULL ELSE ISNULL(@delStatusCode, DeliveryStatusCode) END
           ,DeliveryStatusTitle 		=  CASE WHEN (@isFormView = 1) THEN @delStatusTitle WHEN ((@isFormView = 0) AND (@delStatusTitle='#M4PL#')) THEN NULL ELSE ISNULL(@delStatusTitle, DeliveryStatusTitle) END
           ,SeverityId 		=  CASE WHEN (@isFormView = 1) THEN @severityId WHEN ((@isFormView = 0) AND (@severityId=-100)) THEN NULL ELSE ISNULL(@severityId, SeverityId) END	
           ,ItemNumber 	=  CASE WHEN @isSysAdmin = 1 THEN  
		                                                  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber 
														       WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL 
															   ELSE ISNULL(@updatedItemNumber, ItemNumber) END 
		                            ELSE ItemNumber  END
           ,StatusId 		=  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,OrganizationId 	=  CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrganizationId) END
           ,DateChanged 	=  @dateChanged  
           ,ChangedBy		=  @changedBy 
   WHERE	Id   =  @id
	 EXEC [dbo].[GetDeliveryStatus] @userId , @roleId, @orgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
