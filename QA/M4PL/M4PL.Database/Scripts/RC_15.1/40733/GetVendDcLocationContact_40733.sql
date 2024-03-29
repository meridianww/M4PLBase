
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
	,org.OrgCode as ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[VEND040DCLocations]  vdc
	JOIN [dbo].[CONTC000Master] cont ON vdc.VdcContactMSTRID = cont.Id
	LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id=cont.ConOrgId

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
		,org.OrgCode as ConCompany
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
  LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id=cont.ConOrgId
 WHERE vend.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH