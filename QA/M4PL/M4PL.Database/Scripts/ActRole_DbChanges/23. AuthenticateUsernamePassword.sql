ALTER PROCEDURE [Security].[AuthenticateUsernamePassword]
(
	@Username VARCHAR(100)
   ,@Password VARCHAR(250)
   ,@OrganizationId BIGINT
)
AS
BEGIN
	DECLARE @userTable TABLE(      
		[UserId] BIGINT,  
		[Username] NVARCHAR(100),
		[Password] NVARCHAR(250), 
		[ContactId] BIGINT,    
		[FullName]NVARCHAR(51), 
		[RoleId] BIGINT,
		[RoleCode] NVARCHAR(25),
		[RoleStatusId] INT,   
		[IsSysAdmin] BIT, 
		[OutlookId] NVARCHAR(50),
		[ERPId] NVARCHAR(50),  
		[OrganizationId] BIGINT,
		[OrganizationCode] NVARCHAR(25),
		[OrganizationName] NVARCHAR(50),
		[OrgStatusId]  INT,
		[BusinessPhone] NVARCHAR(25),
		[MobilePhone] NVARCHAR(25),
		[EmailAddress] NVARCHAR(100), 
		[PasswordTimestamp] BIGINT, 
		[UserCulture] NVARCHAR(10),
		[StatusId] INT,
		[SystemMessage] NVARCHAR(255)
	)      

	INSERT INTO @userTable SELECT * FROM [dbo].[fnGetUserTableByName](@Username)

	DECLARE @langCode NVARCHAR(10), @currentUserId BIGINT, @currentContactId BIGINT, @currentOrganizationId BIGINT, @currentRefRoleId BIGINT, @currentSystemMessage NVARCHAR(255);
	 
	SELECT @langCode = UserCulture,  @currentUserId = UserId, @currentContactId = ContactId, @currentOrganizationId= OrganizationId, @currentRefRoleId= RoleId, @currentSystemMessage= [SystemMessage] FROM @userTable  

	 IF (@currentUserId > 0 AND ISNULL(@currentSystemMessage,'') = '')
 		BEGIN
 			IF((SELECT [Password] FROM @userTable) = @Password AND (SELECT StatusId FROM @userTable) = 1 AND (SELECT OrgStatusId FROM @userTable) = 1 AND (SELECT RoleStatusId FROM @userTable) = 1)
 				BEGIN
						IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr WHERE sbr.OrgRefRoleId = @currentRefRoleId)
						BEGIN
						UPDATE @userTable SET  UserId = 0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.05' AND LangCode =@langCode) -- No secure module assigned
						END
						ELSE
						BEGIN
							 UPDATE SYSTM000OpnSezMe SET 
 										SysAttempts = 0, 
 										SysLoggedIn = 1, 
 										SysLoggedInStart = GETUTCDATE()
 										WHERE Id = (SELECT UserId FROM @userTable);
						END
 				END
 		
 			ELSE 
 				BEGIN
 					UPDATE SYSTM000OpnSezMe SET 
 					SysAttempts = ISNULL(SysAttempts,0) + 1,
 					SysDateLastAttempt = GETUTCDATE()
 					WHERE Id =  (SELECT UserId FROM @userTable)
 				
 					IF((SELECT [Password] FROM @userTable) <> @Password)
 						BEGIN
 							UPDATE @userTable SET UserId = 0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.02' AND LangCode =@langCode) -- User name or password incorrect
 						END
 					ELSE IF((SELECT StatusId FROM @userTable) > 1)
 						BEGIN
 							UPDATE @userTable SET  UserId = 0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.03' AND LangCode =@langCode) -- account inactive or deleted
 						END
				
 					ELSE IF((SELECT OrgStatusId FROM @userTable) > 1)
 						BEGIN
 							UPDATE @userTable SET  UserId = 0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.04' AND LangCode =@langCode) -- organization inactive or deleted
 						END	
					ELSE IF((SELECT RoleStatusId FROM @userTable) > 1)
 						BEGIN
 							UPDATE @userTable SET  UserId = 0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.06' AND LangCode =@langCode) -- account role inactive or deleted
 						END			
 				END
 
	 END
  
	--User Info--- 
	SELECT * from @userTable;


	--Roles Info--- 
	IF((SELECT IsSysAdmin FROM @userTable) = 1) -- get all access 
		BEGIN
			SELECT  org.Id as OrganizationId
			,org.OrgCode as OrganizationCode
			,org.OrgTitle as OrganizationName
			,org.StatusId as OrgStatusId
			,refRole.OrgRoleCode as RoleCode
			,refRole.Id as RoleId
			FROM [dbo].[ORGAN000Master] org
			INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON refRole.OrgID = org.Id 
			WHERE ISNULL( org.StatusId, 0) < 3 AND ISNULL( refRole.StatusId, 0) < 3 AND refRole.OrgRoleCode = 'SYSADMIN'
		END
	ELSE
		BEGIN
			 SELECT  org.Id as OrganizationId
			,org.OrgCode as OrganizationCode
			,org.OrgTitle as OrganizationName
			,org.StatusId as OrgStatusId
			,refRole.OrgRoleCode as RoleCode
			,refRole.Id as RoleId
			FROM [dbo].[ORGAN000Master] org
			INNER JOIN [dbo].[CONTC010Bridge] cb ON org.Id = cb.ConOrgId
			INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON refRole.Id = cb.ConCodeId 
			WHERE ISNULL( org.StatusId, 0) < 3 AND cb.ContactMSTRID = @currentContactId AND ISNULL( refRole.StatusId, 0) < 3
		END

	-- Login Provider
	SELECT ulp.[LoginProvider]
		,ulp.[ProviderKey]
		,ulp.[UserId]
	FROM [Security].[AUTH030_LoginProvider] AS ulp
    WHERE ulp.[UserId] = (SELECT UserId FROM @userTable)

END
GO

