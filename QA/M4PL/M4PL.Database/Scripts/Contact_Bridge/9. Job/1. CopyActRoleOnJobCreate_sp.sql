SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Janardana Behara               
-- Create date:               06/06/2018            
-- Description:               Copy ActRole On job Create  
-- Execution:                 EXEC [dbo].[CopyRefRoleOnProgramCreate]      
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M
-- =============================================      
      
ALTER PROCEDURE  [dbo].[CopyActRoleOnJobCreate]      
     (  @userId BIGINT      
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
     
      
      
  -- 1) Customer  Contacts 2) Vendor Contacts 3) Program Roles    
  -- 1) Insert Into Customer Contacts       
DECLARE @ccMaxNumber INT      
SELECT @ccMaxNumber = MAX(ConItemNumber) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND StatusId In (1,2) AND ConTableName='CustContact';      
      
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
SELECT @orgId,@custId,'CustContact',OrgRefRoleId,183,64,(ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@ccMaxNumber,0) ),OrgRoleContactID,ISNULL(StatusId,1),@enteredBy    , @dateEntered     
  from  [dbo].[ORGAN020Act_Roles]       
   WHERE  (PrxJobGWDefaultAnalyst = 1 OR PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(StatusId,1) = 1     
 AND OrgID = @orgId    
 AND OrgRoleContactID IS NOT NULL     
 AND OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');     
        
 -- 2) Insert into Vendor Contacts    
    
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
      
SELECT @orgId,@custId,'VendContact',ref.OrgRefRoleId,183,63,ROW_NUMBER() Over(Order By ref.OrgRoleSortOrder)  ,ref.OrgRoleContactID,ISNULL(ref.StatusId,1),@enteredBy  , @dateEntered       
        
  from  [dbo].[ORGAN020Act_Roles]  ref      
  INNER JOIN CONTC010Bridge vc On ref.OrgRoleContactID = vc.ContactMSTRID AND vc.ConTableName='CustContact'       
  INNER JOIN VEND000Master vm On vc.ConPrimaryRecordId = vm.Id    
  INNER JOIN PRGRM051VendorLocations pvl ON vm.id=pvl.PvlVendorID AND Pvl.PvlProgramID  = @programId      
   WHERE (ref.PrxJobGWDefaultAnalyst = 1 OR ref.PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(ref.StatusId,1) = 1      
 AND ref.OrgID = @orgId    
 AND ref.OrgRoleContactID IS NOT NULL     
    AND ref.OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');      
      
    
        
  DECLARE @roleMaxNumber INT      
  SELECT @roleMaxNumber = MAX(PrgRoleSortOrder) FROM [PRGRM020Program_Role] WHERE [ProgramID] = @programId AND StatusId In (1,2) ;    
      
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
  ,[DateEntered]      
  ,[EnteredBy]      
  )      
  SELECT @orgId ,@programId, ROW_NUMBER() Over(Order By OrgRoleSortOrder) + @roleMaxNumber,OrgRefRoleId,NUll,NULL,OrgRoleContactID,RoleTypeId,ISNULL(StatusId,1), @dateEntered  ,@enteredBy       
  from  [dbo].[ORGAN020Act_Roles]       
   WHERE  (PrxJobGWDefaultAnalyst = 1  OR PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(StatusId,1) = 1      
 AND OrgID = @orgId    
 AND OrgRoleContactID IS NOT NULL     
    AND OrgRoleContactID NOT IN( SELECT PrgRoleContactID FROM PRGRM020Program_Role WHERE [ProgramID] = @programId);      
      
       
      
END TRY               
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
