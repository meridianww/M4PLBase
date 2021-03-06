SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
                            
CREATE  PROCEDURE [dbo].[CopyPPPModel] --  1,'26',4,'Jana',1
 @recordId BIGINT,      
 @configurationIds NVARCHAR(MAX) = NULL,  -- comma seperated tab pagename ids          
 @toPPPIds NVARCHAR(MAX) = NULL,   -- comma seperated program Ids         
 @createdBy NVARCHAR(50),  
 @OrgId BIGINT  
AS                                
BEGIN TRY                                
     
 --DECLARE  @toPPPIds NVARCHAR(MAX) = '1,2,3,4'  
   
--DECLARE    @recordId BIGINT =1   
-- DECLARE @configurationIds NVARCHAR(MAX) = '26'  -- comma seperated tab pagename ids          
-- DECLARE @toPPPIds NVARCHAR(MAX) = '3'   -- comma seperated program Ids         
-- DECLARE @createdBy NVARCHAR(50)='Simondekker'  
-- DECLARE @OrgId BIGINT   =1
   
            
 DECLARE @PPPIdTables TABLE(  
       PrimaryId INT PRIMARY KEY IDENTITY(1,1)  
   ,Id BIGINT  
 );  
  
 INSERT INTO @PPPIdTables(Id)  
 SELECT item FROM [dbo].[fnSplitString](@toPPPIds,',');  
  
 
  
 DECLARE @HierarchyLevel INT  
 SELECT @HierarchyLevel = PrgHierarchyLevel FROM PRGRM000Master Where Id = @recordId;  
  
 DECLARE @pId INT =1  
 IF @HierarchyLevel= 1  
 BEGIN  
    DECLARE @custId BIGINT  
 SELECT @custId = Id FROM @PPPIdTables Where PrimaryId = @pId;  
  
    While(@custId IS NOT NULL)  
 BEGIN  
  
  DECLARE @ProgramCode NVARCHAR(50)  
  SELECT @ProgramCode =  PrgProgramCode+'_Copy' FROM PRGRM000Master WHERE Id = @recordId   
  WHILE (EXISTS(SELECT * FROM PRGRM000Master Where PrgCustID = @custId AND PrgProgramCode = @ProgramCode ))   
  BEGIN  
     IF LEN(@ProgramCode) < 25
	 BEGIN
       SET @ProgramCode = @ProgramCode+'_Copy';  
	 END
  END  
      
  DECLARE @newProgramId BIGINT;  
  
  INSERT INTO PRGRM000Master(  
    [PrgOrgID]  
      ,[PrgCustID]  
      ,[PrgProgramCode]  
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
      ,[PrgDescription]  
      ,[PrgNotes]  
      ,[DateEntered]  
      ,[EnteredBy]
	  ,PrgHierarchyID  
  )  
  
  SELECT   
       @OrgId  
      ,@custId  
      ,@ProgramCode  
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
      ,[PrgDescription]  
      ,[PrgNotes]  
      ,GETUTCDATE()  
      ,@createdBy  
	  ,hierarchyid::GetRoot().GetDescendant((select MAX(PrgHierarchyID) from [dbo].[PRGRM000Master]  where PrgHierarchyID.GetAncestor(1) = hierarchyid::GetRoot()),NULL) 
  FROM PRGRM000Master  
     WHERE Id = @recordId  ;  
  
  SET @pId = @pId + 1;  
  SET @custId = NULL;
  SELECT @custId = Id FROM @PPPIdTables Where PrimaryId = @pId;  
  
  
  SET @newProgramId = SCOPE_IDENTITY();  
  
  IF LEN(ISNULL(@configurationIds,'')) > 0  
  BEGIN  
   
    EXEC CopyPPPModelTabs @recordId,@newProgramId,@configurationIds,@createdBy  
  
  END  
  
  
  
 END  
  
 END  
 ELSE  
 BEGIN  
    DECLARE @programParentId BIGINT  
 DECLARE @customerID BIGINT  
 SELECT @programParentId = Id   FROM @PPPIdTables Where PrimaryId = @pId;  
   
    While(@programParentId IS NOT NULL)  
 BEGIN  
  
  --DECLARE @PPCode NVARCHAR(50)  
  --SELECT @PPCode = CASE when PrgHierarchyLevel  = 2 THEN  PrgProjectCode+'_Copy'  
  --                      when PrgHierarchyLevel  = 3 THEN  PrgPhaseCode +'_Copy' END   
  --          ,@customerID = PrgCustID  
  --       FROM PRGRM000Master WHERE Id = @recordId   
  --WHILE (EXISTS(SELECT * FROM PRGRM000Master Where PrgCustID = @custId AND PrgProjectCode = @PPCode ))   
  --BEGIN  
  --   SET @PPCode = @PPCode+'_Copy';  
  --END  
      
  INSERT INTO PRGRM000Master(  
    [PrgOrgID]  
      ,[PrgCustID]  
      ,[PrgProgramCode]  
   ,PrgProjectCode  
   ,PrgPhaseCode  
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
      ,[PrgDescription]  
      ,[PrgNotes]  
      ,[DateEntered]  
      ,[EnteredBy]  
  )  
  
  SELECT   
       @OrgId  
      ,PrgCustID  
      ,[PrgProgramCode] +'_Copy'  
   ,[PrgProjectCode]+'_Copy'  
   ,[PrgPhaseCode]+'_Copy'  
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
      ,[PrgDescription]  
      ,[PrgNotes]  
      ,GETUTCDATE()  
      ,@createdBy  
  FROM PRGRM000Master  
     WHERE Id = @recordId    
  
  SET @pId = @pId + 1;  
  SET @programParentId = NULL;
  SELECT @programParentId = Id FROM @PPPIdTables Where PrimaryId = @pId;  
  
 END  
     
 END  
  
  SELECT CAST(1 AS BIT);
  
  
          
       
              
END TRY                                
BEGIN CATCH                                
                                
  DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                          
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                          
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                          
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                             
                                
END CATCH
GO
