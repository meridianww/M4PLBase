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
-- Execution:                 EXEC [dbo].[GetPreferedLocations] 1, 20042, 'EN', 62, 1, 1
-- Modified on:               
-- Modified Desc:   
-- =============================================
ALTER PROCEDURE [dbo].[GetPreferedLocations]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@conTypeId INT,
	@roleId BIGINT,
	@Opt BIT = 0
	AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE  @locationOld NVARCHAR(MAX) = NULL
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@conTypeId,'')<>'')
    BEGIN 
	IF(@Opt = 1)
	BEGIN
		SELECT DISTINCT
		convert(bigint, SP.item)  Id,
		PVL.PvlLocationCode PPPVendorLocationCode,
		VCL.VdcLocationCode VendorDcLocationCode
		FROM PRGRM051VendorLocations  PVL
		INNER JOIN VEND040DCLocations VCL ON VCL.Id = PVL.VendDCLocationId
		INNER JOIN fnSplitString(
		(SELECT VLP.VdcLocationCode FROM SYSTM000VdcLocationPreferences  VLP
		WHERE VLP.UserId = @userId
		AND VLP.OrganizationId = @orgId 
		AND VLP.LangCode = @langCode 
		AND VLP.ContactType = @conTypeId)
		, ',') SP
		ON SP.item = PVL.VendDCLocationId WHERE PVL.StatusId = 1
	END
	ELSE
	BEGIN
		SELECT @locationOld = usys.[VdcLocationCode] 
		FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys 
		where usys.UserId=@userId AND usys.LangCode = @langCode AND usys.ContactType = @conTypeId AND usys.OrganizationId = @orgId
		SELECT DISTINCT  @locationOld AS preferedlocations
	END	
	END	
	
	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
