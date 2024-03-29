SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    KIRTY ANURAG
-- Create date:               05/21/2020
-- Description:               GetPreferedLocations
-- Execution:                 EXEC [dbo].[GetPreferedLocations] 1, 2, 'EN', 62, 1, 1
-- Modified on:               
-- Modified Desc:   
-- =============================================
CREATE PROCEDURE [dbo].[GetPreferedLocations] @orgId BIGINT
	,@userId BIGINT
	,@langCode NVARCHAR(20)
	,@conTypeId INT
	,@roleId BIGINT
	,@Opt BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PrefreedLocation NVARCHAR(MAX)

	IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@roleId,0)<>0)
    BEGIN   
	SELECT @conTypeId = con.ConTypeId 
	  FROM [dbo].[SYSTM000OpnSezMe] AS sez  
	INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.[Id]  
	INNER JOIN [dbo].[ORGAN000Master] org ON sez.[SysOrgId] = org.Id  
	INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sez.[SysOrgRefRoleId] = refRole.Id  
    WHERE  sez.[Id]  = @userId AND  org.Id   = @orgId AND refRole.Id   = @roleId;
	END

	IF(ISNULL(@conTypeId, 0) = 62)
	BEGIN
		SELECT DISTINCT @PrefreedLocation = VLP.VdcLocationCode
		FROM SYSTM000VdcLocationPreferences VLP
		WHERE VLP.UserId = @userId
			AND VLP.OrganizationId = @orgId
			AND VLP.LangCode = @langCode
			AND VLP.ContactType = @conTypeId

		SELECT DISTINCT convert(BIGINT, SP.item) Id
			,PVL.PvlLocationCode PPPVendorLocationCode
			,VCL.VdcLocationCode VendorDcLocationCode
		FROM PRGRM051VendorLocations PVL
		INNER JOIN VEND040DCLocations VCL ON VCL.Id = PVL.VendDCLocationId
		INNER JOIN fnSplitString(@PrefreedLocation, ',') SP ON SP.item = PVL.VendDCLocationId
		WHERE PVL.StatusId = 1 AND VCL.StatusId=1 ORDER BY VCL.VdcLocationCode ASC
	END
END
GO
