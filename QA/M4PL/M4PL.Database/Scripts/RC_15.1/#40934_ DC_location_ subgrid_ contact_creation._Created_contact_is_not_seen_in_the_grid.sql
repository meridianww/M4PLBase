USE [M4PL_Dev]
GO
/****** Object:  StoredProcedure [dbo].[GetVendDcLocationContact]    Script Date: 2/14/2019 12:41:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Get a Vend DCLocation Contact
-- Execution:                 EXEC [dbo].[GetVendDcLocationContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetVendDcLocationContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT,
	@parentId BIGINT = null
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 IF(@id = 0 AND (@parentId IS NOT NULL))
 BEGIN
	SELECT 
	VdcLocationCode AS VlcContactCode 
	,cont.ConBusinessPhone
	,cont.ConBusinessPhoneExt
	,org.OrgTitle as ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[VEND040DCLocations]  vdc
	JOIN [dbo].[CONTC000Master] cont ON vdc.VdcContactMSTRID = cont.Id
	INNER JOIN [dbo].[ORGAN000Master] org On org.Id = cont.ConOrgId
	WHERE vdc.Id = @parentId
 END
 ELSE
 BEGIN
 SELECT vend.[Id] AS 'VlcContactMSTRID'
		,vend.[VlcVendDcLocationId]
		,vend.[VlcItemNumber]
		,vend.[VlcContactCode]
		,vend.[VlcContactTitle]
		,vend.[VlcContactMSTRID] AS 'Id'
		,vend.[VlcAssignment]
		,vend.[VlcGateway]
		,vend.[StatusId]
		--,vend.[EnteredBy]
		--,vend.[DateEntered]
		--,vend.[ChangedBy]
		--,vend.[DateChanged]
		,ve.Id AS ParentId
		
		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,cont.ConJobTitle
		,org.OrgTitle as ConCompany
		,cont.ConTypeId
		,cont.ConUDF01
		,cont.ConBusinessPhone
		,cont.ConBusinessPhoneExt
		,cont.ConMobilePhone
		,cont.ConEmailAddress
		,cont.ConEmailAddress2
		,cont.ConBusinessAddress1
		,cont.ConBusinessAddress2
		,cont.ConBusinessCity
		,cont.ConBusinessStateId
		,cont.ConBusinessZipPostal
		,cont.ConBusinessCountryId
		,cont.[EnteredBy]
		,cont.[DateEntered]
		,cont.[ChangedBy]
		,cont.[DateChanged]
  FROM [dbo].[VEND041DCLocationContacts] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.VlcVendDcLocationId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
  JOIN [dbo].[CONTC000Master] cont ON vend.VlcContactMSTRID = cont.Id
  INNER JOIN [dbo].[ORGAN000Master] org On org.Id = cont.ConOrgId
 WHERE vend.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[InsVendDcLocationContact]    Script Date: 2/14/2019 1:11:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018     
-- Description:               Ins a vend dc location Contact
-- Execution:                 EXEC [dbo].[InsVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId   and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsVendDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vlcVendDcLocationId BIGINT  = NULL
	,@vlcItemNumber INT = NULL
	,@vlcContactCode NVARCHAR(20)  = NULL
	,@vlcContactTitle NVARCHAR(50)  = NULL
	,@vlcContactMSTRID BIGINT = NULL
	,@vlcAssignment NVARCHAR(20)  = NULL
	,@vlcGateway NVARCHAR(20)  = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7) 	 = NULL	  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vlcVendDcLocationId, @entity, @vlcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;

 -- First insert into ContactMaster table
 INSERT INTO [dbo].[CONTC000Master]
        ([ConOrgId]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConMobilePhone]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
		,[ConUDF01]
        ,[StatusId]
        ,[ConTypeId]
        ,[DateEntered]
        ,[EnteredBy] )
     VALUES
		(@conOrgId
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conMobilePhone
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conUDF01
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();

   -- Then Insert into VendDcLocationContact
   INSERT INTO [dbo].[VEND041DCLocationContacts]
           ([VlcVendDcLocationId]
		   	,[VlcItemNumber]
		   	,[VlcContactCode]
		   	,[VlcContactTitle]
		   	,[VlcContactMSTRID]
		   	,[VlcAssignment]
		   	,[VlcGateway]
		   	,[StatusId]
		   	,[EnteredBy]
		   	,[DateEntered])
     VALUES
		   (@vlcVendDcLocationId 
           ,@updatedItemNumber  
           ,@vlcContactCode   
		   ,@vlcContactTitle
           ,@currentId   
           ,@vlcAssignment  
           ,@vlcGateway  
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

