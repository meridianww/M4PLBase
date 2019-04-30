
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
		[OrgRefRoleId] BIGINT, 
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



 IF ((SELECT UserId FROM @userTable) > 0 )
 	BEGIN
	
 		IF((SELECT [Password] FROM @userTable) = @Password AND (SELECT StatusId FROM @userTable) = 1 AND (SELECT OrgStatusId FROM @userTable) = 1 AND (SELECT RoleStatusId FROM @userTable) = 1)
 			BEGIN
					IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) actSec WHERE actSec.OrgActRoleId = (SELECT RoleId FROM @userTable))
					BEGIN
					UPDATE @userTable SET  UserId=0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.05' AND LangCode =(SELECT UserCulture FROM @userTable)) -- No secure module assigned
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
 						UPDATE @userTable SET UserId=0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.02' AND LangCode =(SELECT UserCulture FROM @userTable)) -- User name or password incorrect
 					END
 				ELSE IF((SELECT StatusId FROM @userTable) > 1)
 					BEGIN
 						UPDATE @userTable SET  UserId=0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.03' AND LangCode =(SELECT UserCulture FROM @userTable)) -- account inactive or deleted
 					END
				
 				ELSE IF((SELECT OrgStatusId FROM @userTable) > 1)
 					BEGIN
 						UPDATE @userTable SET  UserId=0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.04' AND LangCode =(SELECT UserCulture FROM @userTable)) -- organization inactive or deleted
 					END	
				ELSE IF((SELECT RoleStatusId FROM @userTable) > 1)
 					BEGIN
 						UPDATE @userTable SET  UserId=0, SystemMessage = (SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.06' AND LangCode =(SELECT UserCulture FROM @userTable)) -- account role inactive or deleted
 					END			
 			END
 
 END
  
  DECLARE @currentOrganizationId BIGINT, @currentRefRoleId BIGINT;
   SELECT @currentOrganizationId= OrganizationId, @currentRefRoleId= OrgRefRoleId FROM @userTable  
		

  IF((SELECT IsSysAdmin FROM @userTable) = 1 AND ISNULL(@OrganizationId,0) > 0)
		BEGIN
			UPDATE @userTable SET OrganizationId = org.Id
			,OrganizationCode = org.OrgCode
			,OrganizationName = org.OrgTitle
			FROM ORGAN000Master org Where org.Id =@OrganizationId
	    END
	ELSE IF(ISNULL(@OrganizationId,0) > 0)
		BEGIN
			UPDATE @userTable SET OrganizationId = org.Id
			,OrganizationCode = org.OrgCode
			,OrganizationName = org.OrgTitle
			,RoleId = actRole.Id
			,RoleCode = refRole.OrgRoleCode
			FROM ORGAN000Master org 
			INNER JOIN [dbo].[ORGAN020Act_Roles] actRole ON actRole.OrgRoleContactID = (SELECT ContactId FROM @userTable) AND actRole.OrgID = org.Id AND actRole.OrgRefRoleId = (SELECT OrgRefRoleId FROM @userTable)
			INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON actRole.OrgRefRoleId = refRole.Id
			Where org.Id =@OrganizationId
	    END

	--User Info--- 
	SELECT * from @userTable;


	--Roles Info--- 
	IF((SELECT IsSysAdmin FROM @userTable) = 1)
		BEGIN
			 SELECT  org.Id as OrganizationId
			,org.OrgCode as OrganizationCode
			,org.OrgTitle as OrganizationName
			,org.StatusId as OrgStatusId
			,refRole.Id as OrgRefRoleId
			,refRole.OrgRoleCode as RoleCode
			,actRole.Id as RoleId
			from [dbo].[ORGAN000Master] org
			INNER JOIN [dbo].[ORGAN020Act_Roles] actRole ON actRole.OrgRoleContactID = (SELECT ContactId FROM @userTable) AND actRole.OrgID = @currentOrganizationId AND actRole.OrgRefRoleId = @currentRefRoleId
			INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON refRole.Id = actRole.OrgRefRoleId WHERE org.StatusId IN (1,2)
	   END
	ELSE
		BEGIN
			SELECT  org.Id as OrganizationId
			,org.OrgCode as OrganizationCode
			,org.OrgTitle as OrganizationName
			,org.StatusId as OrgStatusId
			,refRole.Id as OrgRefRoleId
			,refRole.OrgRoleCode as RoleCode
			,actRole.Id as RoleId
			from @userTable ut
			INNER JOIN [dbo].[ORGAN020Act_Roles] actRole ON actRole.OrgRoleContactID = ut.ContactId 
			INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON refRole.Id = actRole.OrgRefRoleId 
			INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = actRole.OrgID WHERE org.StatusId IN (1,2)
		END

	-- Login Provider
	SELECT ulp.[LoginProvider]
		,ulp.[ProviderKey]
		,ulp.[UserId]
	FROM [Security].[AUTH030_LoginProvider] AS ulp
    WHERE ulp.[UserId] = (SELECT UserId FROM @userTable)

END



