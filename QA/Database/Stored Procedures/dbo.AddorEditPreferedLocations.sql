SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               06/08/2018      
-- Description:               Update user system settings
-- Execution:                 EXEC [dbo].[UpdUserSystemSettings]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[AddorEditPreferedLocations]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@contactType INT,
	@locations NVARCHAR(MAX),
	@Opt BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@contactType,'')<>'')
    BEGIN   
	DECLARE  @locationOld NVARCHAR(MAX) = NULL
	SELECT @locationOld = usys.[VdcLocationCode] 
	FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys 
	WHERE usys.UserId=@userId 
	AND usys.OrganizationId=@orgId 
	AND usys.LangCode = @langCode 
	AND usys.ContactType = @contactType

	IF EXISTS (SELECT TOP 1 1 FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys WHERE usys.UserId=@userId)
	BEGIN
	 UPDATE [dbo].[SYSTM000VdcLocationPreferences]
	SET [VdcLocationCode] = @locations -- ISNULL(@locations, @locationOld)
	 WHERE UserId=@userId AND OrganizationId=@orgId AND LangCode = @langCode AND ContactType  = @contactType

	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[SYSTM000VdcLocationPreferences](OrganizationId, UserId, LangCode, ContactType, VdcLocationCode) 
	VALUES(@orgId, @userId, @langCode,@contactType,@locations);
	END

	IF(@Opt = 1)
	BEGIN
		SELECT DISTINCT
		CAST(SP.item AS BIGINT) Id,
		PVL.PvlLocationCode PPPVendorLocationCode,
		VCL.VdcLocationCode VendorDcLocationCode
		FROM PRGRM051VendorLocations  PVL
		INNER JOIN VEND040DCLocations VCL ON VCL.Id = PVL.VendDCLocationId
		INNER JOIN fnSplitString(
		(SELECT VLP.VdcLocationCode FROM SYSTM000VdcLocationPreferences  VLP
		WHERE VLP.UserId = @userId
		AND VLP.OrganizationId = @orgId 
		AND VLP.LangCode = @langCode 
		AND VLP.ContactType = @contactType)
		, ',') SP
		ON SP.item = PVL.VendDCLocationId WHERE PVL.StatusId = 1
	END
	ELSE
	BEGIN
		SELECT usys.[VdcLocationCode] 
		FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys 
		WHERE usys.UserId = @userId 
		AND usys.OrganizationId = @orgId 
		AND usys.LangCode = @langCode 
		AND usys.ContactType = @contactType
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
