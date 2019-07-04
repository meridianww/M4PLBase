SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a customer 
-- Execution:                 EXEC [dbo].[InsCustomer]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsCustomer]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@custERPId NVARCHAR(10) = NULL
	,@custOrgId BIGINT = NULL
	,@custItemNumber INT = NULL
	,@custCode NVARCHAR(20) = NULL
	,@custTitle NVARCHAR(50) = NULL
	,@custWorkAddressId BIGINT = NULL
	,@custBusinessAddressId BIGINT = NULL
	,@custCorporateAddressId BIGINT = NULL
	,@custContacts INT = NULL
	,@custTypeId INT = NULL
	,@custTypeCode NVARCHAR(100) = NULL
	,@custWebPage NVARCHAR(100) = NULL
	,@statusId INT = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @custOrgId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @custTypeCode) AND ISNULL(@custTypeCode, '') <> '' AND ISNULL(@custTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(8, 'CustomerType', @custTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateEntered, @enteredBy)
	 SET @custTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((ISNULL(@custTypeId,0) > 0) AND (ISNULL(@custTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@custTypeCode WHERE Id =@custTypeId
  END
 
 IF(ISNULL(@custWorkAddressId, 0) = 0)
  SET @custWorkAddressId = NULL;
 IF(ISNULL(@custBusinessAddressId, 0) = 0)
  SET @custBusinessAddressId = NULL;
 IF(ISNULL(@custCorporateAddressId, 0) = 0)
  SET @custCorporateAddressId = NULL;

 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[CUST000Master]
           ([CustERPId]
           ,[CustOrgId]
           ,[CustItemNumber]
           ,[CustCode]
           ,[CustTitle]
           ,[CustWorkAddressId]
           ,[CustBusinessAddressId]
           ,[CustCorporateAddressId]
           ,[CustContacts]
           ,[CustTypeId]
           ,[CustWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@custERPId
           ,@custOrgId 
           ,@updatedItemNumber -- @custItemNumber 
           ,@custCode  
           ,@custTitle 
           ,@custWorkAddressId  
           ,@custBusinessAddressId  
           ,@custCorporateAddressId  
           ,@custContacts  
           ,@custTypeId  
           ,@custWebPage  
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered) 
		   SET @currentId = SCOPE_IDENTITY();
		   
	EXEC [dbo].[GetCustomer] @userId, @roleId, @custOrgId ,@currentId 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
