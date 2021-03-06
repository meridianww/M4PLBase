SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Janardana Behara                 
-- Create date:               06/06/2018              
-- Description:               Copy ActRole On ProgramCreate    
-- Execution:                 EXEC [dbo].[CopyActRoleOnProgramCreate]        
-- Modified on:          
-- Modified Desc:          
-- =============================================        
        
ALTER  PROCEDURE  [dbo].[CopyActRoleOnProgramCreate]        
		(@userId BIGINT        
		,@roleId BIGINT        
		,@orgId bigint        
		,@custId bigint      
		,@programId bigint      
		,@dateEntered datetime2(7)        
		,@enteredBy nvarchar(50)         
		)        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;          
       
        
 DECLARE @hierarchyLevel INT        
 SELECT  @hierarchyLevel = PrgHierarchyLevel FROM  [dbo].[PRGRM000Master]   WHERE Id = @programId;        
        
        
  --Insert Into Customer Contacts    When program Created and PPP is Opted in ActRoles      
  DECLARE @ccMaxNumber INT        
  SELECT @ccMaxNumber = MAX(ConItemNumber) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND StatusId In (1,2) AND ConTableName='CustContact'       
        
  INSERT INTO [dbo].[CONTC010Bridge]      
           ([ConOrgId]
		   ,[ConPrimaryRecordId] 
		   ,[ConTableName] 
		   ,[ConCodeId] 
		   ,[ConTableTypeId]
           ,[ConTypeId]    
           ,[ConItemNumber]                 
           ,[ContactMSTRID]      
           ,[StatusId]      
           ,[EnteredBy]      
           ,[DateEntered])        
SELECT @orgId,@custId,'CustContact',OrgRefRoleId,183,64,(ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@ccMaxNumber,0)),OrgRoleContactID,ISNULL(StatusId,1), @enteredBy,@dateEntered        
  from  [dbo].[ORGAN020Act_Roles]         
   WHERE(@hierarchyLevel = 1 OR @hierarchyLevel = 2 OR @hierarchyLevel = 3 OR PrxJobDefaultAnalyst = 1 OR PrxJobDefaultResponsible = 1    
           )        
    AND OrgID = @orgId      
    AND ISNULL(StatusId,1) = 1        
 AND OrgRoleContactID IS NOT NULL      
    AND OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');        
  
  -- Update Customer's Contact  Count after Customer Contact insertion
  UPDATE [dbo].[CUST000Master] SET CustContacts = (SELECT Count(Id) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact' AND StatusId in(1,2)) WHERE Id = @custId
      
 --Insert Into Program roles(Contacts tab) When PPP Logicals are checked in Reference Roles        
  DECLARE @rcMaxNumber INT        
  SELECT @rcMaxNumber = MAX(PrgRoleSortOrder) FROM [PRGRM020Program_Role] WHERE ProgramID = @programId AND StatusId In (1,2)        
      
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
  SELECT 
  @orgId
  ,@programId
  , ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@rcMaxNumber,0)
  ,[OrgRefRoleId]
  ,NUll
  ,NULL
  ,OrgRoleContactID
  ,RoleTypeId
  ,ISNULL(StatusId,1)  
  ,[PrxJobDefaultAnalyst]
  ,[PrxJobDefaultResponsible]
  ,[PrxJobGWDefaultAnalyst]
  ,[PrxJobGWDefaultResponsible]  
  ,@dateEntered
  ,@enteredBy         
  from  [dbo].[ORGAN020Act_Roles]        
   WHERE         
     ( @hierarchyLevel = 1  OR @hierarchyLevel = 2 OR @hierarchyLevel = 3 OR PrxJobDefaultAnalyst = 1 OR PrxJobDefaultResponsible = 1      
     )        
  AND OrgID = @orgId      
  AND OrgRoleContactID IS NOT NULL      
     AND ISNULL(StatusId,1) = 1      
     AND OrgRoleContactID NOT IN( SELECT PrgRoleContactID FROM PRGRM020Program_Role WHERE [ProgramID] = @programId);        
        
         
        
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
