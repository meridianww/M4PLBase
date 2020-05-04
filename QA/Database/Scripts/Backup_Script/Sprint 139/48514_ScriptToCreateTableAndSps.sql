



GO
CREATE TABLE [dbo].[SYSTM000VdcLocationPreferences] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [OrganizationId] BIGINT         NOT NULL,
    [UserId]         BIGINT         NOT NULL,
    [ContactType]    INT            NOT NULL,
    [LangCode]       NVARCHAR (10)  NULL,
    [VdcLocationCode]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_[SYSTM000VdcLocationPreferences] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FK_SYSTM000VdcLocationPreferences_ORGAN000Master]...';


GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH NOCHECK
    ADD CONSTRAINT [FK_SYSTM000VdcLocationPreferences_ORGAN000Master] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[ORGAN000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_SYSTM000VdcLocationPreferences_SYSTM000OpnSezMe]...';


GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH NOCHECK
    ADD CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000OpnSezMe] FOREIGN KEY ([UserId]) REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id]);


GO
PRINT N'Creating [dbo].[FK_SYSTM000VdcLocationPreferences_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH NOCHECK
    ADD CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000Ref_Options] FOREIGN KEY ([ContactType]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[AddorEditPreferedLocations]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        

-- =============================================
CREATE PROCEDURE [dbo].[AddorEditPreferedLocations]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@contactType INT,
	@locations NVARCHAR(MAX) = NULL
AS
BEGIN TRY                
  SET NOCOUNT ON; 
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@contactType,'')<>'')
    BEGIN 
	IF EXISTS ( select top 1 1 from [SYSTM000VdcLocationPreferences] where  UserId =  @userId and OrganizationId = @orgId and LangCode = @langCode )
		BEGIN 
		 UPDATE [dbo].[SYSTM000VdcLocationPreferences]
			SET [VdcLocationCode] = ISNULL(@locations, '')
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
PRINT N'Creating [dbo].[GetPreferedLocations]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        

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
PRINT N'Creating [dbo].[GetUserContactType]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        

-- =============================================
CREATE PROCEDURE [dbo].[GetUserContactType]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@roleId BIGINT
	AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE  @locationOld NVARCHAR(MAX) = NULL
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>''  AND ISNULL(@roleId,0)<>0)
    BEGIN   
	SELECT con.ConTypeId 
	  FROM [dbo].[SYSTM000OpnSezMe] AS sez  
  INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.[Id]  
  INNER JOIN [dbo].[ORGAN000Master] org ON sez.[SysOrgId] = org.Id  
  INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sez.[SysOrgRefRoleId] = refRole.Id  
    WHERE  sez.[Id]  = @userId AND  org.Id   = @orgId AND refRole.Id   = @roleId;
	END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Checking existing data against newly created constraints';



GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH CHECK CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_ORGAN000Master];

ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH CHECK CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000OpnSezMe];

ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] WITH CHECK CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000Ref_Options];


GO
PRINT N'Update complete.';


GO
