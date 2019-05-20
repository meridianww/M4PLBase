-- =============================================        
-- Author       : Akhil         
-- Create date  : 04/27/2018  
-- Description  : Get user table by user Name  
-- Modified Date:        
-- Modified By  :        
-- Modified Desc:        
-- =============================================       
      
ALTER FUNCTION [dbo].[fnGetUserTableByName]      
(          
     @Username VARCHAR(100)   
)      
RETURNS  @userTable TABLE(        
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
  
AS      
BEGIN      
 INSERT INTO @userTable   
  SELECT   
  sez.[Id] as [UserId]  
  ,sez.SysScreenName as Username  
  ,up.[Password] as [Password]  
  ,con.[Id] as [ContactId]  
  ,con.[ConFullName] as [FullName]  
  ,sez.[SysOrgRefRoleId] as RoleId
  ,refRole.OrgRoleCode as RoleCode 
  ,refRole.StatusId as RoleStatusId
  ,sez.IsSysAdmin as [IsSysAdmin]   
  ,ISNULL(con.[ConOutlookId], '') as [OutlookId]  
  ,ISNULL(con.[ConERPId], '') as [ERPId]  
  ,sez.[SysOrgId] as [OrganizationId]  
  ,org.[OrgCode] as [OrganizationCode]  
  ,org.[OrgTitle] as [OrganizationName]  
  ,org.[StatusId] as [OrgStatusId]  
  ,ISNULL(con.[ConBusinessPhone], '') as BusinessPhone  
  ,ISNULL(con.[ConMobilePhone], '') as MobilePhone  
  ,ISNULL(con.[ConEmailAddress], '') as EmailAddress  
  ,CAST(up.[UpdatedTimestamp] AS BIGINT) as [PasswordTimestamp]   
  ,'EN' as UserCulture   
  ,sez.StatusId  
  ,'' as [SystemMessage] 
   
  FROM [dbo].[SYSTM000OpnSezMe] AS sez  
  INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.[Id]  
  INNER JOIN [dbo].[ORGAN000Master] org ON sez.[SysOrgId] = org.Id  
  INNER JOIN [dbo].[ORGAN010Ref_Roles] refRole ON sez.[SysOrgRefRoleId] = refRole.Id  
  INNER JOIN [Security].[AUTH050_UserPassword] AS up ON sez.Id = up.UserId  
  WHERE (sez.SysScreenName = @Username  OR con.ConMobilePhone = @Username OR con.ConEmailAddress2 = @Username)   
  
  IF NOT EXISTS (SELECT TOP 1 1 FROM @userTable)  
   BEGIN  
   INSERT INTO @userTable   
    SELECT   
     0 as [UserId]  
    ,'' as Username  
    ,'' as [Password]  
    ,0 as [ContactId]  
    ,'' as [FullName]  
    ,0 as RoleId  
    ,'' as RoleCode 
	,0 as  RoleStatusId
    ,0  
    ,'' as [OutlookId]  
    ,'' as [ERPId]  
    ,0 as [OrganizationId]  
    ,'' as [OrganizationCode]  
    ,'' as [OrganizationName]  
    ,2  
    ,'' as BusinessPhone  
    ,'' as MobilePhone  
    ,'' as EmailAddress  
    ,0 as [PasswordTimestamp]   
    ,'EN' as UserCulture   
    ,3  
    ,SysMessageDescription  
    FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = '07.01' AND LangCode ='EN' -- This Message code should be present and message for Account not exist  
   END 
   ELSE
   BEGIN
    UPDATE ut SET ut.UserCulture = us.LangCode
	FROM @userTable ut 
	INNER JOIN [dbo].[SYSTM000Ref_UserSettings] us ON ut.UserId = us.UserId
   END 
  
 RETURN      
END