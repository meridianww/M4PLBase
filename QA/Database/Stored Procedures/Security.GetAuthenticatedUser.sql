SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/13/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[GetAuthenticatedUser]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[GetAuthenticatedUser]
(
@userId BIGINT
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
	
DECLARE  @currentContactId BIGINT, @displayName NVARCHAR(50);
Select @displayName = sez.SysScreenName, @currentContactId= sez.SysUserContactID  from [dbo].[SYSTM000OpnSezMe] sez where sez.Id = @userId

 INSERT INTO @userTable SELECT * FROM [dbo].[fnGetUserTableByName](@displayName)

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
    WHERE ulp.[UserId] = @userId

	EXECUTE [Security].[GetUserAuthTokenId] @displayName;
END;
GO
