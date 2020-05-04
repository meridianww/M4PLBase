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
-- Modified Desc:   exec dbo.GetPreferedLocations @userId=2,@roleId=14,@conOrgId=1,@langCode=N'EN',@contactType=62
-- =============================================
CREATE PROCEDURE [dbo].[GetPreferedLocations]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@conTypeId INT,
	@roleId BIGINT
	AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE  @locationOld NVARCHAR(MAX) = NULL
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@conTypeId,'')<>'')
    BEGIN   
	SELECT @locationOld = usys.[VdcLocationCode] 
	FROM [dbo].[SYSTM000VdcLocationPreferences] (NOLOCK) usys where usys.UserId=@userId AND usys.LangCode = @langCode AND usys.ContactType = @conTypeId AND usys.OrganizationId = @orgId
	END
	
	SELECT  @locationOld AS preferedlocations
	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
