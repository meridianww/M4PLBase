/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Get a cust DC Location Contact
-- Execution:                 EXEC [dbo].[GetCustDcLocationContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustDcLocationContact]
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
	CdcLocationCode AS ClcContactCode 
	,cont.ConBusinessPhone
	,cont.ConBusinessPhoneExt
	,org.OrgCode AS ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[CUST040DCLocations] cdc
	JOIN [dbo].[CONTC000Master] cont ON cdc.CdcContactMSTRID = cont.Id
	LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id=cont.ConOrgId
	WHERE cdc.Id = @parentId
 END
 ELSE
 BEGIN
 SELECT cust.[Id] AS 'ClcContactMSTRID'
		,cust.[ClcCustDcLocationId]
		,cust.[ClcItemNumber]
		,cust.[ClcContactCode]
		,cust.[ClcContactTitle]
		,cust.[ClcContactMSTRID] AS 'Id'
		,cust.[ClcAssignment]
		,cust.[ClcGateway]
		,cust.[StatusId]
		--,cust.[EnteredBy]
		--,cust.[DateEntered]
		--,cust.[ChangedBy]
		--,cust.[DateChanged]
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
  FROM [dbo].[CUST041DCLocationContacts] cust
  JOIN [dbo].[CUST040DCLocations] cdc ON cust.ClcCustDcLocationId = cdc.Id
  JOIN [dbo].[CUST000Master] cu ON cdc.CdcCustomerID = cu.Id
  JOIN [dbo].[CONTC000Master] cont ON cust.ClcContactMSTRID = cont.Id
  LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id=cont.ConOrgId
	
 WHERE cust.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH