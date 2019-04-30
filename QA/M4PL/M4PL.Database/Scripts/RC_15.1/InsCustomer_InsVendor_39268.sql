/****** Object:  StoredProcedure [dbo].[InsCustomer]    Script Date: 11/26/2018 1:47:52 PM ******/
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
-- Modified on:  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsCustomer]
		   (@userId BIGINT
		   ,@roleCode NVARCHAR(25)
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
  DECLARE @where NVARCHAR(MAX) =    ' AND CustOrgId ='  +  CAST(@custOrgId AS VARCHAR)    
  EXEC [dbo].[GetItemNumberAndUpdate] 0,'CUST000Master','CustItemNumber',@custItemNumber,@statusId, @where, @updatedItemNumber OUTPUT 

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
	EXEC [dbo].[GetCustomer] @userId, @roleCode, @custOrgId ,@currentId 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH


GO

/****** Object:  StoredProcedure [dbo].[InsVendor]    Script Date: 11/26/2018 1:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vender
-- Execution:                 EXEC [dbo].[InsVendor]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsVendor]
            @userId BIGINT
		   ,@roleCode NVARCHAR(25)
		   ,@vendERPId NVARCHAR(10) = NULL 
           ,@vendOrgId BIGINT = NULL
           ,@vendItemNumber INT = NULL
           ,@vendCode NVARCHAR(20) = NULL
           ,@vendTitle NVARCHAR(50) = NULL
           ,@vendWorkAddressId BIGINT = NULL
           ,@vendBusinessAddressId BIGINT = NULL
           ,@vendCorporateAddressId BIGINT = NULL
           ,@vendContacts INT = NULL
           ,@vendTypeId INT = NULL
           ,@vendTypeCode NVARCHAR(100) = NULL
           ,@vendWebPage NVARCHAR(100) = NULL
           ,@statusId INT = NULL
           ,@enteredBy NVARCHAR(50) = NULL
           ,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;
    DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) =    ' AND VendOrgId ='  +  CAST(@vendOrgId AS VARCHAR)    
  EXEC [dbo].[GetItemNumberAndUpdate] 0,'VEND000Master','VendItemNumber',@vendItemNumber,@statusId, @where, @updatedItemNumber OUTPUT ;
  
  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @vendTypeCode) AND ISNULL(@vendTypeCode, '') <> '' AND ISNULL(@vendTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(50, 'VendorType', @vendTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateEntered, @enteredBy)
	 SET @vendTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((ISNULL(@vendTypeId,0) > 0) AND (ISNULL(@vendTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@vendTypeCode WHERE Id =@vendTypeId
  END
   
  IF(ISNULL(@vendWorkAddressId, 0) = 0)
  SET @vendWorkAddressId = NULL;
 IF(ISNULL(@vendBusinessAddressId, 0) = 0)
  SET @vendBusinessAddressId = NULL;
 IF(ISNULL(@vendCorporateAddressId, 0) = 0)
  SET @vendCorporateAddressId = NULL; 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND000Master]
           ([VendERPId]
           ,[VendOrgId]
           ,[VendItemNumber]
           ,[VendCode]
           ,[VendTitle]
           ,[VendWorkAddressId]
           ,[VendBusinessAddressId]
           ,[VendCorporateAddressId]
           ,[VendContacts]
           ,[VendTypeId]
           ,[VendWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vendERPId  
           ,@vendOrgId  
           ,@updatedItemNumber   
           ,@vendCode  
           ,@vendTitle 
           ,@vendWorkAddressId  
           ,@vendBusinessAddressId  
           ,@vendCorporateAddressId 
           ,@vendContacts 
           ,@vendTypeId   
           ,@vendWebPage   
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendor] @userId, @roleCode, @vendOrgId ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
