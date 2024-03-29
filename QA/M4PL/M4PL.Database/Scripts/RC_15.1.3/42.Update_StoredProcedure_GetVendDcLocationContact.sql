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
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:			  Removed commented code and review suggested changes and updated fields that need to be fetched.
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
	,COMP.Id ConCompanyId
	FROM [dbo].[VEND040DCLocations]  vdc
	INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = vdc.VdcVendorID AND COMP.CompTableName = 'Vendor'
	JOIN [dbo].[CONTC000Master] cont ON vdc.VdcContactMSTRID = cont.Id
	INNER JOIN [dbo].[ORGAN000Master] org On org.Id = cont.ConOrgId
	WHERE vdc.Id = @parentId
 END
 ELSE
 BEGIN

  SELECT vend.[Id] 
		,vend.[ConPrimaryRecordId] 
		,vend.[ConItemNumber]
		,vend.[ConCodeId]
		,vend.[ConTitle]
		,vend.[ContactMSTRID]
		,vend.[ConTableTypeId]
		,vend.[StatusId]
		,vend.[EnteredBy]
		,vend.[DateEntered]
		,vend.[ChangedBy]
		,vend.[DateChanged]
		,ve.Id AS ParentId
		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,org.OrgTitle as ConCompany
		,cont.ConTypeId
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
		,COMP.Id ConCompanyId
		 FROM [dbo].[CONTC010Bridge] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.ConPrimaryRecordId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
   INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = ve.Id AND COMP.CompTableName = 'Vendor'
  JOIN [dbo].[CONTC000Master] cont ON vend.ContactMSTRID = cont.Id
  INNER JOIN [dbo].[ORGAN000Master] org On org.Id = vend.ConOrgId
  WHERE vend.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH