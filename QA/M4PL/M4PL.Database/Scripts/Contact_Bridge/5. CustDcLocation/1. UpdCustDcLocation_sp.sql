SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust DCLocations
-- Execution:                 EXEC [dbo].[UpdCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cdcCustomerId BIGINT = NULL
	,@cdcItemNumber INT  = NULL
	,@cdcLocationCode NVARCHAR(20)  = NULL
	,@cdcCustomerCode NVARCHAR(20) =NULL
	,@cdcLocationTitle NVARCHAR(50)  = NULL
	,@cdcContactMSTRId BIGINT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

    UPDATE  [dbo].[CUST040DCLocations]
       SET   CdcCustomerId	  = CASE WHEN (@isFormView = 1) THEN @cdcCustomerId WHEN ((@isFormView = 0) AND (@cdcCustomerId=-100)) THEN NULL ELSE ISNULL(@cdcCustomerId, CdcCustomerId) END
            ,CdcItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CdcItemNumber) END
            ,CdcLocationCode  = CASE WHEN (@isFormView = 1) THEN @cdcLocationCode WHEN ((@isFormView = 0) AND (@cdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationCode, CdcLocationCode) END 
			,CdcCustomerCode  = CASE WHEN (@isFormView = 1) THEN ISNULL(@cdcCustomerCode,@cdcLocationCode) WHEN ((@isFormView = 0) AND (@cdcCustomerCode='#M4PL#')) THEN @cdcLocationCode ELSE ISNULL(@cdcCustomerCode,CdcCustomerCode)  END
            ,CdcLocationTitle = CASE WHEN (@isFormView = 1) THEN @cdcLocationTitle WHEN ((@isFormView = 0) AND (@cdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationTitle, CdcLocationTitle) END  
            ,CdcContactMSTRId = CASE WHEN (@isFormView = 1) THEN @cdcContactMSTRId WHEN ((@isFormView = 0) AND (@cdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@cdcContactMSTRId, CdcContactMSTRId) END
            ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,ChangedBy		  = @changedBy   
            ,DateChanged	  = @dateChanged 
	  WHERE  Id = @id 
	              
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
