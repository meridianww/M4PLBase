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
CREATE PROCEDURE  [dbo].[UpdCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conOrgId BIGINT
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
       SET   CdcCustomerId	  =  ISNULL(@cdcCustomerId, CdcCustomerId) 
            ,CdcItemNumber	  =  ISNULL(@updatedItemNumber, CdcItemNumber) 
            ,CdcLocationCode  =  ISNULL(@cdcLocationCode, CdcLocationCode)  
			,CdcCustomerCode  =  ISNULL(@cdcCustomerCode,CdcCustomerCode)  
            ,CdcLocationTitle =  ISNULL(@cdcLocationTitle, CdcLocationTitle)   
            ,StatusId		  =  ISNULL(@statusId, StatusId) 
            ,ChangedBy		  =  ISNULL(@changedBy,ChangedBy)
            ,DateChanged	  =  ISNULL(@dateChanged, DateChanged)
	  WHERE  Id = @id 
	      
	If NOT EXISTS (Select 1 from [CONTC010Bridge]  where ConPrimaryRecordId = @id AND ContactMSTRID =  @cdcContactMSTRId  And  ConTableName = 'CustDcLocation' And ConOrgId = @conOrgId)	  
	Begin
	 UPDATE [CONTC010Bridge] set [ContactMSTRID] = @cdcContactMSTRId where  ConPrimaryRecordId = @id   And  ConTableName = 'CustDcLocation' And ConOrgId = @conOrgId

	END
		         


	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
