SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               15/07/2019      
-- Description:               Copy Program  Role Contacts to respective  Project and Phase
-- Execution:                 EXEC [dbo].[CopyPPPRoleContacts]
-- =============================================
CREATE PROCEDURE [dbo].[CopyPPPRoleContacts] (
	@currentprogramId BIGINT
	,@parentId BIGINT
	,@userId BIGINT
	,@entity NVARCHAR(100)
	,@prgRoleSortOrder INT
	,@statusId INT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
	--Not Using it but in future we may need it when copied one by one basis and  need to calculate item number.
	--EXEC [dbo].[ResetItemNumber] @userId, 0, @currentprogramId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
	DECLARE @currentId BIGINT;

	INSERT INTO [dbo].[PRGRM020Program_Role] (
		[OrgID]
		,[ProgramID]
		,[PrgRoleSortOrder]
		,[OrgRefRoleId]
		,[PrgRoleId]
		,[PrgRoleTitle]
		,[PrgRoleContactID]
		,[RoleTypeId]
		,[StatusId]
		,[PrxJobDefaultAnalyst]
		,[PrxJobDefaultResponsible]
		,[PrxJobGWDefaultAnalyst]
		,[PrxJobGWDefaultResponsible]
		,[DateEntered]
		,[EnteredBy]
		)
	SELECT [OrgID]
		,@currentprogramId
		,[PrgRoleSortOrder]
		,[OrgRefRoleId]
		,[PrgRoleId]
		,[PrgRoleTitle]
		,[PrgRoleContactID]
		,[RoleTypeId]
		,[StatusId]
		,[PrxJobDefaultAnalyst]
		,[PrxJobDefaultResponsible]
		,[PrxJobGWDefaultAnalyst]
		,[PrxJobGWDefaultResponsible]
		,[DateEntered]
		,[EnteredBy]
	FROM [PRGRM020Program_Role]
	WHERE [ProgramID] = @parentId
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
