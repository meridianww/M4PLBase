SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               05/25/2018          
-- Description:               Get all referenced modules  by id    
-- Execution:                 EXEC [dbo].[GetDeleteInfoRecordsContact] 1,14,1,'CustDcLocation','contact','10213'   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)        
-- Modified Desc:      
-- =============================================     
CREATE PROCEDURE [dbo].[GetDeleteInfoRecordsContact]
	 @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@parentEntity NVARCHAR(100)
	,@contains NVARCHAR(MAX)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @tableName NVARCHAR(100)
	Select CAST(Item AS BIGINT) ContactId INTO #ContactId  From [dbo].[fnSplitString](@contains, ',')
	SELECT @tableName = TblTableName
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	DECLARE @ReferenceTable TABLE (
		PrimaryId INT IDENTITY(1, 1)
		,ReferenceEntity NVARCHAR(50)
		,ParentEntity NVARCHAR(50)
		,ReferenceTableName NVARCHAR(100)
		,ReferenceColumnName NVARCHAR(100)
		);

	INSERT INTO @ReferenceTable (
		referenceEntity
		,parentEntity
		,referenceTableName
		,ReferenceColumnName
		)
	SELECT (
			SELECT TOP 1 SysRefName
			FROM [dbo].[SYSTM000Ref_Table]
			WHERE TblTableName = SO.name
			) AS [Entity]
		,@tableName
		,SO.name AS TableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = FK.name
			) AS ColumnName
	FROM sys.foreign_keys FK
	INNER JOIN sys.sysobjects SO ON FK.parent_object_id = SO.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	WHERE refTable.SysRefName = @parentEntity
		AND SO.name = @tableName;

	DECLARE @query NVARCHAR(MAX)

	SELECT @query = COALESCE(@query + ' OR ', '') + ReferenceColumnName + ' in (' + CAST(@contains AS  NVARCHAR(max)) + ')'
	FROM @ReferenceTable
	ORDER BY ReferenceEntity

	IF (@entity = 'Program')
	BEGIN
		SET @query = 'SELECT 
			 [Id]      
			,[PrgOrgID]      
			,[PrgCustID]      
			,[PrgItemNumber]      
			,[PrgProgramCode]      
			,[PrgProjectCode]      
			,[PrgPhaseCode]      
			,[PrgProgramTitle]      
			,[PrgAccountCode] 
			,[DelEarliest] 
			,[DelLatest] 
			,CASE WHEN [DelEarliest] IS NULL AND [DelLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [DelDay] END AS DelDay
			,[PckEarliest] 
			,[PckLatest]
			,CASE WHEN [PckEarliest] IS NULL AND [PckLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [PckDay] END AS PckDay
			,[StatusId]      
			,[PrgDateStart]      
			,[PrgDateEnd]      
			,[PrgDeliveryTimeDefault]      
			,[PrgPickUpTimeDefault]      
			,[PrgHierarchyID].ToString() As PrgHierarchyID       
			,[PrgHierarchyLevel]      
			,[DateEntered]      
			,[EnteredBy]      
			,[DateChanged]      
			,[ChangedBy]  FROM  ' + @tableName + '    WHERE StatusId in(1,2) AND (' + @query + ')';

		EXEC sp_executesql @query
	END
	ELSE IF (ISNULL(@entity, '') = 'CustDcLocation')
	BEGIN
		SELECT 

		     CB.ContactMSTRID as CdcContactMSTRID
			,CustDcLocation.CdcCustomerCode
			,CustDcLocation.CdcItemNumber
			,CustDcLocation.CdcLocationCode
			,CustDcLocation.CdcLocationTitle
			,CustDcLocation.Id
			,CustDcLocation.StatusId
			,cust.[CustCode] AS CdcCustomerIDName
			,cont.[ConFullName] AS CdcContactMSTRIDName
			,cont.[ConJobTitle] AS ConJobTitle
			,cont.[ConEmailAddress] AS ConEmailAddress
			,cont.[ConMobilePhone] AS ConMobilePhone
			,cont.[ConBusinessPhone] AS ConBusinessPhone
			,cont.[ConBusinessAddress1] AS ConBusinessAddress1
			,cont.[ConBusinessAddress2] AS ConBusinessAddress2
			,cont.[ConBusinessCity] AS ConBusinessCity
			,cont.[ConBusinessZipPostal] AS ConBusinessZipPostal
			,sts.[StateAbbr] AS ConBusinessStateIdName
			,sysRef.[SysOptionName] AS ConBusinessCountryIdName
			,(
				coalesce(cont.[ConBusinessAddress1], '') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '') + coalesce(CHAR(13) + cont.[ConBusinessCity], '') + CASE 
					WHEN (
							(coalesce(cont.[ConBusinessAddress1], '') <> '')
							OR (coalesce(cont.[ConBusinessAddress2], '') <> '')
							OR (coalesce(cont.[ConBusinessCity], '') <> '')
							)
						THEN coalesce(', ' + sts.[StateAbbr], '')
					ELSE coalesce('' + sts.[StateAbbr], '')
					END + coalesce(', ' + cont.[ConBusinessZipPostal], '') + coalesce(CHAR(13) + sysRef.[SysOptionName], '')
				) AS ConBusinessFullAddress
		FROM [dbo].[CUST040DCLocations](NOLOCK) CustDcLocation
		LEFT JOIN [dbo].[CONTC010Bridge](NOLOCK) CB ON CB.ConPrimaryRecordId = CustDcLocation.Id 
		LEFT JOIN [dbo].[CUST000Master](NOLOCK) cust ON CustDcLocation.[CdcCustomerID] = cust.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON CB.[ContactMSTRID] = cont.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_States](NOLOCK) sts ON cont.[ConBusinessStateId] = sts.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_Options](NOLOCK) sysRef ON cont.[ConBusinessCountryId] = sysRef.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(CustDcLocation.[StatusId], 1) = hfk.[StatusId]
		WHERE 1 = 1 AND CB.ConTableName='CustDcLocation' AND  CustDcLocation.StatusId in(1,2)
			AND cont.Id IN (Select ContactId From #ContactId)
		ORDER BY CustDcLocation.CdcItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'CustContact')
	BEGIN
		SELECT CustContact.ConCodeId
			,CustContact.ConItemNumber
			,CustContact.ConPrimaryRecordId
			,CustContact.ContactMSTRID
			,CustContact.ConTitle
			,CustContact.Id
			,CustContact.StatusId
			,cust.[CustCode] AS ConPrimaryRecordIdName
			,cont.[ConFullName] AS ContactMSTRIDName
			,rol.OrgRoleCode AS ConCodeIdName
			,cont.[ConJobTitle] AS ConJobTitle
			,cont.[ConEmailAddress] AS ConEmailAddress
			,cont.[ConMobilePhone] AS ConMobilePhone
			,cont.[ConBusinessPhone] AS ConBusinessPhone
			,cont.[ConBusinessAddress1] AS ConBusinessAddress1
			,cont.[ConBusinessAddress2] AS ConBusinessAddress2
			,cont.[ConBusinessCity] AS ConBusinessCity
			,cont.[ConBusinessZipPostal] AS ConBusinessZipPostal
			,sts.[StateAbbr] AS ConBusinessStateIdName
			,sysRef.[SysOptionName] AS ConBusinessCountryIdName
			,(
				coalesce(cont.[ConBusinessAddress1], '') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '') + coalesce(CHAR(13) + cont.[ConBusinessCity], '') + CASE 
					WHEN (
							(coalesce(cont.[ConBusinessAddress1], '') <> '')
							OR (coalesce(cont.[ConBusinessAddress2], '') <> '')
							OR (coalesce(cont.[ConBusinessCity], '') <> '')
							)
						THEN coalesce(', ' + sts.[StateAbbr], '')
					ELSE coalesce('' + sts.[StateAbbr], '')
					END + coalesce(', ' + cont.[ConBusinessZipPostal], '') + coalesce(CHAR(13) + sysRef.[SysOptionName], '')
				) AS ConBusinessFullAddress
		FROM [dbo].[CONTC010Bridge](NOLOCK) CustContact
		LEFT JOIN [dbo].[CUST000Master](NOLOCK) cust ON CustContact.[ConPrimaryRecordId] = cust.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON CustContact.[ContactMSTRID] = cont.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_States](NOLOCK) sts ON cont.[ConBusinessStateId] = sts.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_Options](NOLOCK) sysRef ON cont.[ConBusinessCountryId] = sysRef.[Id]
		INNER JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) rol ON CustContact.[ConCodeId] = rol.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(CustContact.[StatusId], 1) = fgus.[StatusId]
		WHERE 1 = 1 AND CustContact.StatusId in(1,2)
			AND cont.Id IN (Select ContactId From #ContactId)
			AND CustContact.[ConTableName] = @entity
		ORDER BY CustContact.ConItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'CustDCLocationContact')
	BEGIN
		SELECT CustDcLocationContact.ConCodeId
			,CustDcLocationContact.ConItemNumber
			,CustDcLocationContact.ContactMSTRID
			,CustDcLocationContact.ConTitle
			,CustDcLocationContact.Id
			,CustDcLocationContact.StatusId
			,org.OrgCode AS ConOrgIdName
			,CustDcLocationContact.[ConTitleId] AS ConTitleId
			,CustDcLocationContact.[ConFullName] AS ContactMSTRIDName
			,CustDcLocationContact.ConBusinessPhone AS ConBusinessPhone
			,CustDcLocationContact.ConBusinessPhoneExt AS ConBusinessPhoneExt
			,CustDcLocationContact.ConMobilePhone AS ConMobilePhone
			,refOp.OrgRoleCode AS ConCodeIdName
		FROM [dbo].[vwDCLocationContactMapping](NOLOCK) CustDcLocationContact
		LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id = CustDcLocationContact.ConOrgId
		LEFT JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) refOp ON CustDcLocationContact.[ConCodeId] = refOp.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(CustDcLocationContact.[StatusId], 1) = hfk.[StatusId]
		WHERE CustDcLocationContact.ContactMSTRID IN (Select ContactId From #ContactId) AND CustDcLocationContact.StatusId in(1,2)
			AND CustDcLocationContact.[ConTableName] = @entity
		ORDER BY CustDcLocationContact.ConItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'Customer')
	BEGIN
		SELECT Customer.CustBusinessAddressId
			,Customer.CustCode
			,Customer.CustContacts
			,Customer.CustCorporateAddressId
			,Customer.CustERPID
			,Customer.CustItemNumber
			,Customer.CustOrgId
			,Customer.CustTitle
			,Customer.CustTypeId
			,Customer.CustWebPage
			,Customer.CustWorkAddressId
			,Customer.Id
			,Customer.StatusId
			,org.[OrgCode] AS CustOrgIdName
			,contWA.[ConFullName] AS CustWorkAddressIdName
			,contBA.[ConFullName] AS CustBusinessAddressIdName
			,contCA.[ConFullName] AS CustCorporateAddressIdName
			,COMP.Id CompanyId
		FROM [dbo].[CUST000Master](NOLOCK) Customer
		INNER JOIN dbo.COMP000Master(NOLOCK) COMP ON Customer.[ID] = COMP.[CompPrimaryRecordId]
			AND COMP.CompTableName = 'Customer'
		INNER JOIN [dbo].[ORGAN000Master](NOLOCK) org ON Customer.[CustOrgId] = org.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contWA ON Customer.[CustWorkAddressId] = contWA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contBA ON Customer.[CustBusinessAddressId] = contBA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contCA ON Customer.[CustCorporateAddressId] = contCA.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON Customer.[StatusId] = hfk.[StatusId]
		WHERE Customer.[CustOrgId] = 1 AND Customer.StatusId in(1,2)
				AND (
				Customer.CustBusinessAddressId IN (Select ContactId From #ContactId)
				OR Customer.CustCorporateAddressId IN (Select ContactId From #ContactId)
				OR Customer.CustWorkAddressId IN (Select ContactId From #ContactId)
				)
		ORDER BY Customer.CustItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'Vendor')
	BEGIN
		SELECT Vendor.Id
			,Vendor.StatusId
			,Vendor.VendBusinessAddressId
			,Vendor.VendCode
			,Vendor.VendContacts
			,Vendor.VendCorporateAddressId
			,Vendor.VendERPID
			,Vendor.VendItemNumber
			,Vendor.VendOrgID
			,Vendor.VendTitle
			,Vendor.VendTypeId
			,Vendor.VendWebPage
			,Vendor.VendWorkAddressId
			,org.[OrgCode] AS VendOrgIDName
			,contWA.[ConFullName] AS VendWorkAddressIdName
			,contBA.[ConFullName] AS VendBusinessAddressIdName
			,contCA.[ConFullName] AS VendCorporateAddressIdName
			,COMP.Id CompanyId
		FROM [dbo].[VEND000Master](NOLOCK) Vendor
		INNER JOIN dbo.COMP000Master(NOLOCK) COMP ON Vendor.[ID] = COMP.[CompPrimaryRecordId]
			AND COMP.CompTableName = 'Vendor'
		LEFT JOIN [dbo].[ORGAN000Master](NOLOCK) org ON Vendor.[VendOrgID] = org.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contWA ON Vendor.[VendWorkAddressId] = contWA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contBA ON Vendor.[VendBusinessAddressId] = contBA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contCA ON Vendor.[VendCorporateAddressId] = contCA.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON Vendor.[StatusId] = hfk.[StatusId]
		WHERE Vendor.[VendOrgId] = 1 AND Vendor.StatusId in(1,2)
			AND (
				Vendor.VendBusinessAddressId IN (Select ContactId From #ContactId)
				OR Vendor.VendCorporateAddressId IN (Select ContactId From #ContactId)
				OR Vendor.VendWorkAddressId IN (Select ContactId From #ContactId)
				)
		ORDER BY Vendor.VendItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'VendContact')
	BEGIN
		SELECT VendContact.ConCodeId
			,VendContact.ConItemNumber
			,VendContact.ConPrimaryRecordId
			,VendContact.ContactMSTRID
			,VendContact.ConTitle
			,VendContact.Id
			,VendContact.StatusId
			,vend.[VendCode] AS ConPrimaryRecordIdName
			,cont.[ConFullName] AS ContactMSTRIDName
			,rol.OrgRoleCode AS ConCodeIdName
			,cont.[ConJobTitle] AS ConJobTitle
			,cont.[ConEmailAddress] AS ConEmailAddress
			,cont.[ConMobilePhone] AS ConMobilePhone
			,cont.[ConBusinessPhone] AS ConBusinessPhone
			,cont.[ConBusinessAddress1] AS ConBusinessAddress1
			,cont.[ConBusinessAddress2] AS ConBusinessAddress2
			,cont.[ConBusinessCity] AS ConBusinessCity
			,cont.[ConBusinessZipPostal] AS ConBusinessZipPostal
			,sts.[StateAbbr] AS ConBusinessStateIdName
			,sysRef.[SysOptionName] AS ConBusinessCountryIdName
			,(
				coalesce(cont.[ConBusinessAddress1], '') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '') + coalesce(CHAR(13) + cont.[ConBusinessCity], '') + CASE 
					WHEN (
							(coalesce(cont.[ConBusinessAddress1], '') <> '')
							OR (coalesce(cont.[ConBusinessAddress2], '') <> '')
							OR (coalesce(cont.[ConBusinessCity], '') <> '')
							)
						THEN coalesce(', ' + sts.[StateAbbr], '')
					ELSE coalesce('' + sts.[StateAbbr], '')
					END + coalesce(', ' + cont.[ConBusinessZipPostal], '') + coalesce(CHAR(13) + sysRef.[SysOptionName], '')
				) AS ConBusinessFullAddress
		FROM [dbo].[CONTC010Bridge](NOLOCK) VendContact
		LEFT JOIN [dbo].[VEND000Master](NOLOCK) vend ON VendContact.[ConPrimaryRecordId] = vend.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON VendContact.[ContactMSTRID] = cont.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_States](NOLOCK) sts ON cont.[ConBusinessStateId] = sts.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_Options](NOLOCK) sysRef ON cont.[ConBusinessCountryId] = sysRef.[Id]
		LEFT JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) rol ON VendContact.[ConCodeId] = rol.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(VendContact.[StatusId], 1) = hfk.[StatusId]
		WHERE 1 = 1
			AND VendContact.[ConTableName] = @entity AND VendContact.StatusId in(1,2)
			AND cont.Id IN (Select ContactId From #ContactId)
		ORDER BY VendContact.ConItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'VendDCLocation')
	BEGIN
		SELECT VendDcLocation.Id
			,VendDcLocation.StatusId
			,CB.ContactMSTRID as VdcContactMSTRID
			,VendDcLocation.VdcCustomerCode
			,VendDcLocation.VdcItemNumber
			,VendDcLocation.VdcLocationCode
			,VendDcLocation.VdcLocationTitle
			,vend.[VendCode] AS VdcVendorIDName
			,cont.[ConFullName] AS VdcContactMSTRIDName
			,cont.[ConJobTitle] AS ConJobTitle
			,cont.[ConEmailAddress] AS ConEmailAddress
			,cont.[ConMobilePhone] AS ConMobilePhone
			,cont.[ConBusinessPhone] AS ConBusinessPhone
			,cont.[ConBusinessAddress1] AS ConBusinessAddress1
			,cont.[ConBusinessAddress2] AS ConBusinessAddress2
			,cont.[ConBusinessCity] AS ConBusinessCity
			,cont.[ConBusinessZipPostal] AS ConBusinessZipPostal
			,sts.[StateAbbr] AS ConBusinessStateIdName
			,sysRef.[SysOptionName] AS ConBusinessCountryIdName
			,(
				coalesce(cont.[ConBusinessAddress1], '') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '') + coalesce(CHAR(13) + cont.[ConBusinessCity], '') + CASE 
					WHEN (
							(coalesce(cont.[ConBusinessAddress1], '') <> '')
							OR (coalesce(cont.[ConBusinessAddress2], '') <> '')
							OR (coalesce(cont.[ConBusinessCity], '') <> '')
							)
						THEN coalesce(', ' + sts.[StateAbbr], '')
					ELSE coalesce('' + sts.[StateAbbr], '')
					END + coalesce(', ' + cont.[ConBusinessZipPostal], '') + coalesce(CHAR(13) + sysRef.[SysOptionName], '')
				) AS ConBusinessFullAddress
		FROM [dbo].[VEND040DCLocations](NOLOCK) VendDcLocation
		LEFT JOIN [dbo].[VEND000Master](NOLOCK) vend ON VendDcLocation.[VdcVendorID] = vend.[Id]
		LEFT JOIN [dbo].[CONTC010Bridge](NOLOCK) CB ON CB.ConPrimaryRecordId = VendDcLocation.Id 
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON cb.ContactMSTRID = cont.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_States](NOLOCK) sts ON cont.[ConBusinessStateId] = sts.[Id]
		LEFT JOIN [dbo].[SYSTM000Ref_Options](NOLOCK) sysRef ON cont.[ConBusinessCountryId] = sysRef.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(VendDcLocation.[StatusId], 1) = hfk.[StatusId]
		WHERE 1 = 1 AND CB.ConTableName='VendDcLocation'
			AND cont.Id IN (Select ContactId From #ContactId) AND VendDcLocation.StatusId in(1,2)
		ORDER BY VendDcLocation.VdcItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'VendDCLocationContact')
	BEGIN
		SELECT VendDcLocationContact.ConCodeId
			,VendDcLocationContact.ConItemNumber
			,VendDcLocationContact.ContactMSTRID
			,VendDcLocationContact.ConTitle
			,VendDcLocationContact.Id
			,VendDcLocationContact.StatusId
			,org.OrgCode AS ConOrgIdName
			,VendDcLocationContact.[ConTitleId] AS ConTitleId
			,VendDcLocationContact.[ConFullName] AS ContactMSTRIDName
			,VendDcLocationContact.ConBusinessPhone AS ConBusinessPhone
			,VendDcLocationContact.ConBusinessPhoneExt AS ConBusinessPhoneExt
			,VendDcLocationContact.ConMobilePhone AS ConMobilePhone
			,refOp.OrgRoleCode AS ConCodeIdName
		FROM [dbo].[vwDCLocationContactMapping](NOLOCK) VendDcLocationContact
		LEFT JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) refOp ON VendDcLocationContact.[ConCodeId] = refOp.[Id]
		LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id = VendDcLocationContact.[ConOrgId]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(VendDcLocationContact.[StatusId], 1) = hfk.[StatusId]
		WHERE VendDcLocationContact.ContactMSTRID IN (Select ContactId From #ContactId)
			AND VendDcLocationContact.[ConTableName] = 'VendDcLocationContact' AND VendDcLocationContact.StatusId in(1,2)
		ORDER BY VendDcLocationContact.ConItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'Organization')
	BEGIN
		SELECT Organization.Id
			,Organization.OrgBusinessAddressId
			,Organization.OrgCode
			,Organization.OrgCorporateAddressId
			,Organization.OrgGroupId
			,1 AS OrgSortOrder
			,Organization.OrgTitle
			,Organization.OrgWorkAddressId
			,Organization.StatusId
			,cont.[ConFullName] AS OrgContactIdName
			,contWA.[ConFullName] AS OrgWorkAddressIdName
			,contBA.[ConFullName] AS OrgBusinessAddressIdName
			,contCA.[ConFullName] AS OrgCorporateAddressIdName
			,COMP.Id CompanyId
		FROM [dbo].[ORGAN000Master](NOLOCK) Organization
		INNER JOIN dbo.COMP000Master(NOLOCK) COMP ON Organization.[ID] = COMP.[CompPrimaryRecordId]
			AND COMP.CompTableName = 'Organization'
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contWA ON Organization.[OrgWorkAddressId] = contWA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contBA ON Organization.[OrgBusinessAddressId] = contBA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) contCA ON Organization.[OrgCorporateAddressId] = contCA.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON Organization.[OrgContactId] = cont.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Organization.[StatusId] = fgus.[StatusId]
		WHERE Organization.Id = 1 AND Organization.StatusId in(1,2)
			AND (
				Organization.OrgBusinessAddressId IN (Select ContactId From #ContactId)
				OR Organization.OrgCorporateAddressId IN (Select ContactId From #ContactId)
				OR Organization.OrgWorkAddressId IN (Select ContactId From #ContactId)
				)
		ORDER BY Organization.OrgSortOrder
	END
	ELSE IF (ISNULL(@entity, '') = 'OrgPocContact')
	BEGIN
		SELECT OrgPocContact.ConCodeId
			,OrgPocContact.ConIsDefault
			,OrgPocContact.ConItemNumber
			,OrgPocContact.ConOrgId
			,OrgPocContact.ConTableTypeId
			,OrgPocContact.ContactMSTRID
			,OrgPocContact.ConTitle
			,OrgPocContact.Id
			,OrgPocContact.StatusId
			,OrgPocContact.ConCodeId
			,OrgPocContact.ConIsDefault
			,OrgPocContact.ConItemNumber
			,OrgPocContact.ConOrgId
			,OrgPocContact.ContactMSTRID
			,OrgPocContact.ConTitle
			,OrgPocContact.ConTableTypeId
			,org.[OrgCode] AS ConOrgIdName
			,cont.[ConFullName] AS ContactMSTRIDName
			,rol.OrgRoleCode AS ConCodeIdName
			,COMP.Id ConCompanyId
		FROM [dbo].[CONTC010Bridge](NOLOCK) OrgPocContact
		INNER JOIN dbo.COMP000Master COMP ON OrgPocContact.ConPrimaryRecordId = COMP.CompPrimaryRecordId
			AND COMP.CompTableName = 'Organization'
		LEFT JOIN [dbo].[ORGAN000Master](NOLOCK) org ON OrgPocContact.[ConOrgId] = org.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON OrgPocContact.[ContactMSTRID] = cont.[Id]
		INNER JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) rol ON OrgPocContact.[ConCodeId] = rol.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(OrgPocContact.[StatusId], 1) = hfk.[StatusId]
		WHERE cont.Id IN (Select ContactId From #ContactId) AND OrgPocContact.StatusId in(1,2)
			AND OrgPocContact.[ConTableName] = 'OrgPocContact'
		ORDER BY OrgPocContact.ConItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'OrgRefRole')
	BEGIN
		SELECT OrgRefRole.Id
			,OrgRefRole.OrgRoleCode
			,OrgRefRole.OrgRoleContactID
			,OrgRefRole.OrgRoleDefault
			,OrgRefRole.OrgRoleSortOrder
			,OrgRefRole.OrgRoleTitle
			,OrgRefRole.PrxJobDefaultAnalyst
			,OrgRefRole.PrxJobDefaultResponsible
			,OrgRefRole.PrxJobGWDefaultAnalyst
			,OrgRefRole.PrxJobGWDefaultResponsible
			,OrgRefRole.RoleTypeId
			,org.[OrgCode] AS OrgIDName
		FROM [dbo].[ORGAN010Ref_Roles](NOLOCK) OrgRefRole
		LEFT JOIN [dbo].[ORGAN000Master](NOLOCK) org ON OrgRefRole.[OrgID] = org.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(OrgRefRole.[StatusId], 1) = hfk.[StatusId]
		WHERE 1 = 1
			AND OrgRefRole.OrgRoleContactID IN (Select ContactId From #ContactId) AND OrgRefRole.StatusId in(1,2)
		ORDER BY OrgRefRole.OrgRoleSortOrder
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgRole')
	BEGIN
		SELECT PrgRole.Id
			,PrgRole.OrgRefRoleId
			,PrgRole.PrgRoleContactID
			,PrgRole.PrgRoleId
			,PrgRole.PrgRoleSortOrder
			,PrgRole.PrgRoleTitle
			,PrgRole.PrxJobDefaultAnalyst
			,PrgRole.PrxJobDefaultResponsible
			,PrgRole.PrxJobGWDefaultAnalyst
			,PrgRole.PrxJobGWDefaultResponsible
			,PrgRole.StatusId
			,org.[OrgTitle] AS OrgIDName
			,prg.[PrgProgramTitle] AS ProgramIDName
			,orgrol.[OrgRoleCode] AS OrgRefRoleIdName
			,prgrol.[PrgRoleCode] AS PrgRoleIdName
			,cont.ConFullName AS PrgRoleContactIDName
		FROM [dbo].[PRGRM020Program_Role](NOLOCK) PrgRole
		LEFT JOIN [dbo].[ORGAN000Master](NOLOCK) org ON PrgRole.[OrgID] = org.[Id]
		LEFT JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) orgrol ON PrgRole.[OrgRefRoleId] = orgrol.[Id]
		LEFT JOIN [dbo].[PRGRM020_Roles](NOLOCK) prgrol ON PrgRole.[PrgRoleId] = prgrol.[Id]
		LEFT JOIN [dbo].[PRGRM000Master](NOLOCK) prg ON PrgRole.[ProgramID] = prg.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON PrgRole.[PrgRoleContactID] = cont.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(PrgRole.[StatusId], 1) = hfk.[StatusId]
		WHERE PrgRole.[OrgId] = 1 AND PrgRole.StatusId in(1,2)
			AND cont.Id IN (Select ContactId From #ContactId)
		ORDER BY PrgRole.PrgRoleSortOrder
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgVendLocation')
	BEGIN
		SELECT PrgVendLocation.Id
			,PrgVendLocation.PvlContactMSTRID
			,PrgVendLocation.PvlDateEnd
			,PrgVendLocation.PvlDateStart
			,PrgVendLocation.PvlItemNumber
			,PrgVendLocation.PvlLocationCode
			,PrgVendLocation.PvlLocationCodeCustomer
			,PrgVendLocation.PvlLocationTitle
			,PrgVendLocation.PvlUserCode1
			,PrgVendLocation.PvlUserCode2
			,PrgVendLocation.PvlUserCode3
			,PrgVendLocation.PvlUserCode4
			,PrgVendLocation.PvlUserCode5
			,PrgVendLocation.PvlVendorID
			,PrgVendLocation.StatusId
			,vend.[VendCode] AS PvlVendorIDName
			,cont.[ConFullName] AS PvlContactMSTRIDName
			,CASE 
				WHEN prg.PrgHierarchyLevel = 1
					THEN prg.[PrgProgramCode]
				WHEN prg.PrgHierarchyLevel = 2
					THEN prg.[PrgProjectCode]
				WHEN prg.PrgHierarchyLevel = 3
					THEN prg.PrgPhaseCode
				ELSE prg.[PrgProgramTitle]
				END AS PvlProgramIDName
		FROM [dbo].[PRGRM051VendorLocations](NOLOCK) PrgVendLocation
		LEFT JOIN [dbo].[PRGRM000Master](NOLOCK) prg ON PrgVendLocation.[PvlProgramID] = prg.[Id]
		LEFT JOIN [dbo].[VEND000Master](NOLOCK) vend ON PrgVendLocation.[PvlVendorID] = vend.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON PrgVendLocation.[PvlContactMSTRID] = cont.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(PrgVendLocation.[StatusId], 1) = hfk.[StatusId]
		WHERE cont.Id IN (Select ContactId From #ContactId) AND PrgVendLocation.StatusId in(1,2)
		ORDER BY PrgVendLocation.PvlItemNumber
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgRefGatewayDefault')
	BEGIN
		SELECT PrgRefGatewayDefault.GatewayDateRefTypeId
			,PrgRefGatewayDefault.GatewayTypeId
			,PrgRefGatewayDefault.Id
			,PrgRefGatewayDefault.PgdGatewayAnalyst
			,PrgRefGatewayDefault.PgdGatewayCode
			,PrgRefGatewayDefault.PgdGatewayDefault
			,PrgRefGatewayDefault.PgdGatewayDuration
			,PrgRefGatewayDefault.PgdGatewayResponsible
			,PrgRefGatewayDefault.PgdGatewaySortOrder
			,PrgRefGatewayDefault.PgdGatewayTitle
			,PrgRefGatewayDefault.PgdOrderType
			,PrgRefGatewayDefault.PgdShipApptmtReasonCode
			,PrgRefGatewayDefault.PgdShipmentType
			,PrgRefGatewayDefault.PgdShipStatusReasonCode
			,PrgRefGatewayDefault.Scanner
			,PrgRefGatewayDefault.StatusId
			,PrgRefGatewayDefault.UnitTypeId
			,prg.[PrgProgramTitle] AS PgdProgramIDName
			,respContact.[ConFullName] AS PgdGatewayResponsibleName
			,anaContact.[ConFullName] AS PgdGatewayAnalystName
		FROM [dbo].[PRGRM010Ref_GatewayDefaults](NOLOCK) PrgRefGatewayDefault
		LEFT JOIN [dbo].[PRGRM000Master](NOLOCK) prg ON PrgRefGatewayDefault.[PgdProgramID] = prg.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) respContact ON PrgRefGatewayDefault.[PgdGatewayResponsible] = respContact.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) anaContact ON PrgRefGatewayDefault.[PgdGatewayAnalyst] = anaContact.[Id]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(PrgRefGatewayDefault.[StatusId], 1) = hfk.[StatusId]
		WHERE (
				anaContact.Id IN (Select ContactId From #ContactId)
				OR respContact.Id IN (Select ContactId From #ContactId)
				) AND PrgRefGatewayDefault.StatusId in(1,2)
		ORDER BY PrgRefGatewayDefault.GatewayTypeId
			,PrgRefGatewayDefault.PgdOrderType
			,PrgRefGatewayDefault.PgdShipmentType
			,PrgRefGatewayDefault.PgdGatewaySortOrder
	END
	ELSE IF (ISNULL(@entity, '') = 'Job')
	BEGIN
		SELECT JobId
			,Count(JobId) CargoCount
		INTO #ActualCargoItemCount
		FROM [dbo].[JOBDL010Cargo]
		WHERE StatusId IN (
				1
				,2
				)
			AND ISNULL(CgoQtyUnits, '') <> ''
			AND CgoQtyUnits NOT IN (
				'Cabinets'
				,'Pallets'
				)
		GROUP BY JobId

		SELECT JobId
			,Count(JobId) CargoCount
		INTO #ActualCargoQuantityCount
		FROM [dbo].[JOBDL010Cargo]
		WHERE StatusId IN (
				1
				,2
				)
			AND ISNULL(CgoQtyUnits, '') <> ''
			AND CgoQtyUnits IN (
				'Cabinets'
				,'Pallets'
				)
		GROUP BY JobId

		SELECT Job.CarrierID
			,Job.Id
			,Job.JobBOL
			,Job.JobBOLChild
			,Job.JobBOLMaster
			,Job.JobCarrierContract
			,Job.JobChannel
			,Job.JobCompleted
			,Job.JobConsigneeCode
			,Job.JobCustomerPurchaseOrder
			,Job.JobCustomerSalesOrder
			,Job.JobDeliveryAnalystContactID
			,Job.JobDeliveryCity
			,Job.JobDeliveryCountry
			,Job.JobDeliveryDateTimeActual
			,Job.JobDeliveryDateTimeBaseline
			,Job.JobDeliveryDateTimePlanned
			,Job.JobDeliveryPostalCode
			,Job.JobDeliveryRecipientEmail
			,Job.JobDeliveryRecipientPhone
			,Job.JobDeliveryResponsibleContactID
			,Job.JobDeliverySiteName
			,Job.JobDeliverySitePOC
			,Job.JobDeliverySitePOC2
			,Job.JobDeliverySitePOCEmail
			,Job.JobDeliverySitePOCEmail2
			,Job.JobDeliverySitePOCPhone
			,Job.JobDeliverySitePOCPhone2
			,Job.JobDeliveryState
			,Job.JobDeliveryStreetAddress
			,Job.JobDeliveryStreetAddress2
			,Job.JobDeliveryTimeZone
			,Job.JobDriverId
			,Job.JobGatewayStatus
			,Job.JobLatitude
			,Job.JobLongitude
			,Job.JobManifestNo
			,Job.JobMITJobID
			,Job.JobOriginCity
			,Job.JobOriginCountry
			,Job.JobOriginDateTimeActual
			,Job.JobOriginDateTimeBaseline
			,Job.JobOriginDateTimePlanned
			,Job.JobOriginPostalCode
			,Job.JobOriginResponsibleContactID
			,Job.JobOriginSiteCode
			,Job.JobOriginSiteName
			,Job.JobOriginSitePOC
			,Job.JobOriginSitePOC2
			,Job.JobOriginSitePOCEmail
			,Job.JobOriginSitePOCEmail2
			,Job.JobOriginSitePOCPhone
			,Job.JobOriginSitePOCPhone2
			,Job.JobOriginState
			,Job.JobOriginStreetAddress
			,Job.JobOriginStreetAddress2
			,Job.JobOriginTimeZone
			,CASE 
				WHEN ISNULL(Job.JobPartsActual, 0) > 0
					THEN CAST(Job.JobPartsActual AS INT)
				WHEN ISNULL(CC.CargoCount, 0) > 0
					THEN CAST(CC.CargoCount AS INT)
				ELSE NULL
				END JobPartsActual
			,CAST(Job.JobPartsOrdered AS INT) JobPartsOrdered
			,Job.JobProcessingFlags
			,Job.JobProductType
			,CASE 
				WHEN ISNULL(Job.JobQtyActual, 0) > 0
					THEN CAST(Job.JobQtyActual AS INT)
				WHEN ISNULL(CC1.CargoCount, 0) > 0
					THEN CAST(CC1.CargoCount AS INT)
				ELSE NULL
				END JobQtyActual
			,Job.JobQtyOrdered
			,Job.JobQtyUnitTypeId
			,Job.JobRouteId
			,Job.JobSellerCity
			,Job.JobSellerCode
			,Job.JobSellerCountry
			,Job.JobSellerPostalCode
			,Job.JobSellerSiteName
			,Job.JobSellerSitePOC
			,Job.JobSellerSitePOC2
			,Job.JobSellerSitePOCEmail
			,Job.JobSellerSitePOCEmail2
			,Job.JobSellerSitePOCPhone
			,Job.JobSellerSitePOCPhone2
			,Job.JobSellerState
			,Job.JobSellerStreetAddress
			,Job.JobSellerStreetAddress2
			,Job.JobServiceMode
			,Job.JobSignLatitude
			,Job.JobSignLongitude
			,Job.JobSignText
			,Job.JobSiteCode
			,Job.JobStatusedDate
			,Job.JobStop
			,Job.JobTotalCubes
			,Job.JobType
			,Job.JobUser01
			,Job.JobUser02
			,Job.JobUser03
			,Job.JobUser04
			,Job.JobUser05
			,Job.PlantIDCode
			,Job.ProgramID
			,Job.ShipmentType
			,Job.StatusId
			,Job.WindowDelEndTime
			,Job.WindowDelStartTime
			,Job.WindowPckEndTime
			,Job.WindowPckStartTime
			,CASE 
				WHEN prg.PrgHierarchyLevel = 1
					THEN prg.PrgProgramCode
				WHEN prg.PrgHierarchyLevel = 2
					THEN prg.PrgProjectCode
				WHEN prg.PrgHierarchyLevel = 3
					THEN prg.PrgPhaseCode
				ELSE prg.PrgProgramTitle
				END AS ProgramIDName
			,cont.[ConFullName] AS JobDeliveryResponsibleContactIDName
			,anaCont.[ConFullName] AS JobDeliveryAnalystContactIDName
			,driverCont.[ConFullName] AS JobDriverIdName
		FROM [dbo].[JOBDL000Master](NOLOCK) Job
		LEFT JOIN [dbo].[PRGRM000Master](NOLOCK) prg ON Job.[ProgramID] = prg.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON Job.[JobDeliveryResponsibleContactID] = cont.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) anaCont ON Job.[JobDeliveryAnalystContactID] = anaCont.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) driverCont ON Job.[JobDriverId] = driverCont.[Id]
		LEFT JOIN #ActualCargoItemCount(NOLOCK) CC ON Job.[Id] = CC.[JobId]
		LEFT JOIN #ActualCargoQuantityCount(NOLOCK) CC1 ON Job.[Id] = CC.[JobId]
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(Job.[StatusId], 1) = hfk.[StatusId]
		WHERE 1 = 1 AND Job.StatusId in(1,2)
			AND (
				cont.Id IN (Select ContactId From #ContactId)
				OR anaCont.Id IN (Select ContactId From #ContactId)
				OR driverCont.Id IN (Select ContactId From #ContactId)
				)
		ORDER BY Job.Id

		DROP TABLE #ActualCargoItemCount

		DROP TABLE #ActualCargoQuantityCount
	END
	ELSE IF (ISNULL(@entity, '') = 'JobGateway')
	BEGIN
		SELECT JobGateway.GatewayTypeId
			,JobGateway.GatewayUnitId
			,JobGateway.GwyAttachments
			,JobGateway.GwyClosedBy
			,JobGateway.GwyClosedOn
			,JobGateway.GwyCompleted
			,JobGateway.GwyDateRefTypeId
			,JobGateway.GwyDDPCurrent
			,JobGateway.GwyDDPNew
			,JobGateway.GwyEmail
			,JobGateway.GwyGatewayACD
			,JobGateway.GwyGatewayAnalyst
			,JobGateway.GwyGatewayCode
			,JobGateway.GwyGatewayDuration
			,JobGateway.GwyGatewayECD
			,JobGateway.GwyGatewayPCD
			,JobGateway.GwyGatewayResponsible
			,JobGateway.GwyGatewaySortOrder
			,JobGateway.GwyGatewayTitle
			,JobGateway.GwyLwrDate
			,JobGateway.GwyLwrWindow
			,JobGateway.GwyOrderType
			,JobGateway.GwyPerson
			,JobGateway.GwyPhone
			,JobGateway.GwyShipApptmtReasonCode
			,JobGateway.GwyShipmentType
			,JobGateway.GwyShipStatusReasonCode
			,JobGateway.GwyTitle
			,JobGateway.GwyUpdatedById
			,JobGateway.GwyUprDate
			,JobGateway.GwyUprWindow
			,JobGateway.Id
			,JobGateway.Scanner
			,JobGateway.StatusId
			,job.[JobSiteCode] AS JobIDName
			,prg.[PrgProgramTitle] AS ProgramIDName
			,CASE 
				WHEN cont.Id > 0
					OR JobGateway.GwyClosedBy IS NULL
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS ClosedByContactExist
			,job.[JobCompleted] AS JobCompleted
			,respContact.[ConFullName] AS GwyGatewayResponsibleName
			,anaContact.[ConFullName] AS GwyGatewayAnalystName
		FROM [dbo].[JOBDL020Gateways](NOLOCK) JobGateway
		LEFT JOIN [dbo].[JOBDL000Master](NOLOCK) job ON JobGateway.[JobID] = job.[Id]
		LEFT JOIN [dbo].[PRGRM000Master](NOLOCK) prg ON JobGateway.[ProgramID] = prg.[Id]
		LEFT JOIN CONTC000Master cont ON JobGateway.GwyClosedBy = cont.ConFullName
			AND cont.StatusId = 1
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) respContact ON JobGateway.[GwyGatewayResponsible] = respContact.[Id]
		LEFT JOIN [dbo].[CONTC000Master](NOLOCK) anaContact ON JobGateway.[GwyGatewayAnalyst] = anaContact.[Id]
		WHERE (
				cont.Id IN (Select ContactId From #ContactId)
				OR anaContact.Id IN (Select ContactId From #ContactId)
				OR respContact.Id IN (Select ContactId From #ContactId)
				) AND JobGateway.StatusId in(1,2)
		ORDER BY JobGateway.GwyGatewaySortOrder
	END
	ELSE IF (ISNULL(@entity, '') = 'Account')
	BEGIN
	SELECT SystemAccount.Id
	,SystemAccount.IsSysAdmin
	,SystemAccount.StatusId
	,SystemAccount.SysAttempts
	,SystemAccount.SysDateLastAttempt
	,SystemAccount.SysLoggedIn
	,SystemAccount.SysLoggedInEnd
	,SystemAccount.SysLoggedInStart
	,SystemAccount.SysOrgId
	,SystemAccount.SysOrgRefRoleId
	,SystemAccount.SysPassword
	,SystemAccount.SysScreenName
	,SystemAccount.SysUserContactID
	,org.[OrgCode] AS SysOrgIdName
	,cont.[ConFullName] AS SysUserContactIDName
	,rol.OrgRoleCode AS SysOrgRefRoleIdName
	,SystemAccount.IsSysAdmin AS IsSysAdminPrev
FROM [dbo].[SYSTM000OpnSezMe](NOLOCK) SystemAccount
INNER JOIN [dbo].[ORGAN000Master](NOLOCK) org ON SystemAccount.[SysOrgId] = org.[Id]
INNER JOIN [dbo].[ORGAN010Ref_Roles](NOLOCK) rol ON SystemAccount.[SysOrgRefRoleId] = rol.[Id]
LEFT JOIN [dbo].[CONTC000Master](NOLOCK) cont ON SystemAccount.[SysUserContactID] = cont.[Id]
INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(SystemAccount.[StatusId], 1) = hfk.[StatusId]
WHERE SystemAccount.[SysOrgId] = @orgId AND SystemAccount.SysUserContactID IN (Select ContactId From #ContactId)
	END
	ELSE
	BEGIN
		SET @query = 'SELECT * FROM  ' + @tableName + '    WHERE StatusId in(1,2) AND (' + @query + ')';

		EXEC sp_executesql @query
	END

	DROP TABLE #ContactId
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
