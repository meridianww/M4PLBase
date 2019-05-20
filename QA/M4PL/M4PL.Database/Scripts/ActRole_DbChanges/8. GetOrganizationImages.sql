/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               04/24/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[GetOrganizationImages] 1
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER  PROCEDURE [dbo].[GetOrganizationImages]
(
@userId BIGINT
)
AS
BEGIN

    DECLARE  @userIcon varbinary(max)  =NULL ,@contactId  BIGINT;
	
	SELECT
		@contactId = con.[Id] 
		,@userIcon =con.ConImage 
	FROM [dbo].[SYSTM000OpnSezMe] AS sez
	INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
	INNER JOIN [Security].[AUTH050_UserPassword] AS up ON sez.Id = up.UserId
	WHERE sez.[Id] = @userId 
	
	IF EXISTS (SELECT Id FROM [SYSTM000OpnSezMe] WHERE Id=@userId AND IsSysAdmin =1)
	BEGIN
			SELECT  Id as OrganizationId
			   ,OrgCode as OrganizationCode
			  ,OrgImage as OrganizationImage
		FROM [dbo].[ORGAN000Master] 
	END
	ELSE
	BEGIN
	  SELECT refRole.OrgId as OrganizationId
		  ,org.OrgImage as OrganizationImage
		  ,OrgCode as OrganizationCode
	FROM [dbo].[ORGAN010Ref_Roles] refRole
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = refRole.OrgId
	INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = refRole.Id AND cb.ConTableName = [dbo].fnGetEntityName(1)
	WHERE cb.[ContactMSTRID] = @contactId 
	END
END;
GO

