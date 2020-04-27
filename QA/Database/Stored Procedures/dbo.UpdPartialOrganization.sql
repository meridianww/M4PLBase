SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a organization
-- Execution:                 EXEC [dbo].[UpdOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:               05/02/2019(Nikhil) 
-- Modified Desc:			  Removed #M4PL# and -100  implementation for Update Query
-- =============================================

CREATE PROCEDURE UpdPartialOrganization
@userId BIGINT
,@roleId BIGINT
,@entity NVARCHAR(100)
,@id BIGINT
,@orgCode NVARCHAR(25) = NULL
,@orgTitle NVARCHAR(50) = NULL
,@orgGroupId INT = NULL
,@orgSortOrder INT = NULL
,@statusId INT = NULL
,@orgContactId BIGINT = NULL
,@dateChanged DATETIME2(7) = NULL
,@changedBy NVARCHAR(50) = NULL
,@isFormView BIT = 0
AS
BEGIN


	DECLARE @CompanyId BIGINT
	DECLARE @where NVARCHAR(MAX) = NULL
	DECLARE @isSysAdmin BIT

	SELECT @isSysAdmin = IsSysAdmin
	FROM SYSTM000OpnSezMe
	WHERE id = @userId;

	SELECT @CompanyId = Id
	FROM [dbo].[COMP000Master]
	WHERE [CompTableName] = @entity
		AND [CompPrimaryRecordId] = @Id

   	UPDATE [dbo].[ORGAN000Master]
	SET OrgCode = ISNULL(@orgCode, OrgCode)
		,OrgTitle = ISNULL(@orgTitle, OrgTitle)
		,OrgGroupId = ISNULL(@orgGroupId, OrgGroupId)
		,StatusId = ISNULL(@statusId, StatusId)
		,OrgContactId = ISNULL(@orgContactId, OrgContactId)
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
	 WHERE Id = @id

	 UPDATE [dbo].[COMP000Master]
	SET [CompOrgId] = @id
		,[CompCode] = @orgCode
		,[CompTitle] = @orgTitle
		,[StatusId] = @StatusId
		,DateChanged = GETUTCDATE()
		,ChangedBy = @changedBy
	WHERE ID = @CompanyId

	EXEC [dbo].[GetOrganization] @userId
		,@roleId
		,@id
		,@id
END