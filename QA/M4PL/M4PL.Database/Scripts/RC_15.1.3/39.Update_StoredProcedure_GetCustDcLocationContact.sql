SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Get a cust DC Location Contact
-- Execution:                 EXEC [dbo].[GetCustDcLocationContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustDcLocationContact]-- 1,14,1,0,8
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
	CdcLocationCode AS ConCode 
	,cont.ConBusinessPhone
	,cont.ConBusinessPhoneExt
	,org.OrgCode AS ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	,COMP.Id ConCompanyId
	FROM [dbo].[CUST040DCLocations] cdc WITH(NOLOCK)
	JOIN [dbo].[CONTC000Master] cont WITH(NOLOCK) ON cdc.CdcContactMSTRID = cont.Id
	INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = cdc.CdcCustomerID AND COMP.CompTableName = 'Customer'
	LEFT JOIN [dbo].[ORGAN000Master] org WITH(NOLOCK) ON org.Id=cont.ConOrgId
	WHERE cdc.Id = @parentId
 END
 ELSE
 BEGIN
 SELECT cust.[Id] AS 'ContactMSTRID'
		,cust.[ConPrimaryRecordId]
		,cust.[ConItemNumber]
		,cust.[ConCodeId]
		,cust.[ConTitle]
		,cust.[ContactMSTRID] AS 'Id'
		,cust.[StatusId]
		,cu.Id AS ParentId 		
		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,cont.ConJobTitle
		,org.OrgCode AS ConCompany
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
		,COMP.Id ConCompanyId
  FROM [dbo].[CONTC010Bridge] cust WITH(NOLOCK)
  JOIN [dbo].[CUST040DCLocations] cdc WITH(NOLOCK) ON cust.ConPrimaryRecordId = cdc.Id
  JOIN [dbo].[CUST000Master] cu WITH(NOLOCK) ON cdc.CdcCustomerID = cu.Id
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = cu.Id AND COMP.CompTableName = 'Customer'
  JOIN [dbo].[CONTC000Master] cont WITH(NOLOCK) ON cust.ContactMSTRID = cont.Id
  LEFT JOIN [dbo].[ORGAN000Master] org WITH(NOLOCK) ON org.Id=cont.ConOrgId
 WHERE cust.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH