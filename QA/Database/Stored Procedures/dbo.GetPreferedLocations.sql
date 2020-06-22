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
	WHERE PVL.StatusId = 1
END
GO

