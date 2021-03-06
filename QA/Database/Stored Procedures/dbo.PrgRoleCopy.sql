SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/21/2018      
-- Description:               Copy the Program role to another role
-- Execution:                 EXEC [dbo].[PrgRoleCopy]   
-- Modified on:  
-- Modified Desc:  
-- =============================================        
    
  CREATE PROCEDURE [dbo].[PrgRoleCopy]    
  (    
    @programId BIGINT,    
 @enteredBy NVARCHAR(50),    
 @fromRecordId BIGINT ,
 @PacificDateTime DATETIME2(7)   
  )    
  AS     
  BEGIN TRY   
   SET NOCOUNT ON;     
       
       
    
  INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)    
  SELECT OrgID,@programId,PrgRoleCode,PrgRoleTitle,StatusId,@PacificDateTime,@enteredBy    
  FROM  PRGRM020_Roles WHERE  ProgramID = @fromRecordId    
                             AND PrgRoleCode NOT IN ( SELECT PrgRoleCode FROM PRGRM020_Roles WHERE ProgramID = @programId);    
    
    
    
        
         
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
    SELECT   [OrgID]    
   ,@programId    
   ,[PrgRoleSortOrder]    
   ,[OrgRefRoleId]    
   --,[PrgRoleId]    
   ,(SELECT Id FROM PRGRM020_Roles WHERE ProgramID = @programId AND PrgRoleCode = (SELECT PrgRoleCode FROM PRGRM020_Roles WHERE Id = PrgRoleId))    
   ,[PrgRoleTitle]    
   ,[PrgRoleContactID]    
   ,[RoleTypeId]    
   ,[StatusId]        
   ,[PrxJobDefaultAnalyst]    
   ,[PrxJobDefaultResponsible]    
   ,[PrxJobGWDefaultAnalyst]    
   ,[PrxJobGWDefaultResponsible]    
   ,@PacificDateTime    
   ,@enteredBy     
     FROM [dbo].[PRGRM020Program_Role]  WHERE ProgramId = @fromRecordId AND StatusId In(1,2)  ;  
END TRY
BEGIN CATCH                
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
