
/* Copyright (2020) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               04/22/2020   
-- Description:               Get Address Based on Company
-- Execution:                 EXEC [dbo].[GetCompAddress]
-- ============================================= 
CREATE PROCEDURE [dbo].[GetCompAddress] @compId BIGINT
    ,@orgId INT = 1 
	,@sysLookupCode nvarchar(50) = 'AddressType' 
	,@sysOptionName nvarchar(50) = NULL 
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @AddressType INT
	
	IF((ISNULL(@sysLookupCode,'')<>'') AND (ISNULL(@sysOptionName,'')<>''))
	BEGIN
	SELECT @AddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = @sysLookupCode
		AND SysOptionName = @sysOptionName

	END
	ELSE
	BEGIN 
		SELECT @AddressType = ID
	    FROM [dbo].[SYSTM000Ref_Options]
	    WHERE SysLookupCode = @sysLookupCode
		AND SysOptionName = 'Corporate' -- Default Corporate address
	 
	END
	SELECT 
		CC.Address1  Address1
		,CC.Address2 Address2
		,CC.City City
		,CC.ZipPostal ZipPostal
		,CC.StateId StateId
		,CC.CountryId CountryId
		,SC.[StateAbbr] StateIdName
		,ConC.[SysOptionName] CountryIdName
		
		
     
  FROM [dbo].[COMP000Master] COMP 
  INNER JOIN    [COMPADD000Master] CC ON COMP.Id = CC.AddCompId 
  LEFT JOIN [dbo].[CUST000Master] cust ON  cust.Id = COMP.CompPrimaryRecordId
  LEFT JOIN  [dbo].[VEND000Master] Vend ON  vend.Id = COMP.CompPrimaryRecordId
  LEFT JOIN  [dbo].[ORGAN000Master] orgprimary ON  orgprimary.Id = COMP.CompPrimaryRecordId
  INNER JOIN [dbo].[ORGAN000Master] org ON COMP.CompOrgId = org.Id
  LEFT JOIN [dbo].[SYSTM000Ref_States] SC ON SC.Id = CC.StateId
  LEFT JOIN [dbo].[SYSTM000Ref_Options] ConC ON ConC.Id = CC.CountryId
  where COMP.CompOrgId = @orgId  ANd  COMP.Id = @compId  AND CC.AddTypeId = @AddressType  and COMP.StatusId in (1,2)
	
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