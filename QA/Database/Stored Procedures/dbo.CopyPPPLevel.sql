SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
CREATE PROCEDURE [dbo].[CopyPPPLevel]                  
(                  
 @recordId BIGINT,                  
 @custId BIGINT,                  
 @OrgId BIGINT,                  
 @configIds NVARCHAR(MAX),                  
 @createdBy NVARCHAR(50),                  
 @hierarchyId  HierarchyId,                   
 @copyAll BIT = 0,                  
 @targetIds NVARCHAR(MAX) = NULL ,                
 @langCode NVARCHAR(10) ='EN',                
 @userId BIGINT  ,          
 @UdtCopyPPPModel CopyPPPModel READONLY  ,   
 @PacificDateTime DATETIME2(7),
 @DestinationProgramCode NVARCHAR(20)=''  ,
 @DestinationProjectCode NVARCHAR(20)=''          
)                  
AS                  
BEGIN   TRY               
SET NOCOUNT ON;                  
     DECLARE @ProgramCode NVARCHAR(20), @OldProgramCode NVARCHAR(20) ,@copyCount INT  ,@RecHLevel INT                   
     SET @copyCount = 1                  
     SELECT @OldProgramCode =  CASE  PrgHierarchyLevel When 1 THEN PrgProgramCode            
             When 2 THEN PrgProjectCode           
             When 3 THEN PrgPhaseCode          
             END   
             
           ,@RecHLevel = PrgHierarchyLevel     
                                                             
  FROM PRGRM000Master WHERE Id = @recordId;         
    
  SET @ProgramCode = @OldProgramCode+'_Copy';  
            
  WHILE EXISTS (SELECT  CASE  @RecHLevel When 1 THEN PrgProgramCode             
             When 2 THEN PrgProjectCode            
             When 3 THEN PrgPhaseCode            
             END             
         FROM PRGRM000Master Where PrgCustID = @custId             
           AND (  (@RecHLevel = 1 AND PrgProgramCode = @ProgramCode) OR            
                  (@RecHLevel = 2 AND PrgProjectCode =@ProgramCode) OR            
            (@RecHLevel = 3 AND PrgPhaseCode = @ProgramCode)             
                                       ))                     
     BEGIN                   
        SET @ProgramCode = @OldProgramCode+'_Copy'+ CAST(@copyCount AS VARCHAR);                    
   IF LEN(@ProgramCode) = 20    
   BEGIN    
    BREAK;    
   END    
           SET @copyCount = (@copyCount + 1);   
     END                    
                        
     DECLARE @newProgramId BIGINT;                    
                      
     INSERT INTO PRGRM000Master([PrgOrgID],[PrgCustID],[PrgItemNumber],[PrgProgramCode],[PrgProjectCode],[PrgPhaseCode],[PrgProgramTitle],[PrgAccountCode],[DelEarliest],[DelLatest],[DelDay],[PckEarliest],[PckLatest],[PckDay],[StatusId]  ,[PrgDateStart]  ,
[PrgDateEnd],[PrgDeliveryTimeDefault],[PrgPickUpTimeDefault],[PrgDescription],[PrgNotes],[DateEntered]  ,[EnteredBy],PrgHierarchyID)                        
      SELECT                     
       @OrgId                  
      ,@custId    
   ,PrgItemNumber                
      ,CASE  WHEN @RecHLevel  = 1 THEN @ProgramCode   ELSE @DestinationProgramCode END            
   ,CASE  WHEN @RecHLevel  = 2 THEN @ProgramCode   ELSE @DestinationProjectCode END            
   ,CASE  WHEN @RecHLevel  = 3 THEN @ProgramCode   ELSE [PrgPhaseCode]   END              
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
      ,@PacificDateTime                    
      ,@createdBy                    
      ,@hierarchyId                   
    FROM PRGRM000Master                    
    WHERE Id = @recordId  ;                    
     SET @newProgramId = SCOPE_IDENTITY();       
        
      
	 
	  --UPDATE ITEM NUMBER  AFTER RECORD INSERT
	 DECLARE @newitemNumber NVARCHAR(20)
	 DECLARE @itemNumber NVARCHAR(20)
	
	 IF @RecHLevel = 1
	 BEGIN
		  SELECT @itemNumber =  MAX(PrgItemNumber)  FROM PRGRM000Master WHERE PrgCustID = @custId AND PrgHierarchyLevel = @RecHLevel  AND PrgItemNumber IS NOT NULL;
		  SET @newitemNumber = CAST(ISNULL(@itemNumber,0) AS INT) + 1;
	 END
	 IF @RecHLevel = 2
	 BEGIN

	      DECLARE @ParentHId hierarchyId ;
		  Declare @parentItemNumber NVARCHAR(100);
		  SELECT @ParentHId =  PrgHierarchyID.GetAncestor(1) FROM PRGRM000Master WHERE ID  = @newProgramId;
		  
		  SELECT @parentItemNumber =  PrgItemNumber  FROM  PRGRM000Master Where PrgHierarchyID = @ParentHId ;


		  DECLARE @nItemNumber NVARCHAR(50)
		  SELECT TOP 1  @nItemNumber = PrgItemNumber FROM PRGRM000Master
		  WHERE  PrgCustID = @custId 
		       AND PrgHierarchyLevel = @RecHLevel  
			   AND PrgItemNumber IS NOT NULL 
			   AND PrgHierarchyID.ToString() like @hierarchyId.ToString() + '%'
		  ORDER BY PrgItemNumber DESC

		  SELECT @nItemNumber = Item FROM (SELECT Item, ROW_NUMBER() OVER (ORDER BY Item) as RNO FROM  dbo.fnSplitString(@nItemNumber,'.'))  T  WHERE  T.RNO = @RecHLevel;

		  
		  SET @nItemNumber = CAST(ISNULL(@nItemNumber,0) AS INT) + 1 ;

		  SET @newitemNumber =@parentItemNumber+ '.' +  @nItemNumber ;
	 END

	 --update item number
	   UPDATE PRGRM000Master SET PrgItemNumber = @newitemNumber WHERE Id = @newProgramId;
       ---UPDATE ITEM NUMBER END                 
                      
     IF LEN(ISNULL(@configIds,'')) > 0                    
     BEGIN          
          EXEC CopyPPPModelTabs @recordId,@newProgramId,@configIds,@createdBy, @PacificDateTime                  
     END                  
                  
     IF @copyAll = 1                  
     BEGIN                  
                
     DECLARE @parentNodeString NVARCHAR(MAX) , @hLevel INT                  
     SELECT  @parentNodeString = PrgHierarchyID.ToString()+'%' ,@hLevel = PrgHierarchyLevel FROM PRGRM000Master WHERE Id = @recordId;                    
                      
 --Get the Child records                 
     DECLARE @PPIdTables TABLE(PrimaryId INT PRIMARY KEY IDENTITY(1,1),Id BIGINT);                    
     INSERT INTO @PPIdTables(Id)                   
     SELECT  Id FROM PRGRM000MASTER WHERE PrgHierarchyID.ToString() like @parentNodeString AND  PrgHierarchyLevel = (@hLevel + 1) ;                  
                        
     DECLARE @ppId INT  = 1            
                  
     DECLARE @recId BIGINT                  
     SELECT @recId = Id FROM @PPIdTables Where PrimaryId = @ppId;                  
                  
     WHILE EXISTS(SELECT Id FROM @PPIdTables Where PrimaryId = @ppId)                  
     BEGIN                 
                         
       Declare  @parentNode hierarchyid, @lc hierarchyid ;                  
                  
       SELECT  @custId = PrgCustId, @parentNode = [PrgHierarchyID] FROM  [dbo].[PRGRM000Master]  WHERE Id = @newProgramId;                   
                  
       SELECT @lc = max(PrgHierarchyID)  FROM   [dbo].[PRGRM000Master]   WHERE PrgHierarchyID.GetAncestor(1)  = @parentNode ;                   
                  
       DECLARE @HieId hierarchyid                  
       SET @HieId =  @parentNode.GetDescendant(@lc, NULL)                      
                        
        --Get Configutaion Ids                
        
 IF LEN(@configIds) = 0  
 BEGIN  
     SET @configIds = NULL;  
 END  
                
    SELECT @configIds = COALESCE(@configIds+',' ,'') + TabTableName   FROM [dbo].[SYSTM030Ref_TabPageName]                
     WHERE LangCode= @langCode AND  RefTablename = 'Program' And TabTableName <> 'Program'                
        AND TabTableName NOT IN (                
          SELECT RefTableName from [dbo].SYSTM000SecurityByRole Sbr                 
           INNER JOIN  [dbo].SYSTM010SubSecurityByRole subSbr ON sbr.Id  = subSbr.SecByRoleId     
		   INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) refRole ON sbr.[OrgRefRoleId] = refRole.[Id] 
		   INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysOrgRefRoleId =  refRole.Id         
           Where SM.SysUserContactID =@userId                 
           AND refRole.OrgId = @OrgId                 
           AND sbr.StatusID =1                 
           AND sbr.SecMainModuleId = 12                
           AND subSbr.StatusId =1                
        );
        
     EXEC CopyPPPLevel @recId , @custId , @OrgId , @configIds , @createdBy,@HieId ,@copyAll,@targetIds ,@langCode, @userId,@UdtCopyPPPModel,@PacificDateTime,@DestinationProgramCode,@DestinationProjectCode             
            
     SET  @ppId = @ppId + 1 ;            
                       
     END                  
       END             
    ELSE           
    BEGIN          
      -- loop the other records          
    DECLARE @ProjectPhaseTable TABLE(PrimaryId INT PRIMARY KEY IDENTITY(1,1),Id BIGINT);             
    --Insert Target PPP Ids or Customer Ids Into Table             
   INSERT INTO @ProjectPhaseTable(Id)              
   SELECT RecordId FROM @UdtCopyPPPModel Where ParentId = @recordId;             
          
   DECLARE @ppt Int ;          
   SET @ppt =1;          
   While EXISTS( SELECT Id FROM @ProjectPhaseTable  WHERE PrimaryId = @ppt)          
   BEGIN          
        DECLARE @childRecordId BIGINT ,@childIsSelected BIT ,@childConfigIds NVARCHAR(MAX), @childToIds NVARCHAR(MAX)            
        SELECT @childRecordId = Id FROM @ProjectPhaseTable  WHERE PrimaryId = @ppt          
          
                   
     SELECT @childRecordId = RecordId            
        ,@childIsSelected = SelectAll            
        ,@childConfigIds = ConfigurationIds            
        ,@childToIds = ToPPPIds            
      FROM @UdtCopyPPPModel Where RecordId = @childRecordId;          
          
              
          
          
   Declare  @childParentNode hierarchyid, @childlc hierarchyid ;                  
                  
   SELECT  @custId = PrgCustId, @childParentNode = [PrgHierarchyID] FROM  [dbo].[PRGRM000Master]  WHERE Id = @newProgramId;                   
                  
   SELECT @childlc = max(PrgHierarchyID)  FROM   [dbo].[PRGRM000Master]   WHERE PrgHierarchyID.GetAncestor(1)  = @childParentNode ;                   
                  
   DECLARE @ChildHierId hierarchyid                  
   SET @ChildHierId =  @childParentNode.GetDescendant(@childlc, NULL)                 
          
          
   --Create/Copy The new Project Or Phase           
   EXEC CopyPPPLevel @childRecordId , @custId , @OrgId , @childConfigIds , @createdBy,@ChildHierId ,@childIsSelected,@childToIds, @langCode ,@userId,@UdtCopyPPPModel,@DestinationProgramCode,@DestinationProjectCode ;          
          
      -- Increase primary Id next record loop          
   SET @ppt = @ppt + 1;          
                
                   
   END          
          
          
          
          
    END               
END TRY                                            
BEGIN CATCH                                            
                                            
  DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                                         
                                            
END CATCH

GO
