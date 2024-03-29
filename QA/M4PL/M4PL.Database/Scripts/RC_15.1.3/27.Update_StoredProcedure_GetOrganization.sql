/****** Object:  StoredProcedure [dbo].[GetOrganization]    Script Date: 7/12/2019 4:21:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a Organization
-- Execution:                 EXEC [dbo].[GetOrganization]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetOrganization] 
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @BusinessAddressType INT
		,@CorporateAddressType INT
		,@WorkAddressType INT

	SELECT @BusinessAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Business'

	SELECT @CorporateAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Corporate'

	SELECT @WorkAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Work'
 SELECT  org.[Id]
        ,org.[OrgCode]
        ,org.[OrgTitle]
        ,org.[OrgGroupId]
		,CASE WHEN EXISTS(SELECT Id FROM SYSTM000OpnSezMe WHERE id=@userId and IsSysAdmin =1) THEN  org.[OrgSortOrder] ELSE 1 END AS OrgSortOrder
		--,org.[OrgSortOrder]
        ,org.[StatusId]
        ,org.[DateEntered]
        ,org.[EnteredBy]
        ,org.[DateChanged]
        ,org.[ChangedBy]
        ,org.[OrgContactId]
        ,org.[OrgImage]
		,org.[OrgWorkAddressId]
		,org.[OrgBusinessAddressId]
		,org.[OrgCorporateAddressId]
		,CC.Address1 CorporateAddress1
		,CC.Address2 CorporateAddress2
		,CC.City CorporateCity
		,CC.ZipPostal CorporateZipPostal
		,CC.StateId CorporateStateId
		,CC.CountryId CorporateCountryId
		,CB.Address1 BusinessAddress1
		,CB.Address2 BusinessAddress2
		,CB.City BusinessCity
		,CB.ZipPostal BusinessZipPostal
		,CB.StateId BusinessStateId
		,CB.CountryId BusinessCountryId
		,CW.Address1 WorkAddress1
		,CW.Address2 WorkAddress2
		,CW.City WorkCity
		,CW.ZipPostal WorkZipPostal
		,CW.StateId WorkStateId
		,CW.CountryId WorkCountryId
		,SB.[StateAbbr] BusinessStateIdName
		,SC.[StateAbbr] CorporateStateIdName
		,SW.[StateAbbr] WorkStateIdName
		,ConB.[SysOptionName] BusinessCountryIdName
		,ConC.[SysOptionName] CorporateCountryIdName
		,ConW.[SysOptionName] WorkCountryIdName
		,COMP.Id CompanyId
   FROM [dbo].[ORGAN000Master] org
   INNER JOIN [dbo].[COMP000Master] COMP ON COMP.CompPrimaryRecordId = org.Id AND CompTableName = 'Organization'
	LEFT JOIN [dbo].[COMPADD000Master] CC ON CC.AddCompId = COMP.Id
		AND CC.AddTypeId = @CorporateAddressType 
	LEFT JOIN [dbo].[COMPADD000Master] CB ON CB.AddCompId = COMP.Id
		AND CB.AddTypeId = @BusinessAddressType 
	LEFT JOIN [dbo].[COMPADD000Master] CW ON CW.AddCompId = COMP.Id
		AND CW.AddTypeId = @WorkAddressType
	LEFT JOIN [dbo].[SYSTM000Ref_States] SC ON SC.Id = CC.StateId
	LEFT JOIN [dbo].[SYSTM000Ref_States] SB ON SB.Id = CB.StateId
	LEFT JOIN [dbo].[SYSTM000Ref_States] SW ON SW.Id = CW.StateId
	LEFT JOIN [dbo].[SYSTM000Ref_Options] ConC ON ConC.Id = CC.CountryId
	LEFT JOIN [dbo].[SYSTM000Ref_Options] ConB ON ConB.Id = CB.CountryId
	LEFT JOIN [dbo].[SYSTM000Ref_Options] ConW ON ConW.Id = CW.CountryId
  WHERE org.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH