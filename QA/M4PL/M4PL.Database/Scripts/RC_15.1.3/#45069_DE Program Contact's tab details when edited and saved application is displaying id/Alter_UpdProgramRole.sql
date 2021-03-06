SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Role
-- Execution:                 EXEC [dbo].[UpdProgramRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgramRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@programId bigint = NULL
	,@prgRoleSortOrder int = NULL
	,@orgRoleId BIGINT = NULL
	,@prgRoleid BIGINT = NULL
	,@prgRoleCode nvarchar(25) = NULL
	,@prgRoleTitle nvarchar(50) = NULL
	,@prgRoleContactId bigint = NULL
	,@roleTypeId int = NULL
	,@statusId int = NULL
	,@prxJobDefaultAnalyst BIT  =NULL
	,@prxJobDefaultResponsible BIT  =NULL
	,@prxJobGWDefaultAnalyst BIT  =NULL
	,@prxJobGWDefaultResponsible BIT  =NULL

	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 PRINT @updatedItemNumber
  IF @prgRoleid > 0
  BEGIN
    UPDATE PRGRM020_Roles SET PrgRoleCode = @prgRoleCode WHERE Id =@prgRoleid AND ProgramID = @programId
  END

 IF NOT EXISTS(SELECT Id  FROM PRGRM020_Roles WHERE ProgramID =@programId AND PrgRoleCode = @prgRoleCode) AND ISNULL(@prgRoleid,0) = 0 AND @prgRoleCode IS NOT NULL
  BEGIN
     INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)
	 VALUES (@orgId,@programId,@prgRoleCode,@prgRoleTitle,ISNULL(@statusId,1),@dateChanged,@changedBy)

	 SET @prgRoleid = SCOPE_IDENTITY();
  END

   
 UPDATE [dbo].[PRGRM020Program_Role]
		SET  [OrgID]                 = ISNULL(@orgID, OrgID)
			,[ProgramID]             = ISNULL(@programID, ProgramID)
			,[PrgRoleSortOrder]      = ISNULL(@updatedItemNumber, PrgRoleSortOrder)
			,[OrgRefRoleId]			 = ISNULL(@orgRoleId, [OrgRefRoleId])
			,[PrgRoleId]			 = ISNULL(@prgRoleId, PrgRoleId)
			,[PrgRoleTitle]          = ISNULL(@prgRoleTitle, PrgRoleTitle)
			,[PrgRoleContactID]      = ISNULL(@prgRoleContactID, PrgRoleContactID)
			,[RoleTypeId]            = ISNULL(@roleTypeId, RoleTypeId)
			,[StatusId]				 = ISNULL(@statusId, StatusId)
            ,[PrxJobDefaultAnalyst]		    = ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)  
		    ,[PrxJobDefaultResponsible]  	= ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)  
            ,[PrxJobGWDefaultAnalyst]		= ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)  
            ,[PrxJobGWDefaultResponsible]   = ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)     

			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[OrgID]
		,prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,prg.[OrgRefRoleId]
		,prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,prg.[PrgRoleContactID]
		,prg.[RoleTypeId]
		,prg.[PrxJobDefaultAnalyst]
		,prg.[PrxJobDefaultResponsible]
		,prg.[PrxJobGWDefaultAnalyst]
		,prg.[PrxJobGWDefaultResponsible]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Program_Role] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH