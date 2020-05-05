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
	@locations NVARCHAR(MAX)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@contactType,'')<>'')
    BEGIN   
	DECLARE  @locationOld NVARCHAR(MAX) = NULL
	SELECT @locationOld = usys.[VdcLocationCode] 
	FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys where usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode AND usys.ContactType = @contactType

	IF(ISNULL(@locationOld,'')<>'' )
	BEGIN
	 UPDATE [dbo].[SYSTM000VdcLocationPreferences]
	SET [VdcLocationCode] = ISNULL(@locations, @locationOld)
	 WHERE UserId=@userId AND OrganizationId=@orgId AND LangCode = @langCode AND ContactType  = @contactType

	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[SYSTM000VdcLocationPreferences](OrganizationId, UserId, LangCode, ContactType, VdcLocationCode) 
	VALUES(@orgId, @userId, @langCode,@contactType,@locations);
	END
SELECT usys.[VdcLocationCode] 
	FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys where usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode AND usys.ContactType = @contactType
	
	END
	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
