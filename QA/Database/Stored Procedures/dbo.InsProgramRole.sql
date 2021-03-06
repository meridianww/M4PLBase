SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Role
-- Execution:                 EXEC [dbo].[InsProgramRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsProgramRole]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId bigint
	,@programId bigint
	,@prgRoleSortOrder int
	,@orgRoleId BIGINT
	,@prgRoleId BIGINT
	,@prgRoleCode nvarchar(25)
	,@prgRoleTitle nvarchar(50)
	,@prgRoleContactId bigint
	,@roleTypeId int
	,@statusId int
	,@prxJobDefaultAnalyst BIT  =NULL
	,@prxJobDefaultResponsible BIT  =NULL
	,@prxJobGWDefaultAnalyst BIT  =NULL
	,@prxJobGWDefaultResponsible BIT  =NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   IF NOT EXISTS(SELECT Id  FROM PRGRM020_Roles WHERE ProgramID =@programId AND PrgRoleCode = @prgRoleCode) AND ISNULL(@prgRoleId,0) = 0
  BEGIN
     INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)
	 VALUES(@orgId,@programId,@prgRoleCode,@prgRoleTitle,ISNULL(@statusId,1),@dateEntered,@enteredBy)

	 SET @prgRoleId = SCOPE_IDENTITY();
  END
  ELSE IF @prgRoleId > 0
  BEGIN
    UPDATE PRGRM020_Roles SET PrgRoleCode =@prgRoleCode WHERE Id =@prgRoleId AND ProgramID =@programId 
  END

  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM020Program_Role]
           ( [OrgID]
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
			,[EnteredBy])
     VALUES
           (@orgID
		   	,@programID
		   	,@updatedItemNumber
		   	,@orgRoleId
		   	,@prgRoleId
		   	,@prgRoleTitle
			,@prgRoleContactID
			,@roleTypeId
			,@statusId
			,@prxJobDefaultAnalyst 
		    ,@prxJobDefaultResponsible 
		    ,@prxJobGWDefaultAnalyst 
		    ,@prxJobGWDefaultResponsible 
			,@dateEntered
			,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM020Program_Role] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
