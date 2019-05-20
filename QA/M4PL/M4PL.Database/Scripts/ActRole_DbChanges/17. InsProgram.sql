/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/06/2018              
-- Description:               Ins a program         
-- Execution:                 EXEC [dbo].[InsProgram]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:          
-- =============================================        
        
ALTER PROCEDURE  [dbo].[InsProgram]        
	(@userId BIGINT        
	,@roleId BIGINT 
	,@entity NVARCHAR(100)        
	,@prgOrgId bigint        
	,@prgCustId bigint        
	,@prgItemNumber nvarchar(20)        
	,@prgProgramCode nvarchar(20)        
	,@prgProjectCode nvarchar(20)        
	,@prgPhaseCode nvarchar(20)        
	,@prgProgramTitle nvarchar(50)        
	,@prgAccountCode nvarchar(50)  
	,@delEarliest decimal(18,2) = NULL  
	,@delLatest decimal(18,2) = NULL  
	,@delDay BIT = NULL  
	,@pckEarliest decimal(18,2)  = NULL  
	,@pckLatest decimal(18,2) = NULL  
	,@pckDay BIT  = NULL  
	,@statusId INT        
	,@prgDateStart datetime2(7)        
	,@prgDateEnd datetime2(7)        
	,@prgDeliveryTimeDefault datetime2(7)        
	,@prgPickUpTimeDefault datetime2(7)        
	,@dateEntered datetime2(7)        
	,@enteredBy nvarchar(50)         
	,@parentId bigint =NULL)        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;          
 DECLARE @currentId BIGINT;        
          
IF ISNULL(@parentId,0) = 0        
BEGIN        
 INSERT INTO [dbo].[PRGRM000Master]        
           ([PrgOrgId]          
           ,[PrgCustId]          
           ,[PrgItemNumber]          
           ,[PrgProgramCode]          
           ,[PrgProjectCode]          
           ,[PrgPhaseCode]          
           ,[PrgProgramTitle]          
           ,[PrgAccountCode]   
     ,[DelEarliest]   
     ,[DelLatest]   
     ,[DelDay]   
     ,[PckEarliest]   
     ,[PckLatest]   
     ,[PckDay]          
           ,[StatusId]          
           ,[PrgDateStart]          
           ,[PrgDateEnd]          
           ,[PrgDeliveryTimeDefault]          
           ,[PrgPickUpTimeDefault]          
           ,[PrgHierarchyID]          
           ,[DateEntered]          
           ,[EnteredBy])        
     VALUES        
           (@prgOrgId          
           ,@prgCustId          
           ,@prgItemNumber          
           ,@prgProgramCode          
           ,@prgProjectCode          
           ,@prgPhaseCode          
           ,@prgProgramTitle          
           ,@prgAccountCode   
     ,@delEarliest  
     ,@delLatest  
     ,@delDay  
     ,@pckEarliest  
     ,@pckLatest  
     ,@pckDay  
           ,@statusId          
           ,@prgDateStart          
           ,@prgDateEnd          
           ,@prgDeliveryTimeDefault          
           ,@prgPickUpTimeDefault          
           ,hierarchyid::GetRoot().GetDescendant((select MAX(PrgHierarchyID) from [dbo].[PRGRM000Master]  where PrgHierarchyID.GetAncestor(1) = hierarchyid::GetRoot()),NULL)          
           ,@dateEntered          
           ,@enteredBy)         
     SET @currentId = SCOPE_IDENTITY();        
 --SELECT * FROM [dbo].[PRGRM000Master] WHERE Id = @currentId;        
        
END        
ELSE          
 BEGIN            
    DECLARE @parentNode hierarchyid, @lc hierarchyid            
    SELECT @parentNode = [PrgHierarchyID]            
    FROM  [dbo].[PRGRM000Master]            
    WHERE Id = @parentId            
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE            
    BEGIN TRANSACTION            
    SELECT @lc = max(PrgHierarchyID)             
    FROM   [dbo].[PRGRM000Master]           
    WHERE PrgHierarchyID.GetAncestor(1)  =@parentNode ;            
          
    INSERT INTO [dbo].[PRGRM000Master]        
           ([PrgOrgId]          
           ,[PrgCustId]          
           ,[PrgItemNumber]          
           ,[PrgProgramCode]          
           ,[PrgProjectCode]          
           ,[PrgPhaseCode]          
           ,[PrgProgramTitle]          
           ,[PrgAccountCode]    
     ,[DelEarliest]   
     ,[DelLatest]   
     ,[DelDay]   
     ,[PckEarliest]   
     ,[PckLatest]   
     ,[PckDay]             
           ,[StatusId]          
           ,[PrgDateStart]          
           ,[PrgDateEnd]          
           ,[PrgDeliveryTimeDefault]          
           ,[PrgPickUpTimeDefault]          
           ,[PrgHierarchyID]          
           ,[DateEntered]          
           ,[EnteredBy])        
     VALUES        
           (@prgOrgId          
           ,@prgCustId          
           ,@prgItemNumber          
           ,@prgProgramCode          
           ,@prgProjectCode          
     ,@prgPhaseCode          
           ,@prgProgramTitle          
           ,@prgAccountCode          
     ,@delEarliest  
     ,@delLatest  
     ,@delDay  
     ,@pckEarliest  
     ,@pckLatest  
     ,@pckDay  
           ,@statusId          
           ,@prgDateStart          
           ,@prgDateEnd          
           ,@prgDeliveryTimeDefault          
           ,@prgPickUpTimeDefault          
           ,@parentNode.GetDescendant(@lc, NULL)          
           ,@dateEntered          
           ,@enteredBy)         
        
      SET @currentId = SCOPE_IDENTITY();        
        
        
          
        
  COMMIT           
END         
        

 IF @parentId > 0  
 BEGIN  
     EXEC CopyProgramGatewaysAndAttributesFromParent  @userId,@roleId,@prgOrgId,@currentId,@parentId,@dateEntered,@enteredBy;  
 END  
   
       
        
 SELECT prg.[Id]              
  ,prg.[PrgOrgID]              
  ,prg.[PrgCustID]              
  ,prg.[PrgItemNumber]              
  ,prg.[PrgProgramCode]              
  ,prg.[PrgProjectCode]              
  ,prg.[PrgPhaseCode]              
  ,prg.[PrgProgramTitle]              
  ,prg.[PrgAccountCode]   
  ,prg.[DelEarliest]   
  ,prg.[DelLatest]   
  ,prg.[DelDay]   
  ,prg.[PckEarliest]   
  ,prg.[PckLatest]   
  ,prg.[PckDay]              
  ,prg.[StatusId]              
  ,prg.[PrgDateStart]              
  ,prg.[PrgDateEnd]              
  ,prg.[PrgDeliveryTimeDefault]              
  ,prg.[PrgPickUpTimeDefault]              
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID               
  ,prg.[PrgHierarchyLevel]              
  ,prg.[DateEntered]              
  ,prg.[EnteredBy]              
  ,prg.[DateChanged]              
  ,prg.[ChangedBy]              
  FROM   [dbo].[PRGRM000Master] prg              
  WHERE Id = @currentId;        
        
        
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
