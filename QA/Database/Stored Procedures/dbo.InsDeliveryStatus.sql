SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               06/06/2018      
-- Description:               Ins a DeliveryStatus
-- Execution:                 EXEC [dbo].[InsDeliveryStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[InsDeliveryStatus]		  
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT
	,@delStatusCode NVARCHAR(25) = NULL
	,@delStatusTitle NVARCHAR(50) = NULL 
	,@severityId INT  = NULL
	,@itemNumber INT  = NULL
	,@statusId INT  = NULL
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @itemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT   
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM000Delivery_Status]
           ([OrganizationId]
		   ,[DeliveryStatusCode]
           ,[DeliveryStatusTitle]
           ,[SeverityId]
           ,[ItemNumber]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId
		   ,@delStatusCode
           ,@delStatusTitle
           ,@severityId  
           ,@updatedItemNumber   
           ,@statusId   
           ,@dateEntered  
           ,@enteredBy) 		
		   SET @currentId = SCOPE_IDENTITY();


     -- Get DeliveryStatus Data
	 EXEC [dbo].[GetDeliveryStatus] @userId , @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
